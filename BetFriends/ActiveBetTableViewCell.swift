//
//  ActiveBetTableViewCell.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/22/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

class ActiveBetTableViewCell: UITableViewCell {

    @IBOutlet weak var friendProfPic: UIImageView!
    @IBOutlet weak var betTextLabel: UILabel!
    @IBOutlet weak var myProfPic: UIImageView!
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var stakesLabel: UILabel!
    @IBOutlet weak var stakesTextLabel: UILabel!
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
