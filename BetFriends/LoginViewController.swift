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
    var usersBetArray = [BetStruct]()
    var usersArray = [UserStruct]()
    var usernameInput: String!
    var loginUserStruct: UserStruct!
    
    let emptyImage: UIImage! = nil
    let waterslideImage: UIImage = #imageLiteral(resourceName: "waterslide")
    
    let userArray: [String] = ["Cam", "Adey", "Ravi", "Dani"]
    let pwArray: [String] = ["a", "a", "a", "a"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // build UI based on screen size
        let screenSize = UIScreen.main.bounds.size
        buildUI(screenSize: screenSize)

        
        // Build some bets for testing purposes
        buildMockBetArray()
        buildMockUsers()
        //
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapLogin(_ sender: AnyObject) {
        
        
        
        usernameInput = usernameTextField.text
        let password = passwordTextField.text
        
        var indexA: Int = -1
        //TODO Populate fullUserArray from Firebase and make a UserStruct
        
        //check if username is a valid username in DB
        for usernames in userArray {
            
            indexA = indexA+1
        //if username is valid, check password
            if (usernameInput == usernames && password == pwArray[indexA]) {
            
                for users in usersArray {
                    if users.username == usernameInput {
                        loginUserStruct = users
                    }
                }
                    //TODO Move getBets to MyBets
                    getBetsForUser(username:usernameInput!)
                    performSegue(withIdentifier: "LoginSegue", sender: self)
                
            }
        }
        
        //if it gets through this loop w/o segue, then display bad login
        displayBadLoginAlert()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let myBetsViewController = navigationController.topViewController as! MyBetsViewController
        
        //TODO Only pass the username - get rid of the rest
        //myBetsViewController.betArray = usersBetArray
        myBetsViewController.thisUsername = usernameInput
        //myBetsViewController.userArray = usersArray
        myBetsViewController.currentUser = loginUserStruct
        
        // Send to MyBets with user information
      

    }
 
    func displayBadLoginAlert() {
        let badLoginAlert = UIAlertController(title: "Invalid Login", message: "Username/password not recognized", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
        })
        
        badLoginAlert.addAction(okAction)
        self.present(badLoginAlert, animated: true, completion: {
        })
    }
    
    ////// Only enable login button if something is entered in UN and PW fields
    
    //While user edits username, if it is not empty, and pw not empty, enable the button
    @IBAction func onEditingUsername(_ sender: AnyObject) {
        let enteredUN = usernameTextField.text
        let enteredPW = passwordTextField.text
        if enteredUN != "" && enteredPW != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    //Same for password field
    @IBAction func onEditingPassword(_ sender: AnyObject) {
        let enteredUN = usernameTextField.text
        let enteredPW = passwordTextField.text
        if enteredUN != "" && enteredPW != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    func buildUI(screenSize: CGSize) -> Void {
        screenCenterX = (screenSize.width)/2
        
        titleLabel.center.x = screenCenterX
        loginButton.center.x = screenCenterX
        newUserLabel.center = CGPoint(x: screenCenterX, y: screenSize.height-70)
        signUpButton.center = CGPoint(x: screenCenterX, y: screenSize.height-40)
        
        usernameTextField.frame.size = CGSize(width: 2*screenSize.width/3, height: usernameTextField.frame.height)
        usernameTextField.autocorrectionType = UITextAutocorrectionType(rawValue: 1)!
        passwordTextField.frame.size = CGSize(width: 2*screenSize.width/3, height: usernameTextField.frame.height)
        
        loginButton.isEnabled = false
        
    }
    
    //TODO delete this eventually
    func buildMockUsers() -> Void {
        let user0 = UserStruct(username: "Cam", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "headshot"))
        let user1 = UserStruct(username: "Adey", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "adey-headshot"))
        let user2 = UserStruct(username: "Ravi", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "nopic-headshot"))
        let user3 = UserStruct(username: "Dani", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "dani-headshot"))
        let user4 = UserStruct(username: "Bex", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "bex-headshot"))
        let user5 = UserStruct(username: "Zach", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "zach-headshot"))
        
        usersArray = [user0,user1,user2,user3,user4,user5]
        
    }
    
    //TODO delete this eventually
    func buildMockBetArray() -> Void {
        let bet0 = BetStruct(betID: 0, betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet1 = BetStruct(betID: 1, betText: "it will rain today", betSender: "Cam", betReceiver: "Adey", winnerLoserToggle: false, stakesText: "do 1000 pushups this week", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet2 = BetStruct(betID: 2, betText: "EASE iOS version 5.14 will be released by Thanksgiving", betSender: "Dani", betReceiver: "Cam", winnerLoserToggle: false, stakesText: "bake a cake for the office", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet3 = BetStruct(betID: 3, betText: "Hurricane Matthew will cause some flights to be delayed", betSender: "Ravi", betReceiver: "Cam", winnerLoserToggle: true, stakesText: "to ride shotgun on the really long car ride across the country through the states of virginia maryland iowa ohio kentucky nebraska new mexico etc.", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet4 = BetStruct(betID: 4, betText: "Hillary wins the presidency", betSender: "Bex", betReceiver: "Cam", winnerLoserToggle: false, stakesText: "cut off 7 inches of hair (or shave it off if you have less than that much hair", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet5 = BetStruct(betID: 5, betText: "it will snow in DC before December 15th", betSender: "Cam", betReceiver: "Bex", winnerLoserToggle: false, stakesText: "go in the snow bearfoot for 1 FULL Minute whenever the first snow does actually end up coming - ouch!!", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet6 = BetStruct(betID: 6, betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Zach", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet7 = BetStruct(betID: 7, betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Zach", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 0, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet8 = BetStruct(betID: 8, betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Zach", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 1, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet9 = BetStruct(betID: 9, betText: "the Broncos will win the Superbowl this year", betSender: "Cam", betReceiver: "Adey", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 1, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet10 = BetStruct(betID: 10, betText: "this bet will not show when cam logs in", betSender: "Adey", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 2, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet11 = BetStruct(betID: 11, betText: "this bet will not show when cam logs in", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 2, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet12 = BetStruct(betID: 12, betText: "this bet will not show when cam logs in", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 3, image: emptyImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        let bet13 = BetStruct(betID: 13, betText: "this bet will not show when cam logs in", betSender: "Cam", betReceiver: "Ravi", winnerLoserToggle: false, stakesText: "buy a big delicious pizza for the whole team", endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 0), betState: 2, image: waterslideImage, lastModified: Date(timeIntervalSinceReferenceDate: 0))
        
        betArray = [bet0,bet1,bet2,bet3,bet4,bet5,bet6,bet7,bet8,bet9,bet10,bet11,bet12,bet13]
    }
    
    //TODO move this to MyBets
    func getBetsForUser(username:String) -> Void {
        
        for bet in betArray {
            
            if bet.betSender == username || bet.betReceiver == username {
                usersBetArray.append(bet)
            }
            
        }
        
        print(usersBetArray.count)
    }
    
    

}
