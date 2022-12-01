//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Sherzod on 11/11/22.
//

import Foundation

// ["AAPL", "MSFT", "SNAP"]
// [AAPL: Apple Inc]

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
        
    }
    
    private init() {}
    
    // MARK: - Public
    
    public var watchList: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    public func watchlistContains(symbol: String) -> Bool {
        return watchList.contains(symbol)
    }
    
    public func addToWatchlist(symbol: String, companyName: String) {
        var current = watchList
        current.append(symbol)
        userDefaults.set(current, forKey: Constants.watchListKey)
        
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
    }
    
    public func removeFromToWatchlist(symbol: String) {
        var newList = [String]()
        
        userDefaults.set(nil, forKey: symbol)
        for item in watchList where item != symbol {
            newList.append(item)
        }
        
        userDefaults.set(newList, forKey: Constants.watchListKey)
    }
    
    
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    private func setUpDefaults() {
        let map: [String: String] = [
            "AAPL": "Apple Inc.",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com, Inc",
            "WORK": "Slack Technologies",
            "FB": "Facebook Inc.",
            "NVDA": "Nvidia Inc.",
            "NKE": "Nike",
            "PINS": "Pinterest Inc."
        ]
        
        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchListKey)
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
    
}
