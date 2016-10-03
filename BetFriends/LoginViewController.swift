//
//  LoginViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/23/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newUserLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var screenCenterX: CGFloat!
    
    var betArray = [BetStruct]()
    let emptyImage: UIImage! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///// Align UI element
        
        let screenSize = UIScreen.mainScreen().bounds.size
        screenCenterX = (screenSize.width)/2
        
        titleLabel.center.x = screenCenterX
        loginButton.center.x = screenCenterX
        newUserLabel.center = CGPoint(x: screenCenterX, y: screenSize.height-70)
        signUpButton.center = CGPoint(x: screenCenterX, y: screenSize.height-40)
        
        usernameTextField.frame.size = CGSize(width: 2*screenSize.width/3, height: usernameTextField.frame.height)
        usernameTextField.autocorrectionType = UITextAutocorrectionType(rawValue: 1)!
        passwordTextField.frame.size = CGSize(width: 2*screenSize.width/3, height: usernameTextField.frame.height)
        
        loginButton.enabled = false
        
        
        
        /////
        
        // Build some bets for testing purposes
        buildMockBetArray()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapLogin(sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        
        //check if username is a valid username in DB
        
        //if username is valid, check password
        if username == "a" {
            
            //check password - if correct, login
            if password == "a" {
                performSegueWithIdentifier("LoginSegue", sender: self)
                
            } else {

                displayBadLoginAlert()
                
            }
        } else {
            //present alert saying Username not recognized?
            displayBadLoginAlert()
        }
        
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Send to MyBets with user information
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    func displayBadLoginAlert() {
        let badLoginAlert = UIAlertController(title: "Invalid Login", message: "Username/password not recognized", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            
        })
        
        badLoginAlert.addAction(okAction)
        self.presentViewController(badLoginAlert, animated: true, completion: {
        })
    }
    
    ////// Only enable login button if something is entered in UN and PW fields
    
    //While user edits username, if it is not empty, and pw not empty, enable the button
    @IBAction func onEditingUsername(sender: AnyObject) {
        let enteredUN = usernameTextField.text
        let enteredPW = passwordTextField.text
        if enteredUN != "" && enteredPW != "" {
            loginButton.enabled = true
        } else {
            loginButton.enabled = false
        }
    }
    
    //Same for password field
    @IBAction func onEditingPassword(sender: AnyObject) {
        let enteredUN = usernameTextField.text
        let enteredPW = passwordTextField.text
        if enteredUN != "" && enteredPW != "" {
            loginButton.enabled = true
        } else {
            loginButton.enabled = false
        }
    }
    
    /////////////////
    
    func buildMockBetArray() -> Void {
        let bet0 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet1 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet2 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet3 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet4 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet5 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet6 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet7 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet8 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet9 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        let bet10 = BetStruct(betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: NSDate(timeIntervalSinceReferenceDate: 10000), creationDate: NSDate(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: NSDate(timeIntervalSinceReferenceDate: 0))
        
        betArray = [bet0,bet1,bet2,bet3,bet4,bet5,bet6,bet7,bet8,bet9]
    }

}
