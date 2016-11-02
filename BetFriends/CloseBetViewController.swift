//
//  CloseBetViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 10/8/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MobileCoreServices
import FirebaseStorage


class CloseBetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var myProfPic: UIImageView!
    @IBOutlet weak var friendProfPic: UIImageView!
    @IBOutlet weak var betDetailsView: UIView!
    @IBOutlet weak var betTextLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var friendWonButton: UIButton!
    @IBOutlet weak var userWonButton: UIButton!
    @IBOutlet weak var userPicView: UIView!
    @IBOutlet weak var userWonLabel: UILabel!
    @IBOutlet weak var friendPicView: UIView!
    @IBOutlet weak var friendWonLabel: UILabel!
    @IBOutlet weak var whoBetWhoLabel: UILabel!
    
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var closeBetNavLabel: UILabel!
    
    private var imagePicker: UIImagePickerController!
    
    var currentBet: BetStruct!
    var currentUser: UserStruct!
    var betsRef: FIRDatabaseReference!
    
    let blueColor = UIColor(colorLiteralRed: 17/255, green: 141/255, blue: 204/255, alpha: 1)
    var winnerInt: Int = 0
    var segueType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        betsRef = FIRDatabase.database().reference().child("Bets")
        
        // Set up the view (everything fractions of 1/20
        let screenSize = UIScreen.main.bounds.size
        let screenHeight = screenSize.height
        let screenUnit = screenHeight/20
        let greyColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        
        let screenCenterX = CGFloat(screenSize.width/2)
        let profPicSize = CGFloat(3*screenUnit)
        let profPicOffset = CGFloat(35)
        let mediumMargin = CGFloat(20)
        let smallMargin = CGFloat(10)
        let cornerRadius = CGFloat(10)
        
        navView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 75)
        navView.backgroundColor = UIColor.white
        navView.layer.borderWidth = 0.5
        navView.layer.borderColor = UIColor.gray.cgColor
        closeBetNavLabel.frame.origin.y = CGFloat(35)
        closeBetNavLabel.center.x = screenSize.width/2
        xButton.frame.origin.y = CGFloat(35)
        xButton.frame.origin.x = screenSize.width-40
        
        let picViewSize = CGSize(width: profPicSize+2*smallMargin, height: profPicSize+userWonLabel.frame.height+3*smallMargin)
        let picFrame = CGRect(x: smallMargin,
                              y: smallMargin,
                              width: profPicSize,
                              height: profPicSize)
        let whoWonFrame = CGRect(x: smallMargin, y: profPicSize+2*smallMargin, width: profPicSize, height: 20)
        let buttonFrame = CGRect(x: 0, y: 0, width: picViewSize.width, height: picViewSize.height)
        
        userPicView.frame = CGRect(x: profPicOffset,
                                   y: navView.frame.maxY+mediumMargin,
                                   width: picViewSize.width,
                                   height: picViewSize.height)
        userPicView.layer.cornerRadius = cornerRadius
        userPicView.backgroundColor = UIColor.clear
        userPicView.layer.borderWidth = 2
        userPicView.layer.borderColor = greyColor.cgColor
        
        userWonButton.frame = buttonFrame
        myProfPic.frame = picFrame
        myProfPic.layer.borderWidth = 2
        myProfPic.layer.borderColor = greyColor.cgColor
        userWonLabel.frame = whoWonFrame
        
        friendPicView.frame = CGRect(x: screenSize.width-profPicOffset-picViewSize.width,
                                     y: navView.frame.maxY+mediumMargin,
                                     width: picViewSize.width,
                                     height: picViewSize.height)
        friendPicView.layer.borderColor = greyColor.cgColor
        friendPicView.layer.borderWidth = 2
        friendPicView.backgroundColor = UIColor.clear
        friendPicView.layer.cornerRadius = cornerRadius
        friendWonButton.frame = buttonFrame
        
        myProfPic.layer.cornerRadius = profPicSize/2
        myProfPic.layer.masksToBounds = true
        
        friendProfPic.frame = picFrame
        friendProfPic.layer.cornerRadius = profPicSize/2
        friendProfPic.layer.masksToBounds = true
        friendProfPic.layer.borderColor = greyColor.cgColor
        friendProfPic.layer.borderWidth = 2
        
        friendWonLabel.frame = whoWonFrame
        
        
        let detailsSideMargin = CGFloat(15)
        let detailsViewWidth = CGFloat(screenSize.width-2*detailsSideMargin)
        //TODO height dynamically
        betDetailsView.frame = CGRect(x: detailsSideMargin, y: userPicView.frame.maxY+mediumMargin, width: detailsViewWidth, height: 10*smallMargin)
        betDetailsView.layer.borderColor = greyColor.cgColor
        betDetailsView.layer.borderWidth = 2
        whoBetWhoLabel.frame = CGRect(x: smallMargin, y: smallMargin, width: detailsViewWidth-2*smallMargin, height: 15)
        betTextLabel.frame = CGRect(x: smallMargin, y: whoBetWhoLabel.frame.maxY, width: detailsViewWidth-2*smallMargin, height: 5*smallMargin)
        
        
        betDetailsView.layer.cornerRadius = 10
        
        
        resultImage.frame = CGRect(x: 0, y: 11*screenUnit+15, width: 7*screenUnit, height: 7*screenUnit)
        resultImage.center.x = screenCenterX
        resultImage.layer.cornerRadius = 10
        resultImage.layer.masksToBounds = true
        addPhotoButton.center = resultImage.center
        
        submitButton.frame = CGRect(x: 0, y: screenSize.height-75, width: screenSize.width, height: 75)
        submitButton.center = CGPoint(x: screenCenterX, y: screenHeight-2*screenUnit/3)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("preareing for segue")
        if segueType == "back" {
            
        } else if segueType == "submit" {
            
            print("its a submit segue")
            let addPhotoViewController = segue.destination as! AddPhotoViewController
            addPhotoViewController.view.layoutIfNeeded()
            addPhotoViewController.currentUser = currentUser
            addPhotoViewController.thisUsername = currentUser.username
            addPhotoViewController.currentBet = currentBet
            
            print("passed values ok")
            print("winner int: \(winnerInt)")
            
            if winnerInt == 1 {
                
                addPhotoViewController.congratsLabel.text = "CONGRATS, YOU WON!"
                print("updated label ok")
                let stakesBeginningText = getWinnerLoserText(winnerInt: 1)
                print("got winner loser test: \(stakesBeginningText)")
                addPhotoViewController.stakesTextLabel.text = stakesBeginningText + currentBet.stakesText
                
            } else {
                addPhotoViewController.congratsLabel.text = "OH NO, YOU LOST!"
                let stakesBeginningText = getWinnerLoserText(winnerInt: 2)
                addPhotoViewController.stakesTextLabel.text = stakesBeginningText + currentBet.stakesText
            }
            
            
        }
        
        
        
    }
 

    @IBAction func onTapAddPhoto(_ sender: AnyObject) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //TODO Give an option to use camera or gallery
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            print("Opening photo library")
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            self.resultImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
            
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://betfriends-ea4bb.appspot.com")
            let bfImagesRef = storageRef.child("bfimages")
            let filepath = String(currentBet.betID)
            
            let data = UIImageJPEGRepresentation(self.resultImage.image!, 0.8)!
            print("got to upload task")
            bfImagesRef.child(filepath).put(data)
            
            
        } else {
            print("video was taken")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func onTapX(_ sender: AnyObject) {
        
        segueType = "back"
        dismiss(animated: true) {}

    }
    
    @IBAction func onTapUserWon(_ sender: AnyObject) {
        userPicView.backgroundColor = blueColor
        friendPicView.backgroundColor = UIColor.clear
        winnerInt = 1
    }
    
    @IBAction func onTapFriendWon(_ sender: AnyObject) {
        friendPicView.backgroundColor = blueColor
        userPicView.backgroundColor = UIColor.clear
        winnerInt = 2
    }
    
    
    
    
    
    // Upload image, change bet state to 2 or 3,
    @IBAction func onTapSubmit(_ sender: AnyObject) {
        
        let betIDString = String(self.currentBet.betID)
        
        let whoWon = senderReceiverWinner(winnerInt: winnerInt)
        
        if whoWon == "N/A" {
            // you have to chose a winner!
            print("no winner chosen")
            
        } else if whoWon == "Sender" {
            //self.betsRef.child(betIDString).updateChildValues(["betState" : "2"])
            /*
            if resultImage.image != #imageLiteral(resourceName: "image-placeholder"){
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://betfriends-ea4bb.appspot.com")
                let bfImagesRef = storageRef.child("bfimages")
                let filepath = String(currentBet.betID)
                
                let data = UIImageJPEGRepresentation(self.resultImage.image!, 0.8)!
                print("got to upload task")
                bfImagesRef.child(filepath).put(data)
            }
            */
            segueType = "submit"
            performSegue(withIdentifier: "toAddPhoto", sender: self)

        } else if whoWon == "Receiver" {
            //self.betsRef.child(betIDString).updateChildValues(["betState" : "3"])
            /*
            if resultImage.image != #imageLiteral(resourceName: "image-placeholder"){
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://betfriends-ea4bb.appspot.com")
                let bfImagesRef = storageRef.child("bfimages")
                let filepath = String(currentBet.betID)
                
                let data = UIImageJPEGRepresentation(self.resultImage.image!, 0.8)!
                print("got to upload task")
                bfImagesRef.child(filepath).put(data)
            }
            */
            segueType = "submit"
            performSegue(withIdentifier: "toAddPhoto", sender: self)
        }
        
        

        

        
    }
    
    func senderReceiverWinner(winnerInt: Int) -> String {
        var senderRecieverWon: String!
        
        if winnerInt == 0 {
            senderRecieverWon = "N/A"
        } else if winnerInt == 1 {
            if currentUser.username == currentBet.betSender {
                senderRecieverWon = "Sender"
            } else {
                senderRecieverWon = "Receiver"
            }
        } else if winnerInt == 2 {
            if currentUser.username == currentBet.betSender {
                senderRecieverWon = "Receiver"
            } else {
                senderRecieverWon = "Sender"
            }
        }
        
        return senderRecieverWon
    }
    
    
    func getWinnerLoserText(winnerInt: Int) -> String {
        let stakesBeginningText: String!
        let friendUsername: String!
        let isWinnerLoser = currentBet.winnerLoserToggle
        
        if currentUser.username == currentBet.betSender {
            friendUsername = currentBet.betReceiver
        } else {
            friendUsername = currentBet.betSender
        }
        
        
        if isWinnerLoser == true {
            if winnerInt == 1 {
                stakesBeginningText = "You get to "
            } else {
                stakesBeginningText = friendUsername + " gets to "
            }
        } else {
            if winnerInt == 1 {
                stakesBeginningText = friendUsername + " has to "
            } else {
                stakesBeginningText = "You have to "
            }
        }
        return stakesBeginningText
    }
    
}
