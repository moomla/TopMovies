//
//  genres.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 11/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import EVReflection

class GenreResponce: EVObject {
    var genres: [Genre]?
}

class Genre: EVObject {
    var id: String? = ""
    var name: String? = ""
}
