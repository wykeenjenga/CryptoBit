//
//  CoinsListViewModelTests.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 28/04/2025.
//


// CryptoBitTests/CoinsListViewModelTests.swift
import XCTest
import Combine
@testable import CryptoBit

final class CoinsListViewModelTests: XCTestCase {
  var vm: CoinsListViewModel!
  var stubClient: StubCoinClient!
  var cancellables = Set<AnyCancellable>()

  override func setUp() {
    stubClient = StubCoinClient()
    vm = CoinsListViewModel(client: stubClient)
  }

  func testLoadNextPage_PopulatesCoins() {
    stubClient.coinsToReturn = [ Coin(uuid:"1", symbol:"T", name:"Test", ... ) ]
    let exp = expectation(description: "Coins loaded")
    
    vm.$coins
      .dropFirst()
      .sink { coins in
        XCTAssertEqual(coins.count, 1)
        exp.fulfill()
      }
      .store(in: &cancellables)

    vm.loadNextPage()
    waitForExpectations(timeout: 1)
  }
}

// A simple stub:
class StubCoinClient: CoinServiceProtocol {
  var coinsToReturn = [Coin]()
  func fetchCoins(offset: Int, limit: Int) -> AnyPublisher<[Coin], APIError> {
    Just(coinsToReturn).setFailureType(to: APIError.self).eraseToAnyPublisher()
  }
}
