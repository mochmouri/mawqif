import Foundation
import UserNotifications

final class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()

    @Published var permissionGranted: Bool = false

    private let center = UNUserNotificationCenter.current()

    private enum NotifID {
        static let fiveMin  = "mawqif.reminder.5min"
        static let tenMin   = "mawqif.reminder.10min"
    }

    private override init() {
        super.init()
        center.delegate = self
        checkPermission()
    }

    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.permissionGranted = granted
            }
        }
    }

    private func checkPermission() {
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.permissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }

    // Schedule both reminders based on the session start time.
    func scheduleReminders(for session: ParkingSession, language: AppLanguage) {
        cancelAllReminders()

        let fiveMinDate  = session.startTime.addingTimeInterval(5 * 60)
        let tenMinDate   = session.startTime.addingTimeInterval(10 * 60)

        let zoneName = session.zone.displayName

        schedule(id: NotifID.fiveMin,
                 title: language == .arabic
                    ? "تذكير بالموقف — ٥ دقائق"
                    : "Parking Reminder — 5 min",
                 body: language == .arabic
                    ? "لقيت سيارتك في \(zoneName) — هل دفعت؟ (٣٫٤٥ ريال/ساعة)"
                    : "Parked at \(zoneName). Did you pay? 3.45 SAR/hr",
                 at: fiveMinDate)

        schedule(id: NotifID.tenMin,
                 title: language == .arabic
                    ? "تذكير بالموقف — ١٠ دقائق ⚠️"
                    : "Parking Reminder — 10 min ⚠️",
                 body: language == .arabic
                    ? "فترة السماح تنتهي بعد ٥ دقائق في \(zoneName)!"
                    : "Grace period ends in 5 min at \(zoneName)!",
                 at: tenMinDate)
    }

    func cancelAllReminders() {
        center.removePendingNotificationRequests(withIdentifiers: [NotifID.fiveMin, NotifID.tenMin])
    }

    // MARK: - Private

    private func schedule(id: String, title: String, body: String, at date: Date) {
        guard date > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.interruptionLevel = .timeSensitive

        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        center.add(request)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
