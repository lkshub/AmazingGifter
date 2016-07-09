//
//  GiftTableViewCell.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/7/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class GiftTableViewCell: UITableViewCell {
    @IBOutlet weak var progressViewNumber: UILabel!
    @IBOutlet weak var giftDueDateLabel: UILabel!
    @IBOutlet weak var giftProgressView: UIProgressView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftReasonCell: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    
       override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
