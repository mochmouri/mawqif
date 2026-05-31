import SwiftUI

struct MainView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var notificationManager: NotificationManager
    @AppStorage("appLanguage") private var langRaw: String = AppLanguage.english.rawValue

    // Tick the UI every second while a session is active
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var now = Date()

    private var lang: AppLanguage { AppLanguage(rawValue: langRaw) ?? .english }
    private var s: S { lang == .arabic ? .arabic : .english }
    private var isArabic: Bool { lang == .arabic }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        gpsStatusBar
                        statusCard
                        actionButtons
                        activitySection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(s.appName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 1) {
                        Text(s.appName)
                            .font(.headline.weight(.bold))
                        Text(s.appSubtitle)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    languageToggleButton
                }
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        .onReceive(ticker) { date in
            now = date
            locationManager.setLanguage(lang)
        }
    }

    // MARK: - GPS Status Bar

    private var gpsStatusBar: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(gpsIndicatorColor)
                .frame(width: 8, height: 8)
                .shadow(color: gpsIndicatorColor.opacity(0.6), radius: 4)

            Text(gpsStatusText)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)

            Spacer()

            if let coord = locationManager.lastCoordinate {
                Text(String(format: "%.4f, %.4f", coord.latitude, coord.longitude))
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var gpsIndicatorColor: Color {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return locationManager.lastCoordinate != nil ? .green : .orange
        default: return .secondary
        }
    }

    private var gpsStatusText: String {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return locationManager.lastCoordinate != nil ? s.gpsActive : s.gpsSearching
        default: return s.gpsNoPermission
        }
    }

    // MARK: - Status Card

    @ViewBuilder
    private var statusCard: some View {
        VStack(spacing: 0) {
            // Top: ring + label + zone name
            VStack(spacing: 14) {
                StatusRingView(ringState: ringState)
                    .padding(.top, 20)

                VStack(spacing: 6) {
                    Text(statusLabel)
                        .font(.system(.caption, design: .monospaced).weight(.semibold))
                        .tracking(2)
                        .foregroundStyle(statusLabelColor)
                        .textCase(.uppercase)

                    Text(zoneDisplayText)
                        .font(.subheadline.weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 20)
            }

            // Timer section — only shown when in zone
            if case .inZone(let session) = locationManager.state {
                timerSection(session: session)
            } else if case .paid(let session) = locationManager.state {
                paidSection(session: session)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Timer Section

    private func timerSection(session: ParkingSession) -> some View {
        let inGrace = session.isInGrace(relativeTo: now)
        let progress = session.graceProgress(relativeTo: now)
        let elapsed = session.formattedElapsed(relativeTo: now)
        let remaining = session.formattedGraceRemaining(relativeTo: now)

        return VStack(spacing: 0) {
            Divider()

            VStack(spacing: 14) {
                // Main timer
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(s.parkedFor)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .tracking(1)
                        Text(elapsed)
                            .font(.system(size: 38, weight: .semibold, design: .monospaced))
                            .foregroundStyle(timerColor(inGrace: inGrace, progress: progress))
                            .monospacedDigit()
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(inGrace ? s.gracePeriod : s.graceExpired)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .tracking(1)
                        if inGrace {
                            Text(remaining)
                                .font(.system(size: 24, weight: .medium, design: .monospaced))
                                .foregroundStyle(Color("GoldColor"))
                                .monospacedDigit()
                        } else {
                            Text("—")
                                .font(.system(size: 24, weight: .medium, design: .monospaced))
                                .foregroundStyle(.red)
                        }
                    }
                }

                // Progress bar
                VStack(spacing: 6) {
                    GraceProgressView(progress: progress, isExpired: !inGrace)

                    HStack {
                        Text(inGrace ? s.inGrace : s.graceExpired)
                            .font(.caption2)
                            .foregroundStyle(inGrace ? .green : .red)
                        Spacer()
                        Text("15 \(isArabic ? "دقيقة" : "min")")
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }

    // MARK: - Paid Section

    private func paidSection(session: ParkingSession) -> some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.parkedFor)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .tracking(1)
                    Text(session.formattedElapsed(relativeTo: now))
                        .font(.system(size: 38, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.green)
                        .monospacedDigit()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(s.rateLabel)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(.secondary)
                    Text(s.statusPaid)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.green)
                        .tracking(2)
                        .textCase(.uppercase)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }

    // MARK: - Action Buttons

    @ViewBuilder
    private var actionButtons: some View {
        switch locationManager.state {
        case .permissionRequired:
            EmptyView()

        case .inZone:
            HStack(spacing: 10) {
                // I Paid
                Button { locationManager.markPaid() } label: {
                    Label(s.btnIPaid, systemImage: "checkmark.circle.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .stroke(.green, lineWidth: 1)
                        )
                        .foregroundStyle(.green)
                }

                // Stop Session
                Button { locationManager.stopSession() } label: {
                    Label(s.btnStop, systemImage: "xmark.circle.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .stroke(.red, lineWidth: 1)
                        )
                        .foregroundStyle(.red)
                }
            }

        case .paid:
            HStack(spacing: 10) {
                // Pay Now (deep link)
                Link(destination: URL(string: "https://riyadhparking.sa/Booking")!) {
                    Label(s.btnPayNow, systemImage: "creditcard.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("GoldColor"), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .foregroundStyle(.black)
                }

                // Stop Session
                Button { locationManager.stopSession() } label: {
                    Label(s.btnStop, systemImage: "xmark.circle.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .stroke(.secondary.opacity(0.3), lineWidth: 1)
                        )
                        .foregroundStyle(.secondary)
                }
            }

        default:
            // Scanning / outsideZone / freeHours — show Pay Now link
            Link(destination: URL(string: "https://riyadhparking.sa/Booking")!) {
                Label(s.btnPayNow, systemImage: "creditcard.fill")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color("GoldColor").opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(Color("GoldColor"), lineWidth: 1)
                    )
                    .foregroundStyle(Color("GoldColor"))
            }
        }
    }

    // MARK: - Activity Log

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(s.activityTitle)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .tracking(2)
                Spacer()
                if !locationManager.activityLog.isEmpty {
                    Button {
                        withAnimation { locationManager.activityLog.removeAll() }
                    } label: {
                        Text(isArabic ? "مسح" : "CLEAR")
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if locationManager.activityLog.isEmpty {
                Text(s.activityEmpty)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(.tertiary)
                    )
            } else {
                VStack(spacing: 6) {
                    ForEach(locationManager.activityLog) { entry in
                        ActivityRow(entry: entry, s: s)
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: locationManager.activityLog.count)
            }
        }
    }

    // MARK: - Helpers

    private var ringState: StatusRingView.RingState {
        switch locationManager.state {
        case .permissionRequired: return .idle
        case .scanning:           return .scanning
        case .outsideZone:        return .idle
        case .freeHours:          return .freeHours
        case .paid:               return .paid
        case .inZone(let session):
            let mins = session.elapsedMinutes(relativeTo: now)
            if mins < 15 { return .grace }
            if mins < 20 { return .warning }
            return .danger
        }
    }

    private var statusLabel: String {
        switch locationManager.state {
        case .permissionRequired: return s.gpsNoPermission
        case .scanning:           return s.statusScanning
        case .outsideZone:        return s.statusNoZone
        case .freeHours:          return s.statusFreeHours
        case .paid:               return s.statusPaid
        case .inZone(let session):
            let mins = session.elapsedMinutes(relativeTo: now)
            if mins < 15 { return s.statusParked }
            if mins < 20 { return s.statusPayNow }
            return s.statusUnpaid
        }
    }

    private var statusLabelColor: Color {
        switch locationManager.state {
        case .paid:     return .green
        case .inZone(let session):
            let mins = session.elapsedMinutes(relativeTo: now)
            if mins < 15 { return Color("GoldColor") }
            if mins < 20 { return .orange }
            return .red
        default:        return .secondary
        }
    }

    private var zoneDisplayText: String {
        switch locationManager.state {
        case .permissionRequired:  return s.permTitle
        case .scanning:            return s.zones147
        case .outsideZone:         return s.noZoneNearby
        case .freeHours(let d):    return d.localizedName(for: lang) + " · " + s.freeUntil
        case .inZone(let session): return session.district.localizedName(for: lang)
        case .paid(let session):   return session.district.localizedName(for: lang)
        }
    }

    private func timerColor(inGrace: Bool, progress: Double) -> Color {
        if !inGrace { return .red }
        if progress > 0.8 { return .orange }
        return Color("GoldColor")
    }

    private var languageToggleButton: some View {
        Button {
            let current = AppLanguage(rawValue: langRaw) ?? .english
            langRaw = current.toggled.rawValue
        } label: {
            Text(lang.displayLabel)
                .font(.system(.caption, design: .monospaced).weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color("GoldColor").opacity(0.15),
                            in: RoundedRectangle(cornerRadius: 7, style: .continuous))
                .foregroundStyle(Color("GoldColor"))
        }
    }
}

// MARK: - Activity Row

private struct ActivityRow: View {
    let entry: LocationManager.ActivityEntry
    let s: S

    var body: some View {
        HStack(spacing: 10) {
            // Accent bar
            RoundedRectangle(cornerRadius: 2)
                .fill(accentColor)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 2) {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.primary)
                Text(formatted(timestamp: entry.timestamp))
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var message: String {
        switch entry {
        case .enteredZone(let d):    return "\(s.enteredZone): \(d.name)"
        case .leftZone(let d):       return "\(s.leftZone): \(d.name)"
        case .paid(let d):           return "\(s.markedPaid): \(d.name)"
        case .sessionStopped(let d): return "\(s.sessionStopped): \(d.name)"
        }
    }

    private var accentColor: Color {
        switch entry {
        case .enteredZone: return Color("GoldColor")
        case .leftZone:    return .green
        case .paid:        return .green
        case .sessionStopped: return .secondary
        }
    }

    private func formatted(timestamp: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: timestamp)
    }
}

#Preview {
    MainView()
        .environmentObject(LocationManager())
        .environmentObject(NotificationManager.shared)
}
