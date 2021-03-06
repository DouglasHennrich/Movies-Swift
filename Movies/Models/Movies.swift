//
//  Movies.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

struct Movies: Codable {
    
    let copyright: String?
    let hasMore: Bool
    let numResults: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case copyright
        case hasMore = "has_more"
        case numResults = "num_results"
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        copyright = try? container.decode(String.self, forKey: .copyright)
        
        if let hasMoreDecoded = try? container.decode(Bool.self, forKey: .hasMore) {
            hasMore = hasMoreDecoded
        } else {
            hasMore = false
        }
        
        if let numResultsDecoded = try? container.decode(Int.self, forKey: .numResults) {
            numResults = numResultsDecoded
        } else {
            numResults = 0
        }
        
        let throwables = try container.decode([Throwable<Movie>].self, forKey: .results)
        results = throwables.compactMap { try? $0.result.get() }
    }
    
}
