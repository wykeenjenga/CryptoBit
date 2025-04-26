//
//  CoinDetailViewModel.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import SwiftUI
import Charts
import Combine

// MARK: - ViewModel and Networking
final class CoinDetailViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var detail: CoinDetail?
    @Published var sparkline: [Double]?
    @Published var selectedRange: TimeRange = .twentyFour

    var supportsRangeSelection: Bool { true }

    private let uuid: String
    private var cancellables = Set<AnyCancellable>()

    init(uuid: String) {
        self.uuid = uuid
        $selectedRange
            .dropFirst()
            .sink { [weak self] _ in self?.fetchDetail() }
            .store(in: &cancellables)
    }

    func fetchDetail() {
        self.isLoading = true
        CoinAPIClient.shared
            .fetchCoinDetail(uuid: uuid, timeRange: selectedRange.rawValue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
                print("🔔 fetchDetail completed")
            } receiveValue: { [weak self] coin in
                print("🔔 got coin.price = \(coin.price)")
                self?.detail = coin
                let raw: [Double] = coin.sparklineValues.compactMap(Double.init)
                self?.sparkline = raw
            }
            .store(in: &cancellables)
    }
    
}


// MARK: - Time Range
enum TimeRange: String, CaseIterable, Identifiable {
    case oneHour = "1h"
    case threeHours = "3h"
    case twelveHours = "12h"
    case twentyFour = "24h"
    case sevenDays = "7d"
    case thirtyDays = "30d"
    case threeMonths = "3m"
    case oneYear = "1y"
    case threeYears = "3y"
    case fiveYears = "5y"

    var id: String { rawValue }

    static var `default`: TimeRange { .twentyFour }

    var displayName: String {
        switch self {
        case .oneHour:      return "1 Hr"
        case .threeHours:   return "3 Hrs"
        case .twelveHours:  return "12 Hrs"
        case .twentyFour:   return "24 Hrs"
        case .sevenDays:    return "7 Days"
        case .thirtyDays:   return "30 Days"
        case .threeMonths:  return "3 Months"
        case .oneYear:      return "1 Year"
        case .threeYears:   return "3 Years"
        case .fiveYears:    return "5 Years"
        }
    }
}


