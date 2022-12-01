//
//  APICaller.swift
//  Stocks
//
//  Created by Sherzod on 11/11/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "cdv03ciad3i2h5f4qlc0cdv03ciad3i2h5f4qlcg"
        static let sandboxApiKey = "cdv03ciad3i2h5f4qldg"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
    }
    
    private init() {}
    
    // MARK: - Public
    
    public func search(
        query: String,
        completion: @escaping (Result<SearchResponse, Error>) -> Void
    ) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        request(url: url(for: .search, queryParams: ["q":safeQuery]),
                expecting: SearchResponse.self,
                complition: completion)
        
    }
    
    public func news(
        for type: NewsViewController.`Type`,
        completion: @escaping (Result<[NewsStory], Error>) -> Void
    ){
        switch type {
        case .topStrories:
            request(
                url: url(for: .topStories, queryParams: ["category": "general"]),
                    expecting: [NewsStory].self, complition: completion)
        case .compan(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            request(
                url: url(for: .companyNews, queryParams: [
                    "symbol": symbol,
                    "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                    "to": DateFormatter.newsDateFormatter.string(from: today)
                
                ]),
                    expecting: [NewsStory].self, complition: completion)
        }
    }
    
    public func marketData(
    
        for symbol: String,
        numberOfDays: TimeInterval = 7,
        completion: @escaping (Result<MarketDataResponse, Error>) ->Void
    ) {
        let today = Date()
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        request(url: url(for: .marketData, queryParams: [
            "symbol": symbol,
            "resolution": "1",
            "from": "\(Int(prior.timeIntervalSince1970))",
            "to": "\(Int(today.timeIntervalSince1970))"
        ]),
            expecting: MarketDataResponse.self,
            complition: completion)
        
    }
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]
    ) -> URL? {
        
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for(name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        //Convert query items to suffix string
        
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        urlString += "?" + queryString
        
        return URL(string: urlString)
    }
    
    
    private func request<T: Codable>(url: URL?, expecting: T.Type, complition: @escaping (Result<T, Error>) -> Void){
        guard let url = url else {
            // Invalid url
            complition(.failure(APIError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    complition(.failure(error))
                } else {
                    complition(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                complition(.success(result))
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
}
