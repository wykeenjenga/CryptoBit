//
//  APIGatewayTests.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 28/04/2025.
//


import XCTest
@testable import CryptoBit
import Combine

final class APIGatewayTests: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        APIGateway.shared.session = URLSession(configuration: config)
    }
  
    func testPerform_SuccessDecodes() {
        let json = """
        {
          "status": "success",
          "data": {
            "stats": {
              "total": 3,
              "totalCoins": 10000,
              "totalMarkets": 35000,
              "totalExchanges": 300,
              "totalMarketCap": "239393904304",
              "total24hVolume": "503104376.06373006"
            },
            "coins": [
              {
                "uuid": "Qwsogvtv82FCd",
                "symbol": "BTC",
                "name": "Bitcoin",
                "color": "#f7931A",
                "iconUrl": "https://cdn.coinranking.com/Sy33Krudb/btc.svg",
                "marketCap": "159393904304",
                "price": "9370.9993109108",
                "listedAt": 1483228800,
                "change": "-0.52",
                "rank": 1,
                "sparkline": [
                  "9515.0454185372",
                  "9540.1812284677",
                  "9554.2212643043",
                  "9593.571539283"
                ],
                "lowVolume": false,
                "coinrankingUrl": "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc",
                "24hVolume": "6818750000",
                "btcPrice": "1",
                "contractAddresses": []
              },
              {
                "uuid": "HIVsRcGKkPFtW",
                "symbol": "USDT",
                "name": "Tether USD",
                "color": "#22a079",
                "iconUrl": "https://cdn.coinranking.com/mgHqwlCLj/usdt.svg",
                "marketCap": "96683907099",
                "price": "1.0001610860600088",
                "listedAt": 1420761600,
                "tier": 1,
                "change": "0.12",
                "rank": 3,
                "sparkline": [
                  "0.9989504570557836",
                  "0.9983877836406384",
                  "0.9980832967019606",
                  "0.9991024864845068"
                ],
                "lowVolume": false,
                "coinrankingUrl": "https://coinranking.com/coin/HIVsRcGKkPFtW+tetherusd-usdt",
                "24hVolume": "129352463266",
                "btcPrice": "0.000020055313576108",
                "contractAddresses": [
                  "avalanche-c-chain/0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7 ",
                  "tron/TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t",
                  "solana/Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
                  "eos/USDT-eos-tethertether",
                  "omni/31",
                  "bitcoin-cash/9fc89d6b7d5be2eac0b3787c5b8236bca5de641b5bafafc8f450727b63615c11",
                  "liquid/ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2",
                  "ethereum/0xdac17f958d2ee523a2206206994597c13d831ec7",
                  "algorand/312769"
                ]
              }
            ]
          }
        }
        """
        StubURLProtocol.stub(data: Data(json.utf8), statusCode: 200)
        
        let exp = expectation(description: "Decoding succeeds")
        
        APIGateway.shared
            .perform(path: "coins")
            .sink { completion in
                if case .failure(let err) = completion {
                    XCTFail("Expected success, got \(err)")
                }
            } receiveValue: { (resp: CoinsListResponse) in
                XCTAssertEqual(resp.status, "success")
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 4)
    }
  
    
    func testPerform_HTTPError() {
        
        StubURLProtocol.stub(data: Data(), statusCode: 200)
        
        let exp = expectation(description: "HTTP error")
        
        let publisher: AnyPublisher<CoinsListResponse, APIError> =
            APIGateway.shared.perform(path: "coins")
        publisher
          .sink(
            receiveCompletion: { (completion: Subscribers.Completion<APIError>) in
              switch completion {
              case .failure(let apiError):
                  exp.fulfill()
              case .finished:
                XCTFail("Expected failure, but got finished")
              }
            },
            receiveValue: { (_: CoinsListResponse) in
              XCTFail("Expected no value on HTTP 500, but got one")
            }
          )
          .store(in: &cancellables)

        waitForExpectations(timeout: 8)
    }


    
}
