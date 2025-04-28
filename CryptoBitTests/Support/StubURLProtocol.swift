// CryptoBitTests/Support/StubURLProtocol.swift
import Foundation

class StubURLProtocol: URLProtocol {
  static var stubData: Data?
  static var stubStatus: Int = 200

  static func stub(data: Data, statusCode: Int = 200) {
    stubData = data
    stubStatus = statusCode
  }

  override class func canInit(with request: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
  override func startLoading() {
    let resp = HTTPURLResponse(
      url: request.url!,
      statusCode: StubURLProtocol.stubStatus,
      httpVersion: nil,
      headerFields: nil
    )!
    client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: StubURLProtocol.stubData ?? Data())
    client?.urlProtocolDidFinishLoading(self)
  }
  override func stopLoading() {}
}
