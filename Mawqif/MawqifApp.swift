import SwiftUI

@main
struct MawqifApp: App {
    @StateObject private var locationManager = LocationManager()

    init() {
        // Request notification permission early
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(NotificationManager.shared)
        }
    }
}
