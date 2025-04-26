//
//  Color+Extension.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 23/04/2025.
//

import Foundation
import UIKit
import SwiftUI


extension Array where Element == Double {
  /// Insert `factor-1` evenly‐spaced values between each original pair
  func interpolated(factor: Int) -> [Double] {
    guard count > 1, factor > 1 else { return self }
    var out: [Double] = []
    for i in 0..<count-1 {
      let a = self[i], b = self[i+1]
      out.append(a)
      for j in 1..<factor {
        let t = Double(j) / Double(factor)
        out.append(a + (b - a) * t)
      }
    }
    out.append(self.last!)
    return out
  }
}

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

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        guard hexSanitized.count == 6,
              let rgb = UInt(hexSanitized, radix: 16) else {
            return nil
        }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >>  8) / 255.0
        let b = CGFloat( rgb & 0x0000FF       ) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
