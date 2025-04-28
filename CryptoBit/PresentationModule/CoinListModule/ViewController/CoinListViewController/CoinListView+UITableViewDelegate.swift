//
//  CoinListView+UITableViewDelegate.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import SwiftUI
import UIKit

// MARK: – UITableViewDelegate
extension CoinListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = scrollView.contentSize.height - scrollView.bounds.height - 100
        if scrollView.contentOffset.y > threshold && !viewModel.isLoading {
            if viewModel.coins.count < 100 {
                viewModel.loadCoins(offset: viewModel.coins.count, limit: 20)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = viewModel.isSearching ? viewModel.filteredCoins[indexPath.row] : viewModel.coins[indexPath.row]
        let detailView = CoinDetailView(uuid: coin.uuid)
        let hostingVC = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath ) -> UISwipeActionsConfiguration? {
        let coin = viewModel.isSearching ? viewModel.filteredCoins[indexPath.row] : viewModel.coins[indexPath.row]
        let favAction = UIContextualAction(style: .normal, title: "Add to Favorite") { [weak self] _, _, completion in
            self?.viewModel.toggleFavorite(coin)
            completion(true)
        }
        favAction.backgroundColor = UIColor(hex: "#2D2F33")
        return UISwipeActionsConfiguration(actions: [favAction])
    }
}
