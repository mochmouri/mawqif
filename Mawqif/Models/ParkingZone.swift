import Foundation
import CoreLocation

struct ParkingDistrict: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let nameAr: String
    let paidFrom: String
    let paidTo: String
    let pricePerHour: Double
    let currency: String
    let polygon: [[Double]]  // [[lat, lng], ...]

    // Ray-casting point-in-polygon test.
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        guard polygon.count >= 3 else { return false }
        let x = coordinate.longitude
        let y = coordinate.latitude
        var inside = false
        var j = polygon.count - 1
        for i in 0..<polygon.count {
            let xi = polygon[i][1], yi = polygon[i][0]
            let xj = polygon[j][1], yj = polygon[j][0]
            if ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi) {
                inside = !inside
            }
            j = i
        }
        return inside
    }

    func localizedName(for language: AppLanguage) -> String {
        language == .arabic ? nameAr : name
    }

    static func == (lhs: ParkingDistrict, rhs: ParkingDistrict) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
