//
//  NewBetViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/23/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewBetViewController: UIViewController {

    
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var friendTextView: UITextField!
    @IBOutlet weak var whatsTheBetLabel: UILabel!
    

    @IBOutlet weak var ibetthatLabel: UILabel!
    @IBOutlet weak var betTextView: UITextView!
    @IBOutlet weak var whatStakesLabel: UILabel!
    @IBOutlet weak var loserwinnerControl: UISegmentedControl!
    @IBOutlet weak var stakesTextView: UITextView!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    
    let autofillArray = ["sara","vic","zach","mike","cristy","susan","sue"]
    let screenSize = UIScreen.main.bounds.size
    var totalBets: Int!
    var currentUser: UserStruct!
    
    var betsRef: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Get Firebase ref
        betsRef = FIRDatabase.database().reference().child("Bets")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
      ////set position of everything in view//////
        
        let topMargin = CGFloat(100)
        let sideMargin = CGFloat(25)
        let screenCenterX = screenSize.width/2
        let effectiveScreenWidth = screenSize.width-2*sideMargin
        let largeFontSize = CGFloat(20)
        let smallFontSize = CGFloat(15)
        let greyColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        let borderWidth = CGFloat(1)
        let bottomButtonHeight = CGFloat(75)
        
        
        opponentLabel.frame = CGRect(x: sideMargin, y: topMargin, width: effectiveScreenWidth, height: largeFontSize)
        
        //Define friend text entry
        friendTextView.layer.cornerRadius = 10
        friendTextView.layer.borderColor = greyColor.cgColor
        friendTextView.layer.borderWidth = borderWidth
        friendTextView.frame = CGRect(x: sideMargin, y: opponentLabel.frame.maxY, width: effectiveScreenWidth, height: friendTextView.frame.height)
        friendTextView.autocorrectionType = UITextAutocorrectionType(rawValue: 1)!
        
        
        betTextView.frame = CGRect(origin: betTextView.frame.origin, size: CGSize(width: screenSize.width-40, height: betTextView.frame.height))
        betTextView.center.x = screenCenterX
        betTextView.layer.cornerRadius = 10
        betTextView.layer.borderColor = UIColor.gray.cgColor
        betTextView.layer.borderWidth = 0.5
        betTextView.autocapitalizationType = UITextAutocapitalizationType(rawValue: 0)!
        
        //Define segmented controller properties
        loserwinnerControl.frame.size = CGSize(width: screenSize.width-60, height: loserwinnerControl.frame.height)
        loserwinnerControl.center.x = screenCenterX
        
        //Define the stakes view
        stakesTextView.frame = CGRect(origin: stakesTextView.frame.origin, size: CGSize(width: screenSize.width-40, height: stakesTextView.frame.height))
        stakesTextView.center.x = screenCenterX
        stakesTextView.layer.cornerRadius = 10
        stakesTextView.layer.borderColor = UIColor.gray.cgColor
        stakesTextView.layer.borderWidth = 0.5
        stakesTextView.autocapitalizationType = UITextAutocapitalizationType(rawValue: 0)!
        
        submitButton.frame = CGRect(x: 0, y: screenSize.height-bottomButtonHeight, width: screenSize.width, height: bottomButtonHeight)
    
        endDateLabel.isHidden = true
        
      /////////////////////////////////////////////

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func onTapSubmit(_ sender: AnyObject) {
        
        //Send the bet to Firebase
        var betDictionary = [String:AnyObject]()
        
        let friendText = friendTextView.text
        let betText = betTextView.text
        let loserwinnerString: String!
        let loserwinnerChoice = loserwinnerControl.selectedSegmentIndex
        if loserwinnerChoice == 0 {
            loserwinnerString = "Loser"
        } else {
            loserwinnerString = "Winner"
        }
        let stakesText = stakesTextView.text
        let endDate = "Today"
        
        writeBetToFirebase(betText: betText!, stakesText: stakesText!, friendUsername: friendText!, winnerLoserToggle: loserwinnerString)
        
        performSegue(withIdentifier: "newbettomybets", sender: self)
        //performSegueWithIdentifier("ConfirmationSegue", sender: nil)
        
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let navigationController = segue.destination as! UINavigationController
        let myBetsViewController = navigationController.topViewController as! MyBetsViewController
        myBetsViewController.currentUser = currentUser
        
     // Pass the selected object to the new view controller.
     }
    
    
    //On editing the friend field, display autofill options
    
    
    //On stopping editing, dismiss the table
    
    func writeBetToFirebase(betText: String, stakesText: String, friendUsername: String, winnerLoserToggle: String) -> Void {
        
        let stringNewBetID = String(totalBets+1)
        let stringUsername = currentUser.username!
        betsRef.child(stringNewBetID).setValue([
            "betText" : betText,
            "stakesText" : stakesText,
            "betReceiver" : friendUsername,
            "betSender" : stringUsername,
            "betState" : "0",
            "winnerLoserToggle" : winnerLoserToggle
        ])
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
