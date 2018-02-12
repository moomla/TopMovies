//
//  CastModel.swift
//  TopMovies
//
//  Created by Dina Vaingolts on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import EVReflection

class CastResponce: EVObject {
    var id: String? = ""
    var cast: [Cast]? = [Cast]()
}
    
class Cast: EVObject {
    var cast_id: String? = ""
    var character: String? = ""
    var credit_id: String? = ""
    var id: String? = ""
    var name: String? = ""
    var order: String? = ""
    var profile_path: String? = ""
}


extension Cast: SmallViewPresentable {
    func getId() -> String {
        return id ?? ""
    }
    
    func getImageIconUrl() -> String? {
        return profile_path
    }
    
    func getTitle() -> String {
        return name ?? ""
    }
    
    func getSubtitle() -> String?{
        if let role = character {
            return "(\(role))"
        }
        return nil
    }
}
