//
//  ContactsTableViewCell.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/7/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactPicture: UIImageView!
    
    @IBOutlet weak var contactName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
