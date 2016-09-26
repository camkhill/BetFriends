//
//  NewBetViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/23/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      ////set position of everything in view//////
        let screenSize = UIScreen.mainScreen().bounds.size
        let screenCenterX = screenSize.width/2
        
        //Define friend text entry
        friendTextView.layer.cornerRadius = 10
        friendTextView.layer.borderColor = UIColor.grayColor().CGColor
        friendTextView.layer.borderWidth = 0.5
        friendTextView.frame = CGRect(origin: friendTextView.frame.origin, size: CGSize(width: screenSize.width-40, height: friendTextView.frame.height))
        friendTextView.autocorrectionType = UITextAutocorrectionType(rawValue: 1)!
        
        
        //Define the bet view
        /*betView.frame = CGRect(origin: betView.frame.origin, size: CGSize(width: screenSize.width-40, height: betView.frame.height))
        betView.center.x = screenCenterX
        betView.layer.cornerRadius = 10
        betView.layer.borderColor = UIColor.grayColor().CGColor
        betView.layer.borderWidth = 0.5*/
        
        betTextView.frame = CGRect(origin: betTextView.frame.origin, size: CGSize(width: screenSize.width-40, height: betTextView.frame.height))
        betTextView.center.x = screenCenterX
        betTextView.layer.cornerRadius = 10
        betTextView.layer.borderColor = UIColor.grayColor().CGColor
        betTextView.layer.borderWidth = 0.5
        betTextView.autocapitalizationType = UITextAutocapitalizationType(rawValue: 0)!
        
        //Define segmented controller properties
        loserwinnerControl.frame.size = CGSize(width: screenSize.width-60, height: loserwinnerControl.frame.height)
        loserwinnerControl.center.x = screenCenterX
        
        //Define the stakes view
        stakesTextView.center.x = screenCenterX
        stakesTextView.frame = CGRect(origin: stakesTextView.frame.origin, size: CGSize(width: screenSize.width-40, height: stakesTextView.frame.height))
        stakesTextView.layer.cornerRadius = 10
        stakesTextView.layer.borderColor = UIColor.grayColor().CGColor
        stakesTextView.layer.borderWidth = 0.5
        stakesTextView.autocapitalizationType = UITextAutocapitalizationType(rawValue: 0)!
        
        
      /////////////////////////////////////////////

        

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
    @IBAction func onTapSubmit(sender: AnyObject) {
        
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
        
        betDictionary = ["Friend":friendText!, "Bet":betText, "LoserWinner":loserwinnerString, "Stakes":stakesText, "EndDate":endDate]
        print(betDictionary)
        //print(betDictionary["Friend"])
        
        
        dismissViewControllerAnimated(true) {
        }
    }

    @IBAction func onTapCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true) {
        }
    }
    
    //On editing the friend field, display autofill options
    
    
    //On stopping editing, dismiss the table
    
    
}
