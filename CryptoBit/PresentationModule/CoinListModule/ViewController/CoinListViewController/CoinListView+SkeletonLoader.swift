//
//  CoinListView+SkeletonLoader.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import SwiftUI
import UIKit
import SkeletonView

extension CoinListViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CoinListCell"
    }
}
