//
//  BetDetailsViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/23/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

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
    @IBOutlet weak var betDetailsLabel: UILabel!
    
    @IBOutlet weak var detailsScrollView: UIScrollView!
    
    
    

    var thisBetIndex: Int!
    
    var thisUsername: String!
    var currentUser: UserStruct!
    var currentBet: BetStruct!
    var segueType: String!
    var betsRef: FIRDatabaseReference!
    let detailsBottomMargin = CGFloat(100)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        betsRef = FIRDatabase.database().reference().child("Bets")

        // Do any additional setup after loading the view.
        // Initially hide all the buttons
        acceptButton.isHidden = true
        rejectButton.isHidden = true
        addPhotoButton.isHidden = true
        cancelBetButton.isHidden = true
        closeBetButton.isHidden = true
        //resultImage.isHidden = true
        
        
        
        
        ///Position elements
        let greyColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        let screenSize = UIScreen.main.bounds.size
        let screenCenterX = CGFloat(screenSize.width/2)
        
        let profPicSize = CGFloat(screenSize.width/4)
        let profPicOffset = CGFloat(25)
        let topMargin = CGFloat(85)
        let viewPadding = CGFloat(10)
        
        myProfPic.frame = CGRect(x: profPicOffset, y: topMargin, width: profPicSize, height: profPicSize)
        myProfPic.layer.cornerRadius = profPicSize/2
        myProfPic.layer.masksToBounds = true
        myProfPic.layer.borderColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1).cgColor
        myProfPic.layer.borderWidth = 2
        
        friendProfPic.frame = CGRect(x: screenSize.width-profPicOffset-profPicSize, y: topMargin, width: profPicSize, height: profPicSize)
        friendProfPic.layer.cornerRadius = profPicSize/2
        friendProfPic.layer.masksToBounds = true
        friendProfPic.layer.borderWidth = 2
        friendProfPic.layer.borderColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1).cgColor
        
        staticStatusLabel.frame = CGRect(x: 0, y: topMargin, width: staticStatusLabel.frame.width, height: 20)
        staticStatusLabel.center.x = screenCenterX
        statusLabel.frame = CGRect(x: 0, y: staticStatusLabel.frame.maxY + viewPadding, width: statusLabel.frame.width, height: 20)
        statusLabel.center.x = screenCenterX
        
        
        ////// Details view //////
        let detailsSideMargin = CGFloat(15)
        let scrollViewWidth = CGFloat(screenSize.width-2*detailsSideMargin)
        detailsScrollView.frame.size = CGSize(width: scrollViewWidth, height: screenSize.height-topMargin-profPicSize-detailsBottomMargin)
        detailsScrollView.layer.cornerRadius = 10
        detailsScrollView.frame.origin = CGPoint(x: detailsSideMargin, y: topMargin+profPicSize+detailsSideMargin)
        detailsScrollView.contentSize = CGSize(width: scrollViewWidth, height: 1000)
        detailsScrollView.layer.borderColor = greyColor.cgColor
        detailsScrollView.layer.borderWidth = 2
        betDetailsView.layer.cornerRadius = 10
        betDetailsView.layer.borderColor = greyColor.cgColor
        betDetailsView.layer.borderWidth = 2
        let detailsViewWidth = scrollViewWidth
        betDetailsView.frame.size.width = detailsViewWidth
        
        // TODO change this height dynamically
        betDetailsView.frame.size.height = 750
        betDetailsView.frame.origin = CGPoint(x: 0, y: 0)
        
        
        betTextLabel.frame.origin = CGPoint(x: viewPadding, y: viewPadding)
        betDetailsLabel.frame.origin = CGPoint(x: viewPadding, y: betTextLabel.frame.maxY)
    
        stakesLabel.center.x = detailsViewWidth/2
        
        stakesTextLabel.frame.origin.x = CGFloat(viewPadding)
        
        resultImage.layer.cornerRadius = 10
        resultImage.layer.masksToBounds = true
        
        
        //////////////////////////
        

        rejectButton.frame = CGRect(x: 0, y: 9*screenSize.height/10, width: screenSize.width/2, height: screenSize.height/10)
        rejectButton.layer.borderWidth = 1
        rejectButton.layer.borderColor = UIColor.gray.cgColor
        
        acceptButton.frame = CGRect(x: screenSize.width/2, y: 9*screenSize.height/10, width: screenSize.width/2, height: screenSize.height/10)
        
        cancelBetButton.frame = CGRect(x: 0, y: screenSize.height-75, width: screenSize.width, height: 75)
        cancelBetButton.layer.borderColor = UIColor.gray.cgColor
        cancelBetButton.layer.borderWidth = 1
        
        let bottomButtonsCenter = CGPoint(x: screenCenterX, y: screenSize.height-detailsBottomMargin/3)
        addPhotoButton.center = bottomButtonsCenter
        
        closeBetButton.center = bottomButtonsCenter
        closeBetButton.backgroundColor = UIColor(colorLiteralRed: 17/255, green: 141/255, blue: 204/255, alpha: 1)
        closeBetButton.frame = CGRect(x: 0, y: screenSize.height-75, width: screenSize.width, height: 75)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For pendings, do the Accept/Reject buttons
    @IBAction func onTapAccept(_ sender: AnyObject) {
        
        //pendingArray[thisBetIndex].betState = 1
        //pendingArray[thisBetIndex].betText = "BET CHANGED"
        
        //change the state of one bet based on index, change that bet in bet array
        let betIDString = String(currentBet.betID)
        
        betsRef.child(betIDString).updateChildValues(["betState" : "1"])
        
        
        segueType = "MyBets"
        performSegue(withIdentifier: "backToMyBets", sender: self)
        
        
    }
    
    @IBAction func onTapReject(_ sender: AnyObject) {
        
        // Change the state of bet to "Rejected"
        
        performSegue(withIdentifier: "backToMyBets", sender: self)
        
    }
    
    @IBAction func onTapCloseBet(_ sender: AnyObject) {
        
        segueType = "CloseBet"
        performSegue(withIdentifier: "toCloseBet", sender: self)
        
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segueType == "MyBets" {
            let navigationController = segue.destination as! UINavigationController
            let myBetsViewController = navigationController.topViewController as! MyBetsViewController
            // Just continue to pass username
            myBetsViewController.thisUsername = thisUsername
            myBetsViewController.currentUser = currentUser
            
        } else if segueType == "CloseBet" {
            let closeBetViewController = segue.destination as! CloseBetViewController
            closeBetViewController.loadViewIfNeeded()
            
            closeBetViewController.currentUser = currentUser
            closeBetViewController.currentBet = currentBet
            closeBetViewController.whoBetWhoLabel.text = currentBet.betSender + " bet " + currentBet.betReceiver + " that..."
            closeBetViewController.betTextLabel.text = currentBet.betText
            //closeBetViewController.stakesTextLabel.text = getWinnerLoserText(isWinnerLoser: currentBet.winnerLoserToggle) + " " + currentBet.stakesText
            closeBetViewController.myProfPic.image = myProfPic.image
            closeBetViewController.friendProfPic.image = friendProfPic.image
            
            closeBetViewController.userWonLabel.text = currentUser.username + " won"
            var friendUsername: String!
            if currentUser.username == currentBet.betSender {
                friendUsername = currentBet.betReceiver
            } else {
                friendUsername = currentBet.betSender
            }
            closeBetViewController.friendWonLabel.text = friendUsername + " won"
            
            let margin = CGFloat(10)
            let fixWidthSize = CGSize(width: closeBetViewController.betDetailsView.frame.width-2*margin, height: CGFloat.greatestFiniteMagnitude)
            let fitSizeBet = closeBetViewController.betTextLabel.sizeThatFits(fixWidthSize)
            closeBetViewController.betTextLabel.frame.size = fitSizeBet
            closeBetViewController.betDetailsView.frame.size.height = closeBetViewController.betTextLabel.frame.maxY+margin
            
            
        }

        

    }
    
    
    @IBAction func onTapCancelBet(_ sender: AnyObject) {
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
        }
        let okAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            //Change the bet's status, dismiss view controller
           self.navigationController?.popViewController(animated: true)
        
           let betIDString = String(self.currentBet.betID)
           self.betsRef.child(betIDString).updateChildValues(["betState" : "-1"])
           self.segueType = "MyBets"
        }
        

        var confirmCancelAlert = UIAlertController(title: "CANCEL BET", message: "Are you sure you want to cancel this bet? It will be permanently deleted", preferredStyle: .actionSheet)
        confirmCancelAlert.addAction(noAction)
        confirmCancelAlert.addAction(okAction)
        
        present(confirmCancelAlert, animated: true) {
        }
    }
    
    func getWinnerLoserText(isWinnerLoser: Bool) -> String {
        let stakesBeginningText: String!
        if isWinnerLoser == true {
            stakesBeginningText = "Winner gets to "
        } else {
            stakesBeginningText = "Loser has to "
        }
        return stakesBeginningText
    }

}
