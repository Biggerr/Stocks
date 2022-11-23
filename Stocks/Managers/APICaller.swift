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
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search
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
        
        print("\n\(urlString)\n")
        
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
