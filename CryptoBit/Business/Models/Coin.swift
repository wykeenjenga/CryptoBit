//
//  Coin.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import Foundation

struct Coin: Identifiable, Decodable {
    let uuid: String
    var id: String { uuid }

    let symbol: String
    let name: String
    let color: String?
    let iconUrl: String?
    let marketCap: String
    let price: String
    let listedAt: TimeInterval
    let change: String
    let rank: Int
    let sparkline: [String?]?
    let lowVolume: Bool
    let coinrankingUrl: URL?
    let volume24h: String
    let btcPrice: String
    let tier: Int?
    let contractAddresses: [String]
    
    var sparklineValues: [String] {
        sparkline?.compactMap { $0 } ?? []
    }

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, listedAt,
             change, rank, sparkline, lowVolume, coinrankingUrl,
             btcPrice, tier, contractAddresses
        case volume24h = "24hVolume"
    }
}
