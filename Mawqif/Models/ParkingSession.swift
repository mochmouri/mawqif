import Foundation

struct ParkingSession: Equatable {
    let district: ParkingDistrict
    let startTime: Date
    var isPaid: Bool = false

    func elapsed(relativeTo now: Date = Date()) -> TimeInterval {
        now.timeIntervalSince(startTime)
    }

    func elapsedMinutes(relativeTo now: Date = Date()) -> Double {
        elapsed(relativeTo: now) / 60.0
    }

    func isInGrace(relativeTo now: Date = Date()) -> Bool {
        elapsedMinutes(relativeTo: now) < 15
    }

    func graceProgress(relativeTo now: Date = Date()) -> Double {
        min(elapsedMinutes(relativeTo: now) / 15.0, 1.0)
    }

    func graceSecondsRemaining(relativeTo now: Date = Date()) -> Int {
        max(0, 15 * 60 - Int(elapsed(relativeTo: now)))
    }

    func formattedElapsed(relativeTo now: Date = Date()) -> String {
        let total = Int(elapsed(relativeTo: now))
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }

    func formattedGraceRemaining(relativeTo now: Date = Date()) -> String {
        let rem = graceSecondsRemaining(relativeTo: now)
        let m = rem / 60
        let s = rem % 60
        return String(format: "%02d:%02d", m, s)
    }
}
