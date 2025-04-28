//
//  CoinDetailViewModel.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import Foundation
import Combine
import CoreData

class CoinListViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    @Published private(set) var favorites: Set<String> = []
    

    @Published var coins: [Coin] = []
    @Published var stats: Stats?
    @Published var filteredCoins: [Coin] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let context = CoreDataManager.shared.context
    
    init() {
        fetchFavorites()
    }
    
    //MARK: - filters
    
    func sortByPriceDescending() {
        coins.sort {
            (Double($0.price) ?? 0) > (Double($1.price) ?? 0)
        }
    }
    
    func sortByChangeDescending() {
        coins.sort {
            (Double($0.change) ?? 0) > (Double($1.change) ?? 0)
        }
    }

    func onSearch(with text: String) {
        self.filteredCoins.removeAll()
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else {
            filteredCoins = coins
            isSearching = false
            return
        }
        isSearching = true
        let lower = t.lowercased()
        for coin in coins {
            if coin.symbol.lowercased().contains(lower) || coin.symbol.lowercased().contains(lower){
                self.filteredCoins.append(coin)
            }
        }
    }
    
    //MARK: - functioos
    func loadCoins(offset: Int = 0, limit: Int = 20) {
        isLoading = true
        CoinAPIClient.shared
            .fetchCoins(offset: offset, limit: limit)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] returnedCoins in
                if offset == 0 {
                    self?.coins = returnedCoins
                } else {
                    self?.coins.append(contentsOf: returnedCoins)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadCoinsAndStats(offset: Int = 0, limit: Int = 20) {
        isLoading = true
        CoinAPIClient.shared
            .fetchCoinsResponse(offset: offset, limit: limit)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.stats = response.data.stats
                self?.coins = response.data.coins
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Local DB
    
    private func fetchFavorites() {
        let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
        do {
            let favObjects = try context.fetch(request)
            favorites = Set(favObjects.compactMap { $0.uuid })
        } catch {
            print("Fetch favorites error:", error)
        }
    }
    
    func toggleFavorite(_ coin: Coin) {
        let uuid = coin.uuid
        
        if favorites.contains(uuid) {
            let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
            request.predicate = NSPredicate(format: "uuid == %@", uuid)
            if let toDelete = try? context.fetch(request).first {
                context.delete(toDelete)
            }
        } else {
            let fav = FavoriteCoin(context: context)
            fav.uuid = uuid
        }
        
        CoreDataManager.shared.saveContext()
        fetchFavorites()
    }
    
}
