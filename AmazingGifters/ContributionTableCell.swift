//
//  ContributionTableCell.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/16/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class ContributionTableCell: UITableViewCell {
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var contributorLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
}
