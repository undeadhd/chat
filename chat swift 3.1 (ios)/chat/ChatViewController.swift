//
//  ChatViewController.swift
//  chat
//
//  Created by Павел Гречихин on 20.07.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit
import NotificationCenter

class ChatViewController: NMessengerViewController {
    
    let nc = NotificationCenter.default
    private(set) var lastMessageGroup : MessageGroup? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        nc.addObserver(forName: NSNotification.Name(rawValue: "newMessage"), object: nil, queue: nil, using: notificationMessage(notification:))
    }
    
    func notificationMessage(notification: Notification) {
        let text = notification.userInfo!["text"] as! String
        debugPrint("Сработала нотификация")
        sendText(text, isIncomingMessage: true)
    }
    
    override func sendText(_ text: String, isIncomingMessage: Bool) -> GeneralMessengerCell {
        
        //create a new text message
        let textContent = TextContentNode(textMessageString: text, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        let newMessage = MessageNode(content: textContent)
        newMessage.cellPadding = messagePadding
        newMessage.currentViewController = self
        
        //add message to correct group
        if isIncomingMessage == true {
            self.postText(newMessage, isIncomingMessage: true)
        } else {
            self.postText(newMessage, isIncomingMessage: false)
            SocketManager.sharedInstance.sendMessage(text: text, ForID: 213)
        }
        return newMessage
    }
    
    private func postText(_ message: MessageNode, isIncomingMessage: Bool) {
        if self.lastMessageGroup == nil || self.lastMessageGroup?.isIncomingMessage == !isIncomingMessage {
            self.lastMessageGroup = self.createMessageGroup()
            
            //add avatar if incoming message
            if isIncomingMessage {
                self.lastMessageGroup?.avatarNode = self.createAvatar()
            }
            
            self.lastMessageGroup!.isIncomingMessage = isIncomingMessage
            self.messengerView.addMessageToMessageGroup(message, messageGroup: self.lastMessageGroup!, scrollsToLastMessage: false)
            self.messengerView.addMessage(self.lastMessageGroup!, scrollsToMessage: true, withAnimation: isIncomingMessage ? .left : .right)
            
        } else {
            self.messengerView.addMessageToMessageGroup(message, messageGroup: self.lastMessageGroup!, scrollsToLastMessage: true)
        }
    }
    
    private func createMessageGroup()->MessageGroup {
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = self
        newMessageGroup.cellPadding = self.messagePadding
        return newMessageGroup
    }
    
    
    private func createAvatar()->ASImageNode {
        let avatar = ASImageNode()
        avatar.backgroundColor = UIColor.lightGray
        avatar.style.preferredSize = CGSize(width: 20, height: 20)
        avatar.layer.cornerRadius = 10
        return avatar
    }
    
    deinit {
        nc.removeObserver(self.nc)
    }

}
