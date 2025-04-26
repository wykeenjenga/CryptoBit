//
//  Array+Extension.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 23/04/2025.
//

import Foundation
import UIKit
import SwiftUI


extension Array where Element == Double {
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
