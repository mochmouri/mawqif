import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @AppStorage("appLanguage") private var langRaw: String = AppLanguage.english.rawValue
    private var isArabic: Bool { langRaw == AppLanguage.arabic.rawValue }

    var body: some View {
        Group {
            if locationManager.authorizationStatus == .notDetermined ||
               locationManager.authorizationStatus == .denied ||
               locationManager.authorizationStatus == .restricted {
                PermissionView()
                    .environmentObject(locationManager)
            } else {
                MainView()
                    .environmentObject(locationManager)
                    .environmentObject(NotificationManager.shared)
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}
