//
//  DataModels.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 09/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import EVReflection

class MoviesResponse: EVObject {
    var page: Int = 0
    var total_results: Int = 1
    var total_pages: Int = 0
    var results: [Movie]? = [Movie]()
}


public class Movie: EVObject {
    var id: String? = ""
    var title: String? = ""
    var adult: Bool?
    var overview: String? = ""
    var popularity: Double? = 0
    var backdrop_path: String? = ""
    var vote_average: String? = ""
    var original_language: String? = ""
    var original_title: String? = ""
    var vote_count: String? = ""
    var poster_path: String? = ""
    var genre_ids: [Int]?
    var release_date: String? = ""
    var video: Bool?
    var tagline: String?
    
    var year: String? {
        if let substring = release_date?.split(separator: "-").first {
            return String(substring)
        }else{
           return nil
        }
    }
}

public class MovieDetails: Movie {
    var runtime: String? = ""
    var genres: [Genre]?
}


extension Movie: SmallViewPresentable {
    func getId() -> String {
        return id ?? ""
    }
    
    func getTitle() -> String {
        return self.title ?? ""
    }
    
    func getImageIconUrl() -> String? {
        return poster_path
    }
    
    func getSubtitle() -> String? {
        return nil
    }
}
