//
//  AppConfig.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import Foundation


enum AppConfig {
    private static let info = Bundle.main.infoDictionary

    /// Reads the “BaseURL” entry and builds a URL
    static var baseURL: URL {
        guard let urlString = info?["BaseURL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("⚠️ BaseURL is missing or invalid in Info.plist")
        }
        return url
    }

    /// Reads the “API_KEY” entry
    static var apiKey: String {
        guard let key = info?["API_KEY"] as? String, !key.isEmpty else {
            fatalError("⚠️ API_KEY is missing in Info.plist")
        }
        return key
    }
}
