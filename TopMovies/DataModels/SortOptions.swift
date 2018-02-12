//
//  SortOptions.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 11/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

enum MovieSortOption {
    case popularity(asc: Bool)
    case releaseDate(asc: Bool)
    case originalTitle(asc: Bool)
    case voteAverage(asc: Bool)
    case voteCount(asc: Bool)
    
    
    var name: String {
        switch(self) {
        case .popularity(let ascending):
            return (ascending) ? "Popularity Asc." : "Popularity Desc."
        case .releaseDate(let ascending):
            return (ascending) ? "Release date Asc." : "Release date Desc."
        case .originalTitle(let ascending):
            return (ascending) ? "Title Asc." : "Title Desc."
        case .voteAverage(let ascending):
            return (ascending) ? "Votes Asc." : "Votes Desc."
        case .voteCount(let ascending):
            return (ascending) ? "Vote count Asc." : "Vote count Desc."
        }
    }
    
    var urlParameter: String {
        switch(self) {
        case .popularity(let ascending):
            return (ascending) ? "popularity.asc" : "popularity.desc"
        case .releaseDate(let ascending):
            return (ascending) ? "release_date.asc" : "release_date.desc"
        case .originalTitle(let ascending):
            return (ascending) ? "original_title.asc" : "original_title.desc"
        case .voteAverage(let ascending):
            return (ascending) ? "vote_average.asc" : "vote_average.desc"
        case .voteCount(let ascending):
            return (ascending) ? "vote_count.asc" : "vote_count.desc"
        }
    }
    
    static var array: [MovieSortOption] {
        var a: [MovieSortOption] = []
        switch MovieSortOption.popularity(asc: true) {
        case .popularity(_):
            a.append(.popularity(asc: true))
            a.append(.popularity(asc: false))
            fallthrough
        case .releaseDate(_):
            a.append(.releaseDate(asc: true))
            a.append(.releaseDate(asc: false))
            fallthrough
        case .originalTitle(_):
            a.append(.originalTitle(asc: true))
            a.append(.originalTitle(asc: false))
            fallthrough
        case .voteAverage(_):
            a.append(.voteAverage(asc: true))
            a.append(.voteAverage(asc: false))
            fallthrough
        case .voteCount(_):
            a.append(.voteCount(asc: true))
            a.append(.voteCount(asc: false))
        }
        return a
    }
}

