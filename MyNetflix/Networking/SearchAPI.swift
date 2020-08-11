//
//  SearchAPI.swift
//  MyNetflix
//
//  Created by Apple on 2020/06/14.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import Foundation

class SearchAPI {
    
    static func search(_ term: String, completion: @escaping ([Movie]) -> Void) {
        let session = URLSession(configuration: .default)
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            let successRange = 200..<300
            
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode ,
                successRange.contains(statusCode) else {
                    completion([])
                    return
            }
            
            guard let resultData = data else {
                completion([])
                return
            }
            //data --> [Movie]변환
            //paeseMovies static func 사용
            let movies = SearchAPI.parseMovies(resultData)
            completion(movies)
            
        }
        //networking start
        dataTask.resume()
    }
    
    //Data decode해주어서 Json -> Movie type converting
    static func parseMovies(_ data: Data) -> [Movie] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let movies = response.movies
            return movies
            
        } catch let error {
            print("-->parsing error: \(error.localizedDescription)")
            return []
        }
    }
}
