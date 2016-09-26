//
//  PendingBetsTableViewCell.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/22/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

class PendingBetsTableViewCell: UITableViewCell {

    //pendingLabel is the bet label
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var profPicImageView: UIImageView!
    @IBOutlet weak var stakesLabel: UILabel!
    @IBOutlet weak var stakesInputLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cellView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Set the positions of all the text and images
        cellView.frame.size.width = self.frame.size.width
        
        //print(self.frame.size.width)
        
        print(self.cellView.superview?.superview?.frame.size)
        
        stakesLabel.center.x = cellView.center.x
        actionButton.center.x = cellView.center.x
        
        
        //temp image filler
        profPicImageView.image = UIImage(named: "headshot")
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
