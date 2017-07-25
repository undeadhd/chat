//
//  UserCell.swift
//  chat
//
//  Created by Павел Гречихин on 23.07.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var NameProfileLabel: UILabel!
    @IBOutlet weak var AvatarProfileImage: UIImageView!
    @IBOutlet weak var TextMessageLabel: UILabel!
    @IBOutlet weak var TypingIndicatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AvatarProfileImage.layer.cornerRadius = AvatarProfileImage.frame.size.width / 2
        AvatarProfileImage.clipsToBounds = true
        AvatarProfileImage.layer.borderColor = UIColor.white.cgColor
        AvatarProfileImage.layer.borderWidth = 1
        TypingIndicatorLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
