import SwiftUI

// Thin progress bar showing how much of the 15-minute grace period has elapsed.
struct GraceProgressView: View {
    let progress: Double  // 0…1
    let isExpired: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemFill))
                    .frame(height: 3)

                Capsule()
                    .fill(barColor)
                    .frame(width: geo.size.width * progress, height: 3)
                    .animation(.linear(duration: 1), value: progress)
            }
        }
        .frame(height: 3)
    }

    private var barColor: Color {
        if isExpired { return .red }
        if progress > 0.8 { return .orange }
        return Color("GoldColor")
    }
}
