//
//  DataProvider.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 09/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import Alamofire

let apiKey = "5fa91f4d299a99ecc758dfeb22e26c10"

enum TMDBUrls {
    case discover(page: Int)
    case movie(movieId: String)
    case cast(movieId: String)
    case person(personId: String)
    case filmography(personId: String)
    case image(url: String, width: Int)
    case genresList
    var url: String {
        switch self {
        case .discover(let page):
            return "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&page=\(page)"
        case .movie(let movieId):
            return "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)"
        case .person(let personId):
            return "https://api.themoviedb.org/3/person/\(personId)?api_key=\(apiKey)"
        case .cast(let movieId):
            return  "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(apiKey)"
        case .filmography(let personId):
            return  "https://api.themoviedb.org/3/person/\(personId)/movie_credits?api_key=\(apiKey)"
        case .image(let url, let width):
            return "https://image.tmdb.org/t/p/w\(width)/\(url)"
        case .genresList:
            return "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)"
        }
    }
}


struct MovieRequestData {
    let page: Int
    let sortOption: MovieSortOption?
    let genres: [Genre?]
}


class DataProvider{
    
    static let shared = DataProvider()
    var genres: [Genre]?
    
    private init() {
        loadGenres { (genres) in
            self.genres = genres
        }
    }
    
    func loadGenres(completionBlock:@escaping ([Genre]?) -> Void) {
        let url = TMDBUrls.genresList.url
        
        Alamofire.request(url)
            .responseObject { (response: DataResponse<GenreResponce>) in
                if let result = response.result.value {
                    return completionBlock(result.genres)
                }
        }
    }
    
    func loadMovies(requestData: MovieRequestData, completionBlock:@escaping (MoviesResponse?) -> Void) {
        let sort = requestData.sortOption ?? .popularity(asc: false)
        var url = TMDBUrls.discover(page: requestData.page).url
        url = url + "&sort_by=\(sort.urlParameter)"
        if requestData.genres.count > 0 {
            let parameter = requestData.genres.map { $0?.id ?? "" }.joined(separator: ",")
            url = url + "&with_genres=\(parameter)"
        }
        
        
        Alamofire.request(url)
            .responseObject { (response: DataResponse<MoviesResponse>) in
                if let result = response.result.value {
                    completionBlock(result)
                }
        }
    }
    
    func loadMovieDetails(movieId: String, completionBlock:@escaping (MovieDetails) -> Void) {
        let url = TMDBUrls.movie(movieId: movieId).url
        Alamofire.request(url)
            .responseObject { (response: DataResponse<MovieDetails>) in
                if let movie = response.result.value {
                    completionBlock(movie)
                }
        }
    }
    
    func loadCastDetails(movieId: String, completionBlock:@escaping ([Cast]?) -> Void) {
        let url = TMDBUrls.cast(movieId: movieId).url
        Alamofire.request(url)
            .responseObject { (response: DataResponse<CastResponce>) in
                if let castResponce = response.result.value{
                    let cast = castResponce.cast
                    completionBlock(cast )
                }
        }
    }
    
    func loadPersonDetails(personId: String, completionBlock:@escaping (Person) -> Void) {
        let url = TMDBUrls.person(personId: personId).url
        Alamofire.request(url)
            .responseObject { (response: DataResponse<Person>) in
                if let person = response.result.value {
                    completionBlock(person)
                }
        }
    }
    
    func loadFilmography(personId: String, completionBlock:@escaping ([CreditInMovie]?) -> Void) {
        let url = TMDBUrls.filmography(personId: personId).url
        Alamofire.request(url)
            .responseObject { (response: DataResponse<CreditInMovieResponce>) in
                if let responce = response.result.value {
                    completionBlock(responce.cast)
                }
        }
    }
    
    func imageUrl(path: String, width: Int = 185) -> String {
        return TMDBUrls.image(url: path, width: width).url
    }
}
