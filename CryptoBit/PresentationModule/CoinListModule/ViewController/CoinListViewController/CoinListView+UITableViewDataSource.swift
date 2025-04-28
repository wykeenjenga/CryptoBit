//
//  CoinListViewController+UITableViewDataSource.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import SwiftUI
import UIKit

// MARK: – UITableViewDataSource
extension CoinListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filteredCoins.count : viewModel.coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[CoinListCell.self, indexPath]

        let data = viewModel.isSearching ? viewModel.filteredCoins : viewModel.coins
        guard indexPath.row < data.count else {
            return cell
        }

        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    

}
