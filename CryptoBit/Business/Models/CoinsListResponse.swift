//
//  CoinsListResponse.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import Foundation

struct CoinsListResponse: Decodable {
    let status: String
    let data: CoinsListData
}

struct CoinsListData: Decodable {
    let stats: Stats
    let coins: [Coin]
}
