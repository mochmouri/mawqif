import SwiftUI

struct PermissionView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @AppStorage("appLanguage") private var langRaw: String = AppLanguage.english.rawValue
    private var lang: AppLanguage { AppLanguage(rawValue: langRaw) ?? .english }
    private var s: S { lang == .arabic ? .arabic : .english }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color("GoldColor").opacity(0.15))
                    .frame(width: 80, height: 80)
                Text("📍")
                    .font(.system(size: 38))
            }

            // Text
            VStack(spacing: 12) {
                Text(s.permTitle)
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)

                Text(s.permBody)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            // Buttons
            VStack(spacing: 12) {
                Button {
                    locationManager.requestAlwaysPermission()
                } label: {
                    Text(s.permAlways)
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color("GoldColor"))
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                }

                if locationManager.authorizationStatus == .denied ||
                   locationManager.authorizationStatus == .restricted {
                    Button {
                        locationManager.openAppSettings()
                    } label: {
                        Text(s.btnOpenSettings)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color("GoldColor"))
                    }
                }
            }

            // Fine print
            Text(s.permNote)
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            Spacer()
        }
        .padding(.horizontal, 28)
    }
}
