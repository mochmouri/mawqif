import SwiftUI

// Pulsing ring indicator — shows current parking state visually.
struct StatusRingView: View {
    let ringState: RingState

    enum RingState {
        case idle
        case scanning
        case freeHours
        case grace        // in-zone, within 15 min
        case warning      // grace just expired
        case danger       // well past grace
        case paid
    }

    @State private var pulsing = false

    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(ringColor.opacity(0.25), lineWidth: 1.5)
                .frame(width: 90, height: 90)
                .scaleEffect(pulsing ? 1.1 : 1.0)
                .opacity(pulsing ? 0.4 : 1.0)
                .animation(pulseAnimation, value: pulsing)

            // Inner ring
            Circle()
                .stroke(ringColor, lineWidth: 1.5)
                .frame(width: 72, height: 72)

            // Icon
            Text(icon)
                .font(.system(size: 30))
        }
        .onAppear { startPulse() }
        .onChange(of: ringState) { startPulse() }
    }

    private var icon: String {
        switch ringState {
        case .idle:      return "🔍"
        case .scanning:  return "📡"
        case .freeHours: return "🌙"
        case .grace:     return "⏱"
        case .warning:   return "⚠️"
        case .danger:    return "🚨"
        case .paid:      return "✅"
        }
    }

    private var ringColor: Color {
        switch ringState {
        case .idle, .scanning: return Color(.systemFill)
        case .freeHours:       return .secondary
        case .grace:           return Color("GoldColor")
        case .warning:         return .orange
        case .danger:          return .red
        case .paid:            return .green
        }
    }

    private var pulseAnimation: Animation? {
        switch ringState {
        case .grace:   return .easeInOut(duration: 2).repeatForever(autoreverses: true)
        case .warning: return .easeInOut(duration: 1).repeatForever(autoreverses: true)
        case .danger:  return .easeInOut(duration: 0.5).repeatForever(autoreverses: true)
        default:       return nil
        }
    }

    private func startPulse() {
        pulsing = false
        switch ringState {
        case .grace, .warning, .danger:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.pulsing = true
            }
        default:
            break
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        StatusRingView(ringState: .idle)
        StatusRingView(ringState: .grace)
        StatusRingView(ringState: .danger)
        StatusRingView(ringState: .paid)
    }
    .padding()
}
