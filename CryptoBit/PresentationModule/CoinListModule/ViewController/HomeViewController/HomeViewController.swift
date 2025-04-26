//
//  ViewController.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 23/04/2025.
//

import UIKit
import Combine
import SwiftUI

class HomeViewController: UIViewController {

    @IBOutlet weak var searchFilterView: UIView!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.register(CoinCell.self)
            self.tableView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var filterHost: UIHostingController<FilterSearchView>!
    
    // MARK: – ViewModel
    private let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        bindViewModel()
        viewModel.loadCoins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        embedFilterSearchView()
    }
    
    func bindViewModel() {
        // Show/hide spinner
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            }
            .store(in: &cancellables)
        
        // Reload table when coins arrive
        viewModel.$coins
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$filteredCoins
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Show errors to user.
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] msg in
                let alert = UIAlertController(title: "Error",
                                              message: msg,
                                              preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
    
    
    private func setupLayout() {
        tableView.dataSource = self
        tableView.delegate   = self
    }


    
    private func embedFilterSearchView() {
      filterHost = UIHostingController(rootView: FilterSearchView(viewModel: viewModel))
      addChild(filterHost)
      searchFilterView.addSubview(filterHost.view)
      filterHost.view.translatesAutoresizingMaskIntoConstraints = false
    }
}



// MARK: – UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filteredCoins.count : viewModel.coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[CoinCell.self, indexPath]
        let coin = viewModel.isSearching ? viewModel.filteredCoins[indexPath.row] : viewModel.coins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }

}

// MARK: – UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let threshold = scrollView.contentSize.height - scrollView.bounds.height - 100
        if scrollView.contentOffset.y > threshold && !viewModel.isLoading {
            viewModel.loadCoins(offset: viewModel.coins.count, limit: 20)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = viewModel.coins[indexPath.row]
        
        let detailView = CoinDetailView(uuid: coin.uuid)
        
        let hostingVC = UIHostingController(rootView: detailView)
        
        navigationController?.pushViewController(hostingVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath ) -> UISwipeActionsConfiguration? {
        let coin = viewModel.coins[indexPath.row]
        
        let favAction = UIContextualAction(style: .normal, title: "★ Add to Favorite") { [weak self] _, _, completion in
            self?.viewModel.toggleFavorite(coin)
            completion(true)
        }
        
        favAction.backgroundColor = UIColor(hex: "#2D2F33")
        
        return UISwipeActionsConfiguration(actions: [favAction])
    }
}
