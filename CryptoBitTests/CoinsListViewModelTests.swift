//
//  CoinsListViewModelTests.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 28/04/2025.
//


import XCTest
import CoreData
@testable import CryptoBit

final class CoinListViewModelFavoritesTests: XCTestCase {
    var viewModel: CoinListViewModel!
    var container: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        container = NSPersistentContainer(name: "CryptoBit")
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [desc]

        let exp = expectation(description: "Load In-Memory Store")
        container.loadPersistentStores { storeDescription, error in
            XCTAssertNil(error, "Failed to load in-memory store: \(error!)")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        viewModel = CoinListViewModel(context: container.viewContext)
    }

    func testToggleFavorite_AddsAndRemovesCoin() {
        
        ///sample coin
        let testCoin = CryptoBit.Coin(
            uuid: "Qwsogvtv82FCd",
            symbol: "BTC",
            name: "Bitcoin",
            color: "#f7931A",
            iconUrl:"https://cdn.coinranking.com/Sy33Krudb/btc.svg",
            marketCap: "159393904304",
            price: "9370.9993109108",
            listedAt: 1483228800,
            change: "-0.52",
            rank: 1,
            sparkline: [
                "9515.0454185372",
                "9540.1812284677",
                "9554.2212643043"
            ],
            lowVolume: false,
            coinrankingUrl: URL(string: "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc"),
            volume24h: "6818750000",
            btcPrice: "1",
            tier: nil,
            contractAddresses: []
        )

        // initially empty
        XCTAssertTrue(viewModel.favorites.isEmpty)

        //test add to fav
        viewModel.toggleFavorite(testCoin)
        XCTAssertTrue(viewModel.favorites.contains(testCoin.uuid),
                      "toggleFavorite should add the UUID to favorites")

        //test remove from fav
        viewModel.toggleFavorite(testCoin)
        XCTAssertFalse(viewModel.favorites.contains(testCoin.uuid),
                       "toggleFavorite should remove the UUID when called again")
    }
}
