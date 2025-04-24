//
//  Coin.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


// Models/Coin.swift
import Foundation

struct Coin: Identifiable, Decodable {
    // Use uuid as the SwiftUI/Identifiable id
    let uuid: String
    var id: String { uuid }

    let symbol: String
    let name: String
    let color: String?
    let iconUrl: URL?
    let marketCap: String
    let price: String
    let listedAt: TimeInterval
    let change: String
    let rank: Int
    let sparkline: [String]?
    let lowVolume: Bool
    let coinrankingUrl: URL?
    let volume24h: String
    let btcPrice: String
    let tier: Int?
    let contractAddresses: [String]

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, listedAt,
             change, rank, sparkline, lowVolume, coinrankingUrl,
             btcPrice, tier, contractAddresses
        case volume24h = "24hVolume"
    }
}
