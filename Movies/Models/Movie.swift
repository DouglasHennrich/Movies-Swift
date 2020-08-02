//
//  Movie.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let displayTitle: String
    let mpaaRating: MovieMPAARating
    let criticsPick: Int
    let byline: String
    let headline: String
    let summaryShort: String
    let publicationDate: String
    let openingDate: String?
    let dateUpdated: String?
    let link: MovieLink
    let multimedia: MovieMultimedia?

    enum CodingKeys: String, CodingKey {
        case displayTitle = "display_title"
        case mpaaRating = "mpaa_rating"
        case criticsPick = "critics_pick"
        case byline
        case headline
        case summaryShort = "summary_short"
        case publicationDate = "publication_date"
        case openingDate = "opening_date"
        case dateUpdated = "date_updated"
        case link
        case multimedia
    }
    
}

// MARK: - Link
struct MovieLink: Codable {
    let url: String
    let suggestedLinkText: String

    enum CodingKeys: String, CodingKey {
        case url
        case suggestedLinkText = "suggested_link_text"
    }
}

// MARK: - Multimedia
struct MovieMultimedia: Codable {
    let src: String
}
