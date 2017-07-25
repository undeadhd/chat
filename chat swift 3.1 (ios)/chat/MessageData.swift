//
//  MessageData.swift
//  chat
//
//  Created by Павел Гречихин on 25.07.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import Foundation
import RealmSwift

class MessageData: Object {
    dynamic var textMessage: String = ""
    dynamic var fromID: Int = 0
    dynamic var toID: Int = 0
}
