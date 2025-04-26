//
//  ActionButton.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import SwiftUI

struct ActionButton: View {
    enum Variant { case primary, secondary }

    let title: String
    let systemIcon: String
    let variant: Variant
    let action: () -> Void

    private var background: Color {
        switch variant {
        case .primary:   return .dark
        case .secondary: return Color.dark.opacity(0.15)
        }
    }
    
    private var foreground: Color {
        switch variant {
        case .primary:   return .white
        case .secondary: return .dark
        }
    }

    var body: some View {
        Button(action: action) {
            
            ZStack {
                Capsule()
                    .fill(background)
                HStack(spacing: 8) {
                    Image(systemName: systemIcon)
                        .imageScale(.large)
                        .foregroundColor(foreground)
                    
                    Text(title)
                        .foregroundColor(foreground)
                        .font(.headline.weight(.semibold))
                }
            }
            .frame(height: 45)
            .frame(maxWidth: .infinity)
        }
    }
}
