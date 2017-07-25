//
//  LoginViewController.swift
//  chat
//
//  Created by Павел Гречихин on 09.07.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData
import RealmSwift
import NotificationCenter

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AuthButton(_ sender: MyButton) {
        
        request("http://127.0.0.1:8080/auth/", method: .post, headers: ["log": self.loginTextField.text!, "password" : self.passwordTextField.text!]).responseJSON { response in
            let res = JSON(response.result.value!)
            print(res["token"])
            let realm = try! Realm()
            try! realm.write {
                let identifier = UserData()
                identifier.login = self.loginTextField.text!
                identifier.password = self.passwordTextField.text!
                identifier.token = res["token"].string!
                realm.add(identifier)
            }
            SocketManager.sharedInstance.establishConnection()
        }
    
    }
}


class MyButton: UIButton {
    convenience init(type: UIButtonType) {
        self.init(type: type)
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    override var clipsToBounds: Bool {
        didSet {
            layer.cornerRadius = 20
        }
    }
}
