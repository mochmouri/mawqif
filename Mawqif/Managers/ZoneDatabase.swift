import Foundation
import CoreLocation

final class ZoneDatabase {
    static let shared = ZoneDatabase()

    private(set) var districts: [ParkingDistrict] = []

    private init() {
        load()
    }

    private func load() {
        guard let url = Bundle.main.url(forResource: "parking_zones", withExtension: "json") else {
            assertionFailure("parking_zones.json not found in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            districts = try JSONDecoder().decode([ParkingDistrict].self, from: data)
        } catch {
            assertionFailure("Failed to decode parking_zones.json: \(error)")
        }
    }

    func district(containing coordinate: CLLocationCoordinate2D) -> ParkingDistrict? {
        districts.first { $0.contains(coordinate) }
    }
}
