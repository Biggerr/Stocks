//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Sherzod on 11/11/22.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        
        
    }
    
    private init() {}
    
    // MARK: - Public
    
    public var watchLIST: [String] {
        return []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func removeFromToWatchlist() {
        
    }
    
    
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return false
    }
    
}
