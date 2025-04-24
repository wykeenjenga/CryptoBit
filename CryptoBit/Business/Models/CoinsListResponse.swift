// Models/CoinsListResponse.swift
import Foundation

struct CoinsListResponse: Decodable {
    let status: String
    let data: CoinsListData
}

struct CoinsListData: Decodable {
    let stats: Stats
    let coins: [Coin]
}
