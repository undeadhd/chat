//
//  SocketManager.swift
//  chat
//
//  Created by Павел Гречихин on 14.07.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import UIKit
import SocketIO
import RealmSwift
import NotificationCenter
import SwiftyJSON
import JWT

class SocketManager: NSObject {
    
    static let sharedInstance = SocketManager()
    
    let nc = NotificationCenter.default
    
    let realm = try! Realm()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://127.0.0.1:20133/")!)
    
    override init() {
        super.init()
        self.eventWaiting()
    }
    //MARK: Socket function public
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }

    func socketAuth() {
        socket.emit("autentificate")
    }
    
    func sendMessage(text: String, ForID: Int) {
        socket.emit("messageFor", sendData(ForID: ForID, text: text, token: self.realm.objects(UserData.self)[0].token))
        DispatchQueue.global(qos: .utility).async {
            let ident = MessageData()
            ident.toID = ForID
            ident.textMessage = text
            ident.fromID = self.realm.objects(UserData.self)[0].myID
            try! self.realm.write {
                self.realm.add(ident)
            }
        }
    }
    
    //MARK: Socket wait event
    
    
    func eventWaiting() {
        
        socket.on("hardAuth") {data, ack in
            self.socket.emit("authToken", AuthData(token: self.realm.objects(UserData.self)[0].token))
        }
        
        socket.on("newMessage") { data, ack in
            let json = JSON(data[0])
            self.nc.post(name: NSNotification.Name(rawValue: "newMessage"), object: nil, userInfo: ["text" : json["text"].stringValue, "senderID": json["senderID"].intValue])
            DispatchQueue.global(qos: .utility).async {
                let ident = MessageData()
                ident.toID = self.realm.objects(UserData.self)[0].myID
                ident.textMessage = json["text"].stringValue
                ident.fromID = json["senderID"].intValue
                try! self.realm.write {
                    self.realm.add(ident)
                }
            }
        }
        
    }
    
    
    //MARK: Struct message
    
    struct AuthData : SocketData {
        let token : String
        
        func socketRepresentation() -> SocketData {
            return ["token":token]
        }
    }
    
    struct sendData : SocketData {
        let ForID : Int
        let text : String
        let token: String
        
        func socketRepresentation() -> SocketData {
            return ["token": token, "ForID": 123, "text":text, "myID": 213]
        }
    }
}
