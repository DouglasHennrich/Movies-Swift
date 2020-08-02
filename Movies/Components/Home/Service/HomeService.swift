//
//  HomeService.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

protocol HomeServiceDelegate: AnyObject {
    func getMovies(offset: Int,
                   order: MoviesOrderMethod,
                   onCompletion: @escaping (Result<Movies, Error>) -> Void)
    
    func searchMovies(by query: String,
                      onCompletion: @escaping (Result<Movies, Error>) -> Void)
}

class HomeService {
    
    // MARK: Enum API
    enum API: String {
        case all = "all.json"
        case search = "search.json"
    }
    
    // MARK: Properties
    private let service: ServiceClientDelegate
    
    // MARK: Init
    init(client: ServiceClientDelegate = ServiceClient()) {
        self.service = client
    }
    
}

extension HomeService: HomeServiceDelegate {
    
    func getMovies(offset: Int = 0,
                   order: MoviesOrderMethod = .publicationDate,
                   onCompletion: @escaping (Result<Movies, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "offset": offset,
            "order": order.rawValue
        ]
        
        service.request(withUrl: API.all.rawValue,
                        withMethod: .get,
                        andParameters: parameters) { (response: Result<Movies, Error>) in
            
            switch response {
            case .success(let movies):
                return onCompletion(.success(movies))
            
            case .failure(let error):
                return onCompletion(.failure(error))
            }
        }
        
    }
    
    func searchMovies(by query: String,
                      onCompletion: @escaping (Result<Movies, Error>) -> Void) {
        let parameters: [String: Any] = [
            "order": MoviesOrderMethod.openingDate.rawValue,
            "query": query
        ]
        
        service.request(withUrl: API.search.rawValue,
                        withMethod: .get,
                        andParameters: parameters) { (response: Result<Movies, Error>) in
            
            switch response {
            case .success(let movies):
                return onCompletion(.success(movies))
            
            case .failure(let error):
                return onCompletion(.failure(error))
            }
        }
    }
    
}
