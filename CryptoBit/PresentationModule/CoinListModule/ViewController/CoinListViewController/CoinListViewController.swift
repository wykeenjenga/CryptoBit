//
//  ViewController.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 23/04/2025.
//

import UIKit
import Combine
import SwiftUI
import SkeletonView

class CoinListViewController: UIViewController {

    @IBOutlet weak var searchFilterView: UIView!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.register(CoinListCell.self)
            self.tableView.backgroundColor = .clear
        }
    }
    
    var searchUIView: UIHostingController<FilterSearchView>!
    
    // MARK: – ViewModel
    let viewModel = CoinListViewModel()
    var cancellables = Set<AnyCancellable>()
    
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
                loading ? self?.tableView.showAnimatedGradientSkeleton() : self?.tableView.hideSkeleton()
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
        
        let gradient = SkeletonGradient(baseColor: UIColor.gray)
        tableView.showGradientSkeleton(usingGradient: gradient)
    }
    
    private func embedFilterSearchView() {
        searchUIView = UIHostingController(rootView: FilterSearchView(viewModel: viewModel))
        addChild(searchUIView)
        searchFilterView.addSubview(searchUIView.view)
        searchUIView.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

