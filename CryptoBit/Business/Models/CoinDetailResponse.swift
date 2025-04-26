//
//  CoinDetailResponse 2.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import Foundation

struct CoinDetailResponse: Decodable {
    let status: String
    let data: CoinDetailData
}

struct CoinDetailData: Decodable {
    let coin: CoinDetail
}

struct CoinDetail: Identifiable, Decodable {
    let uuid: String
    var id: String { uuid }

    let symbol: String?
    let name: String?
    let description: String?
    let color: String?
    let iconUrl: String?
    let websiteUrl: String?
    let links: [Link]
    let supply: Supply?
    let volume24h: String?

    let marketCap: String?
    let fullyDilutedMarketCap: String?
    let price: String?
    let btcPrice: String?
    let priceAt: TimeInterval
    let change: String?
    let rank: Int?
    let numberOfMarkets: Int?
    let numberOfExchanges: Int?
    let sparkline: [String?]?
    let allTimeHigh: AllTimeHigh?
    let coinrankingUrl: String?
    var lowVolume: Bool = false
    let listedAt: TimeInterval?
    var contractAddresses: [String] = []
    let tags: [String]
    
    var sparklineValues: [String] {
        sparkline?.compactMap { $0 } ?? []
    }

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color, iconUrl, websiteUrl, links, supply
        case volume24h = "24hVolume"
        case marketCap
        case fullyDilutedMarketCap
        case price, btcPrice, priceAt, change, rank
        case numberOfMarkets, numberOfExchanges, sparkline, allTimeHigh
        case coinrankingUrl, lowVolume, listedAt, contractAddresses, tags
    }
}

struct Link: Decodable {
    let name: String?
    let url: String?
    let type: String?
}

struct Supply: Decodable {
    let confirmed: Bool?
    let supplyAt: TimeInterval?
    let circulating: String?
    let total: String?
    let max: String?
}

struct AllTimeHigh: Decodable {
    let price: String?
    let timestamp: TimeInterval?
}

