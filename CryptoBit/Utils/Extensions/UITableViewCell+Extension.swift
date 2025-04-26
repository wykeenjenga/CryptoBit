//
//  UITableViewCell+Extension.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import UIKit
import CoreData

extension UITableViewCell {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension NSManagedObject {
    public static var identifier: String {
        return String(describing: self)
    }
}
