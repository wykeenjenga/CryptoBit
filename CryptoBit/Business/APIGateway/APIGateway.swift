//
//  APIGateway.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum APIError: LocalizedError {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
    case unexpectedStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingError(let err): return "Decoding failed: \(err)"
        case .networkError(let err): return "Network error: \(err.localizedDescription)"
        case .unexpectedStatus(let code): return "Unexpected HTTP status code: \(code)"
        }
    }
}

final class APIGateway {
    static let shared = APIGateway()
    var session: URLSession
    private let baseURL: URL
    private let defaultHeaders: [String:String]
    private let decoder: JSONDecoder

    private init() {
        self.baseURL = AppConfig.baseURL
        self.defaultHeaders = [
            "x-access-token": AppConfig.apiKey,
            "Accept":        "application/json"
        ]
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.session = .shared
    }

    /// Perform a request and decode the JSON into `T`.
    ///
    /// - Parameters:
    ///   - path: e.g. "coin/Qwsogvtv82FCd" or "coins"
    ///   - method: .get, .post, etc.
    ///   - queryItems: any URLQueryItem array for pagination, filters, etc.
    ///   - extraHeaders: if you need per-call overrides
    func perform<T: Decodable>( path: String, method: HTTPMethod = .get, queryItems: [URLQueryItem]? = nil, extraHeaders: [String:String]? = nil) -> AnyPublisher<T, APIError> {
        
        guard var comps = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        comps.queryItems = queryItems
        
        guard let url = comps.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        defaultHeaders
            .merging(extraHeaders ?? [:]) { $1 }
            .forEach { req.setValue($1, forHTTPHeaderField: $0) }
        

        print("➡️ [API] \(method.rawValue) \(req.url?.absoluteString ?? "nil URL")")
        if let headers = req.allHTTPHeaderFields {
            print("   headers: \(headers)")
        }
        if let body = req.httpBody, let str = String(data: body, encoding: .utf8) {
            print("   body: \(str)")
        }
        
        return session.dataTaskPublisher(for: req)
            .handleEvents(
                receiveOutput: { output in
                    if let httpResp = output.response as? HTTPURLResponse {
                        print("⬅️ [API] \(httpResp.statusCode) \(httpResp.url?.absoluteString ?? "")")
                    }

                    if let json = String(data: output.data, encoding: .utf8) {
                        print("📦 [API] Response Body: \(json)")
                    }
                },
                receiveCompletion: { completion in
                    if case .failure(let err) = completion {
                        print("⚠️ [API] Completion with error: \(err)")
                    }
                }
            )
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw APIError.unexpectedStatus(
                        (output.response as? HTTPURLResponse)?.statusCode ?? -1
                    )
                }
                return output.data
            }
            .mapError { APIError.networkError($0) }
            .decode(type: T.self, decoder: decoder)
            .mapError { APIError.decodingError($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
