import SwiftUI

struct SplashView: View {
    // Controls when to move on
    @Binding var isActive: Bool
    // Animation state
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color(hex: "2D2F33")
                .ignoresSafeArea()
            Image("Logo")                   // your 512×512 logo asset
                .resizable()
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    // 1. Fade in & scale up
                    withAnimation(.easeOut(duration: 0.8)) {
                        self.opacity = 1.0
                        self.scale = 1.1
                    }
                    // 2. Slight bounce back
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.easeIn(duration: 0.4)) {
                            self.scale = 1.0
                        }
                    }
                    // 3. Hold then finish
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        self.isActive = false
                    }
                }
        }
    }
}

// Helper initializer to use hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF)/255
        let g = Double((int >> 8) & 0xFF)/255
        let b = Double(int & 0xFF)/255
        self.init(red: r, green: g, blue: b)
    }
}
