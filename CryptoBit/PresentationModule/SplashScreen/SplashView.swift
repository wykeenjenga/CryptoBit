//
//  SplashView.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 23/04/2025.
//


import SwiftUI
import SwiftUI


struct StoryboardViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "navigationController")
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct SplashView: View {
    @State private var isCompleted = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0.0
    @State private var showTitle = false

    var body: some View {
        Group {
            if isCompleted {
                StoryboardViewController()
            } else {
                ZStack {
                    Color(hex: Colors.dark_gray)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Image("app_logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)

                        if showTitle {
                            HStack(alignment: .center, spacing: 0){
                                Spacer()
                                Text("Crypto")
                                    .font(.largeTitle).bold()
                                    .foregroundColor(.white)
                                    .transition(.opacity.combined(with: .scale))
                                Text("Bit")
                                    .font(.largeTitle).bold()
                                    .foregroundColor(.accentColor)
                                    .transition(.opacity.combined(with: .scale))
                                Spacer()
                            }
                        }
                    }
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8)) {
                        logoOpacity = 1
                        logoScale   = 1.1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.easeIn(duration: 0.4)) {
                            logoScale = 1.0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeIn(duration: 0.5)) {
                            showTitle = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isCompleted = true
                    }
                }
            }
        }
    }
}

