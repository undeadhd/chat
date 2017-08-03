//
//  SearchViewController.swift
//  chat
//
//  Created by Павел Гречихин on 01.08.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import UIKit
import SocketIO

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
        SocketManager.sharedInstance.SocketFindFriend(id: Int(searchBar.text!)!)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("мы тут")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
