//
//  PersonDataModels.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import EVReflection

class Person: EVObject {
    var id: String? = ""
    var name: String? = ""
//    var also_known_as: NSString? = ""
    var birthday: String? = ""
    var deathday: String? = ""
    var biography: String? = ""
    var popularity: String? = ""
    var place_of_birth: String? = ""
    var profile_path: String? = ""
    var homepage: String? = ""
}

class CreditInMovieResponce: EVObject {
    var id: String? = ""
    var cast: [CreditInMovie]? = [CreditInMovie]()
}

class CreditInMovie: Movie {
    var character: String? = ""
}

extension CreditInMovie {
    override func getSubtitle() -> String? {
        return character
    }
}
