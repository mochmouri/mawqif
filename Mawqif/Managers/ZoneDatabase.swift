import Foundation
import CoreLocation

final class ZoneDatabase {
    static let shared = ZoneDatabase()

    private(set) var zones: [ParkingZone] = []

    private init() {
        loadZones()
    }

    private func loadZones() {
        guard let url = Bundle.main.url(forResource: "parking_zones", withExtension: "json") else {
            assertionFailure("parking_zones.json not found in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            zones = try JSONDecoder().decode([ParkingZone].self, from: data)
        } catch {
            assertionFailure("Failed to decode parking_zones.json: \(error)")
        }
    }

    // Returns the closest zone whose radius contains the coordinate, or nil.
    func nearestZone(at coordinate: CLLocationCoordinate2D) -> (zone: ParkingZone, distance: Double)? {
        var best: (zone: ParkingZone, distance: Double)? = nil
        for zone in zones {
            let d = haversine(lat1: coordinate.latitude, lng1: coordinate.longitude,
                              lat2: zone.lat, lng2: zone.lng)
            if d <= zone.radius {
                if best == nil || d < best!.distance {
                    best = (zone, d)
                }
            }
        }
        return best
    }

    // Haversine great-circle distance in metres.
    static func haversine(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        let R = 6_371_000.0
        let dLat = (lat2 - lat1) * .pi / 180
        let dLng = (lng2 - lng1) * .pi / 180
        let a = sin(dLat / 2) * sin(dLat / 2)
            + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180)
            * sin(dLng / 2) * sin(dLng / 2)
        return R * 2 * atan2(sqrt(a), sqrt(1 - a))
    }

    private func haversine(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        Self.haversine(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2)
    }
}
