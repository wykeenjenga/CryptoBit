//
//  FavListViewController.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import UIKit
import Combine
import SwiftUI

class FavListViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.register(FavCoinListCell.self)
            self.tableView.backgroundColor = .clear
        }
    }
    
    var searchUIView: UIHostingController<FilterSearchView>!

    let viewModel = FavListViewModel()
    let coinListViewModel = CoinListViewModel()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.tableFooterView = UIView()

        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchUIView = UIHostingController(rootView: FilterSearchView(viewModel: coinListViewModel))
        addChild(searchUIView)
        searchView.addSubview(searchUIView.view)
        searchUIView.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func bindViewModel() {
        viewModel.$favorites
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { msg in
                print("Core Data error:", msg)
            }
            .store(in: &cancellables)
    }
}

// MARK: – UITableViewDataSource
extension FavListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[FavCoinListCell.self, indexPath]
        let fav = viewModel.favorites[indexPath.row]
        cell.configure(with: fav)
        return cell
    }
}

// MARK: – UITableViewDelegate
extension FavListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let fav = viewModel.favorites[indexPath.row]
        let delete = UIContextualAction( style: .destructive, title: "Remove"){ [weak self] _, _, done in
            self?.viewModel.remove(fav)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = viewModel.favorites[indexPath.row]
        let detailView = CoinDetailView(uuid: coin.uuid ?? "")
        let hostingVC = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingVC, animated: true)
    }
}
