//
//  CoinDetailViewModel.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var coin: CoinDetail?
    @Published var coins: [Coin] = []
    @Published var stats: Stats?
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func loadDetail(for uuid: String) {
        isLoading = true
        CoinAPIClient.shared
            .fetchCoinDetail(uuid: uuid)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] detail in
                self?.coin = detail
            }
            .store(in: &cancellables)
    }
    
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
                self?.coins = returnedCoins
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
}
