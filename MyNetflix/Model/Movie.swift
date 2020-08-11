//
//  Movie.swift
//  MyNetflix
//
//  Created by Apple on 2020/06/14.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import Foundation


struct Movie: Codable {
    let title: String
    let director: String
    let thumbnailPath: String
    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
    }
    
}

struct Response: Codable {
    let resultCount : Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
    
}

struct SearchTerm: Codable {
    let term: String
    let timeStamp: TimeInterval
}

