//
//  AddPhotoViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 11/1/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

class AddPhotoViewController: UIViewController {

    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var stakesTextLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    
    var currentUser: UserStruct!
    var currentBet: BetStruct!
    var thisUsername: String!
    var seguetype: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapAddPicLater(_ sender: AnyObject) {
        seguetype = "addpiclater"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if seguetype == "addpiclater" {
            let navigationController = segue.destination as! UINavigationController
            let myBetsViewController = navigationController.topViewController as! MyBetsViewController
            // Just continue to pass username
            myBetsViewController.thisUsername = thisUsername
            myBetsViewController.currentUser = currentUser
        }
        
        
    }


}
