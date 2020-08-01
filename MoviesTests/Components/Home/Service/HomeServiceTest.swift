//
//  HomeServiceTest.swift
//  MoviesTests
//
//  Created by Douglas Hennrich on 31/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

@testable import Movies
import XCTest

// swiftlint:disable force_try
class HomeServiceTest: XCTestCase, HomeServiceDelegate {
    
    // MARK: Properties
    var shouldFail: Bool = false
    var movies: Movies {
        let jsonData = loadSub(name: "MockMoviesResponse", extensionName: "json")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return try! decoder.decode(Movies.self, from: jsonData)
    }
    
    // MARK: Actions
    func getMovies(offset: Int,
                   order: MoviesOrderMethod,
                   onCompletion: @escaping (Result<Movies, Error>) -> Void) {
        if shouldFail {
            return onCompletion(.failure(ServiceError.badRequest))
        }
        
        return onCompletion(.success(movies))
    }
    
}
