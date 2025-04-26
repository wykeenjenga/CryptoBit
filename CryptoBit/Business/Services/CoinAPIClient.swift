//
//  CoinAPIClient.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import Foundation
import Combine

final class CoinAPIClient {
    static let shared = CoinAPIClient()
    private init() {}

    /// Fetch a single coin’s detail by its id.
    func fetchCoinDetail(uuid: String, timeRange: String) -> AnyPublisher<CoinDetail, APIError> {
        return APIGateway.shared
            .perform(path: "coin/\(uuid)", queryItems: [
                URLQueryItem(name: "timePeriod",  value: String(timeRange))
            ])
            .print("🔍 Detail")
            .map { (response: CoinDetailResponse) in response.data.coin }
            .eraseToAnyPublisher()
    }

    /// Fetch a paginated list of coins from the endpoint APAI
    func fetchCoins(offset: Int, limit: Int) -> AnyPublisher<[Coin], APIError> {
        let items = [
            URLQueryItem(name: "limit",  value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        return APIGateway.shared
            .perform(path: "coins", queryItems: items)
            .map { (response: CoinsListResponse) in response.data.coins }
            .eraseToAnyPublisher()
    }
    
    /// Fetches the raw response (stats + coinsds2)
    func fetchCoinsResponse(offset: Int, limit: Int) -> AnyPublisher<CoinsListResponse, APIError> {
        let items = [
            URLQueryItem(name: "limit",  value: String(limit)),
            URLQueryItem(name: "skip", value: String(offset))
        ]
        return APIGateway.shared
            .perform(path: "coins", queryItems: items)
            .eraseToAnyPublisher()
    }

}
