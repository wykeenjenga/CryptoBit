//
//  Stats.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


// Models/Stats.swift
import Foundation

struct Stats: Decodable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    let totalExchanges: Int
    let totalMarketCap: String
    let total24hVolume: String
}
