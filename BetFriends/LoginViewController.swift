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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///// Align UI element
        
        let screenSize = UIScreen.mainScreen().bounds.size
        screenCenterX = (screenSize.width)/2
        
        titleLabel.center.x = screenCenterX
        loginButton.center.x = screenCenterX
        newUserLabel.center = CGPoint(x: screenCenterX, y: screenSize.height-70)
        signUpButton.center = CGPoint(x: screenCenterX, y: screenSize.height-40)
        
        
        
        
        
        /////
        
        
        
        
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
        if username == "" {
            
            //check password - if correct, login
            if password == "" {
                performSegueWithIdentifier("LoginSegue", sender: self)
                
            } else {
                
                //present alert saying UN/PW incorrect
                /*let badLoginAlert = UIAlertController(title: "Invalid Login", message: "Username/password not recognized", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                    
                })
                
                badLoginAlert.addAction(okAction)
                self.presentViewController(badLoginAlert, animated: true, completion: {
                })*/
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
    
    
    

}
