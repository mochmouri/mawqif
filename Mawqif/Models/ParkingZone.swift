import Foundation
import CoreLocation

struct ParkingZone: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let street: String
    let lat: Double
    let lng: Double
    let radius: Double
    let freeFrom: String
    let freeTo: String
    let paidFrom: String
    let paidTo: String
    let pricePerHour: Double
    let currency: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

    // Short display name: strip "Zone XXX - " prefix if present
    var displayName: String {
        if let range = name.range(of: #"^Zone \w+\s*[-–]\s*"#, options: .regularExpression) {
            return String(name[range.upperBound...])
        }
        return name
    }
}
