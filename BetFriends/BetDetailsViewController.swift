//
//  BetDetailsViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/23/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

class BetDetailsViewController: UIViewController {

    @IBOutlet weak var myProfPic: UIImageView!
    @IBOutlet weak var friendProfPic: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var betTextLabel: UILabel!
    @IBOutlet weak var stakesLabel: UILabel!
    @IBOutlet weak var stakesTextLabel: UILabel!
    @IBOutlet weak var cancelBetButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var closeBetButton: UIButton!
    @IBOutlet weak var staticStatusLabel: UILabel!
    @IBOutlet weak var betDetailsView: UIView!
    
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var createdLabel: UILabel!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Initially hide all the buttons
        acceptButton.hidden = true
        rejectButton.hidden = true
        addPhotoButton.hidden = true
        cancelBetButton.hidden = true
        closeBetButton.hidden = true
        resultImage.hidden = true
        
        ///Position elements
        let screenSize = UIScreen.mainScreen().bounds.size
        let screenCenterX = CGFloat(screenSize.width/2)
        
        let profPicSize = CGFloat(screenSize.width/4)
        let profPicOffset = CGFloat(25)
        let topMargin = CGFloat(85)
        let viewPadding = 10
        
        myProfPic.frame = CGRect(x: profPicOffset, y: topMargin, width: profPicSize, height: profPicSize)
        myProfPic.layer.cornerRadius = profPicSize/2
        myProfPic.layer.masksToBounds = true
        
        friendProfPic.frame = CGRect(x: screenSize.width-profPicOffset-profPicSize, y: topMargin, width: profPicSize, height: profPicSize)
        friendProfPic.layer.cornerRadius = profPicSize/2
        friendProfPic.layer.masksToBounds = true
        
        staticStatusLabel.center.x = screenCenterX
        statusLabel.center.x = screenCenterX
        
        
        ////// Details view //////
        let detailsSideMargin = CGFloat(15)
        let detailsBottomMargin = CGFloat(100)
        let scrollViewWidth = CGFloat(screenSize.width-2*detailsSideMargin)
        detailsScrollView.frame.size = CGSize(width: scrollViewWidth, height: screenSize.height-topMargin-profPicSize-detailsBottomMargin)
        detailsScrollView.layer.cornerRadius = 10
        detailsScrollView.frame.origin = CGPoint(x: detailsSideMargin, y: topMargin+profPicSize+detailsSideMargin)
        detailsScrollView.contentSize = CGSize(width: scrollViewWidth, height: 1000)
        betDetailsView.layer.cornerRadius = 10
        let detailsViewWidth = scrollViewWidth
        betDetailsView.frame.size.width = detailsViewWidth
        
        // TODO change this height dynamically
        betDetailsView.frame.size.height = 750
        betDetailsView.frame.origin = CGPoint(x: 0, y: 0)
        
        
        betTextLabel.frame.origin = CGPoint(x: viewPadding, y: viewPadding)
    
        stakesLabel.center.x = detailsViewWidth/2
        
        stakesTextLabel.frame.origin.x = CGFloat(viewPadding)
        
        createdLabel.center.x = scrollViewWidth/4
        
        endLabel.center.x = scrollViewWidth*3/4
        
        createdDateLabel.center.x = scrollViewWidth/4
        
        endDateLabel.center.x = scrollViewWidth*3/4
        
        //////////////////////////
        
        
        cancelBetButton.center.x = screenCenterX
        
        rejectButton.frame.size = CGSize(width: screenSize.width/3, height: screenSize.width/10)
        rejectButton.center.y = screenSize.height-detailsBottomMargin/2
        rejectButton.center.x = screenSize.width*(1/3)-1
        rejectButton.layer.cornerRadius = 10
        
        acceptButton.frame.size = CGSize(width: screenSize.width/3, height: screenSize.width/10)
        acceptButton.center.y = screenSize.height-detailsBottomMargin/2
        acceptButton.center.x = screenSize.width*(2/3)+1
        acceptButton.layer.cornerRadius = 10
        
        let bottomButtonsCenter = CGPoint(x: screenCenterX, y: screenSize.height-detailsBottomMargin/3)
        addPhotoButton.center = bottomButtonsCenter
        closeBetButton.center = bottomButtonsCenter
        
        
        resultImage.center.x = screenCenterX
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
