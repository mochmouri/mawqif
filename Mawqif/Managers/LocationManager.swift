import Foundation
import CoreLocation
import UIKit

// MARK: - App State

enum ParkingAppState: Equatable {
    case permissionRequired
    case scanning
    case outsideZone
    case freeHours(ParkingZone)
    case inZone(ParkingSession)
    case paid(ParkingSession)

    static func == (lhs: ParkingAppState, rhs: ParkingAppState) -> Bool {
        switch (lhs, rhs) {
        case (.permissionRequired, .permissionRequired): return true
        case (.scanning, .scanning): return true
        case (.outsideZone, .outsideZone): return true
        case (.freeHours(let a), .freeHours(let b)): return a == b
        case (.inZone(let a), .inZone(let b)): return a == b
        case (.paid(let a), .paid(let b)): return a == b
        default: return false
        }
    }
}

// MARK: - LocationManager

final class LocationManager: NSObject, ObservableObject {

    // MARK: Published

    @Published var state: ParkingAppState = .permissionRequired
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastCoordinate: CLLocationCoordinate2D?
    @Published var activityLog: [ActivityEntry] = []

    // MARK: Private

    private let clManager = CLLocationManager()
    private var language: AppLanguage = .english

    // MARK: Init

    override init() {
        super.init()
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyBest
        clManager.distanceFilter = 15 // metres
        authorizationStatus = clManager.authorizationStatus
        applyAuthorizationStatus(clManager.authorizationStatus)
    }

    // MARK: Public API

    func setLanguage(_ lang: AppLanguage) {
        language = lang
    }

    func requestAlwaysPermission() {
        clManager.requestAlwaysAuthorization()
    }

    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func markPaid() {
        guard case .inZone(var session) = state else { return }
        session.isPaid = true
        NotificationManager.shared.cancelAllReminders()
        state = .paid(session)
        addLog(.paid(session.zone))
    }

    func stopSession() {
        NotificationManager.shared.cancelAllReminders()
        if case .inZone(let session) = state {
            addLog(.sessionStopped(session.zone))
        } else if case .paid(let session) = state {
            addLog(.sessionStopped(session.zone))
        }
        if let coord = lastCoordinate {
            evaluateZone(at: coord)
        } else {
            state = .scanning
        }
    }

    // MARK: - Private helpers

    private func applyAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            state = .scanning
            clManager.startUpdatingLocation()
            if status == .authorizedAlways {
                clManager.startMonitoringSignificantLocationChanges()
            }
        case .notDetermined:
            state = .permissionRequired
        case .denied, .restricted:
            state = .permissionRequired
        @unknown default:
            break
        }
    }

    private func evaluateZone(at coord: CLLocationCoordinate2D) {
        guard isMonitoringActive() else { return }

        let now = Date()

        // Silent periods: outside paid hours, Fridays, public holidays
        guard isPaidHours(now) && !isFriday(now) && !isSaudiHoliday(now) else {
            if let (zone, _) = ZoneDatabase.shared.nearestZone(at: coord) {
                state = .freeHours(zone)
            } else {
                state = .outsideZone
            }
            return
        }

        guard let (zone, _) = ZoneDatabase.shared.nearestZone(at: coord) else {
            // Left any zone
            switch state {
            case .inZone(let session):
                NotificationManager.shared.cancelAllReminders()
                addLog(.leftZone(session.zone))
                state = .outsideZone
            case .paid(let session):
                addLog(.leftZone(session.zone))
                state = .outsideZone
            default:
                state = .outsideZone
            }
            return
        }

        // Inside a zone during paid hours
        switch state {
        case .inZone(let session):
            if session.zone == zone {
                // Same zone — notifications already scheduled via UNCalendar; nothing extra needed
                state = .inZone(session)
            } else {
                // Moved to a different zone
                NotificationManager.shared.cancelAllReminders()
                addLog(.leftZone(session.zone))
                let newSession = ParkingSession(zone: zone, startTime: now)
                NotificationManager.shared.scheduleReminders(for: newSession, language: language)
                addLog(.enteredZone(zone))
                state = .inZone(newSession)
            }

        case .paid(let session):
            if session.zone != zone {
                // Drove to a different zone after paying
                let newSession = ParkingSession(zone: zone, startTime: now)
                NotificationManager.shared.scheduleReminders(for: newSession, language: language)
                addLog(.enteredZone(zone))
                state = .inZone(newSession)
            }
            // Otherwise keep paid state

        case .freeHours, .scanning, .outsideZone, .permissionRequired:
            // Fresh entry into a zone
            let newSession = ParkingSession(zone: zone, startTime: now)
            NotificationManager.shared.scheduleReminders(for: newSession, language: language)
            addLog(.enteredZone(zone))
            state = .inZone(newSession)
        }
    }

    private func isMonitoringActive() -> Bool {
        authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }

    // Paid hours: 08:00 – 00:00 (midnight = end of day)
    private func isPaidHours(_ date: Date) -> Bool {
        let h = Calendar.current.component(.hour, from: date)
        return h >= 8 // 8am to 11pm inclusive; midnight (0) is outside
    }

    // Friday = weekday 6 in Gregorian (Sun=1…Sat=7)
    private func isFriday(_ date: Date) -> Bool {
        Calendar.current.component(.weekday, from: date) == 6
    }

    // Saudi public holidays (hardcoded for 2025–2026)
    private func isSaudiHoliday(_ date: Date) -> Bool {
        let cal = Calendar.current
        let m = cal.component(.month, from: date)
        let d = cal.component(.day, from: date)
        let y = cal.component(.year, from: date)

        // Fixed annual holidays
        if m == 2 && d == 22 { return true }  // Founding Day
        if m == 9 && d == 23 { return true }  // National Day

        // Lunar holidays — approximate Gregorian dates 2025
        if y == 2025 {
            // Eid Al Fitr: Mar 30 – Apr 2
            if (m == 3 && d >= 30) || (m == 4 && d <= 2) { return true }
            // Eid Al Adha: Jun 6–9
            if m == 6 && d >= 6 && d <= 9 { return true }
        }
        // Approximate 2026
        if y == 2026 {
            // Eid Al Fitr: Mar 19–22
            if m == 3 && d >= 19 && d <= 22 { return true }
            // Eid Al Adha: May 26–29
            if m == 5 && d >= 26 && d <= 29 { return true }
        }
        return false
    }

    // MARK: - Activity log

    enum ActivityEntry: Identifiable {
        case enteredZone(ParkingZone)
        case leftZone(ParkingZone)
        case paid(ParkingZone)
        case sessionStopped(ParkingZone)

        var id: UUID { UUID() }
        var timestamp: Date { Date() }
    }

    private func addLog(_ entry: ActivityEntry) {
        DispatchQueue.main.async {
            self.activityLog.insert(entry, at: 0)
            if self.activityLog.count > 40 {
                self.activityLog = Array(self.activityLog.prefix(40))
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            self.applyAuthorizationStatus(manager.authorizationStatus)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last, loc.horizontalAccuracy < 100 else { return }
        DispatchQueue.main.async {
            self.lastCoordinate = loc.coordinate
            self.evaluateZone(at: loc.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Non-fatal — location updates will retry automatically
    }
}
