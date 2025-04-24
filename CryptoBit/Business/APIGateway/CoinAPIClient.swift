//
//  CoinAPIClient.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


// Services/CoinAPIClient.swift
import Foundation
import Combine

final class CoinAPIClient {
    static let shared = CoinAPIClient()
    private let baseURL = URL(string: "https://api.coinranking.com/v2/")!
    private let apiKey = "your-api-key"     // ← replace with your actual key
    
    private init() {}

    /// Fetches detailed info for a single coin by UUID.
    func fetchCoinDetail(uuid: String) -> AnyPublisher<CoinDetail, Error> {
        // Build URL: https://api.coinranking.com/v2/coin/{uuid}
        let url = baseURL.appendingPathComponent("coin/\(uuid)")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = []  // you could add '?someParam=…' if needed
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: CoinDetailResponse.self, decoder: JSONDecoder())
            .map { $0.data.coin }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
