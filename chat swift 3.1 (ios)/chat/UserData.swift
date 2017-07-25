//
//  UserData.swift
//  chat
//
//  Created by Павел Гречихин on 15.07.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import Foundation
import RealmSwift

class UserData: Object {
    dynamic var userID = "1"
    dynamic var login = ""
    dynamic var password = ""
    dynamic var token = ""
    dynamic var myID: Int = 0
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}
