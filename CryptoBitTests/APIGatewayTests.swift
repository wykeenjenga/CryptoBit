// CryptoBitTests/APIGatewayTests.swift
import XCTest
import Combine
@testable import CryptoBit

final class APIGatewayTests: XCTestCase {
  var cancellables = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    // Point URLSession to our stub protocol
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [StubURLProtocol.self]
    APIGateway.shared.session = URLSession(configuration: config)
  }
  
  func testPerform_SuccessDecodes() {
    // 1) Prepare stubbed JSON
    let json = """
    { "status":"success", "data": { "stats": { ... }, "coins": [] } }
    """
    StubURLProtocol.stub(data: Data(json.utf8), statusCode: 200)
    
    // 2) Perform API call
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
    
    waitForExpectations(timeout: 1)
  }
  
  func testPerform_HTTPError() {
    StubURLProtocol.stub(data: Data(), statusCode: 500)
    let exp = expectation(description: "HTTP error")
    APIGateway.shared
      .perform(path: "coins")
      .sink { completion in
        if case .failure(let APIError.unexpectedStatus(500)) = completion {
          exp.fulfill()
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
  }
}
