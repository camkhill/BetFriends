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
    
    let userArray: [String] = ["Cam", "Adey", "Ravi", "Dani","Bex","Zach"]
    let pwArray: [String] = ["a", "a", "a", "a", "a", "a"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // build UI based on screen size
        let screenSize = UIScreen.main.bounds.size
        buildUI(screenSize: screenSize)

        
        // Build some bets for testing purposes
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
                    //getBetsForUser(username:usernameInput!)
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
        
        usernameTextField.frame.size = CGSize(width: screenSize.width-100, height: usernameTextField.frame.height)
        usernameTextField.center.x = screenSize.width/2
        usernameTextField.autocorrectionType = UITextAutocorrectionType(rawValue: 1)!
        passwordTextField.frame.size = CGSize(width: screenSize.width-100, height: usernameTextField.frame.height)
        passwordTextField.center.x = screenSize.width/2
        
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
        let user6 = UserStruct(username: "Vic", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "vic-headshot"))
        
        usersArray = [user0,user1,user2,user3,user4,user5,user6]
        
    }

    

}
