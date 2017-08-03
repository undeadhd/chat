//
//  chatTableViewController.swift
//  chat
//
//  Created by Павел Гречихин on 10.07.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import UIKit
import SocketIO
import RealmSwift

class chatTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var SearchBarFriends: UISearchBar!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return realm.objects(UserChats.self).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCell {
        
        let data = realm.objects(UserChats.self)
        
        
        let cell = Bundle.main.loadNibNamed("UserCell", owner: self, options: nil)?.first as! UserCell
        cell.NameProfileLabel.text = String(data[indexPath.row].friendID)
        
        let chatData = realm.objects(MessageData.self).filter("toID = '\(data[indexPath.row].friendID)'")
        
        cell.AvatarProfileImage.image = #imageLiteral(resourceName: "batmetal-Dethklok-Batman-DC-Comics-2740525")
        
        let count = chatData.count
        cell.TextMessageLabel.text = chatData[count].textMessage
        cell.TypingIndicatorLabel.isHidden = false
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "chatVC", sender: indexPath.row)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let prep = segue.destination as! ChatViewController
//        prep.idFriend = sender as! Int
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
