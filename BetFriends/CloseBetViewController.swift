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
    @IBOutlet weak var stakesLabel: UILabel!
    @IBOutlet weak var winnerToggle: UISegmentedControl!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userPicView: UIView!
    @IBOutlet weak var userWonLabel: UILabel!
    @IBOutlet weak var friendPicView: UIView!
    @IBOutlet weak var friendWonLabel: UILabel!
    
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var closeBetNavLabel: UILabel!
    
    private var imagePicker: UIImagePickerController!
    
    var currentBet: BetStruct!
    var currentUser: UserStruct!
    var betsRef: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        betsRef = FIRDatabase.database().reference().child("Bets")
        
        // Set up the view (everything fractions of 1/20
        let screenSize = UIScreen.main.bounds.size
        let screenHeight = screenSize.height
        let screenUnit = screenHeight/20
        
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
        
        let picViewSize = CGSize(width: profPicSize+2*smallMargin, height: profPicSize+userWonLabel.frame.height+2*smallMargin)
        let picFrame = CGRect(x: smallMargin,
                              y: smallMargin,
                              width: profPicSize,
                              height: profPicSize)
        let whoWonFrame = CGRect(x: smallMargin, y: profPicSize+2*smallMargin, width: profPicSize, height: 20)
        
        userPicView.frame = CGRect(x: profPicOffset,
                                   y: navView.frame.maxY+mediumMargin,
                                   width: picViewSize.width,
                                   height: picViewSize.height)
        userPicView.layer.cornerRadius = cornerRadius
        myProfPic.frame = picFrame
        userWonLabel.frame = whoWonFrame
        
        friendPicView.frame = CGRect(x: screenSize.width-profPicOffset-picViewSize.width,
                                     y: navView.frame.maxY+mediumMargin,
                                     width: picViewSize.width,
                                     height: picViewSize.height)
        friendPicView.layer.cornerRadius = cornerRadius
        
        myProfPic.layer.cornerRadius = profPicSize/2
        myProfPic.layer.masksToBounds = true
        
        friendProfPic.frame = picFrame
        friendProfPic.layer.cornerRadius = profPicSize/2
        friendProfPic.layer.masksToBounds = true
        
        friendWonLabel.frame = whoWonFrame
        
        
        let detailsSideMargin = CGFloat(15)
        let detailsViewWidth = CGFloat(screenSize.width-2*detailsSideMargin)
        //TODO height dynamically
        betDetailsView.frame = CGRect(x: detailsSideMargin, y: userPicView.frame.maxY+mediumMargin, width: detailsViewWidth, height: 75)
        betDetailsView.layer.cornerRadius = 10
        
        
        winnerToggle.frame = CGRect(x: screenSize.width/4, y: 10*screenUnit+10, width: screenSize.width/2, height: screenUnit)
        winnerToggle.selectedSegmentIndex = -1
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        dismiss(animated: true) {}

    }
    
    
    
    // Upload image, change bet state to 2 or 3,
    @IBAction func onTapSubmit(_ sender: AnyObject) {
        
        let winnerLoser = winnerToggle.selectedSegmentIndex
        let betIDString = String(self.currentBet.betID)
        
        if winnerLoser == -1 {
            // you have to chose a winner!
            print("no winner chosen")
            
        } else if winnerLoser == 0 {
            
            self.betsRef.child(betIDString).updateChildValues(["betState" : "2"])
        } else if winnerLoser == 1 {
            self.betsRef.child(betIDString).updateChildValues(["betState" : "3"])
        }
        
        if resultImage.image != #imageLiteral(resourceName: "image-placeholder"){
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://betfriends-ea4bb.appspot.com")
            let bfImagesRef = storageRef.child("bfimages")
            let filepath = String(currentBet.betID)
            
            let data = UIImageJPEGRepresentation(self.resultImage.image!, 0.8)!
            print("got to upload task")
            bfImagesRef.child(filepath).put(data)
        }
        

        
    }
    
    
    
}
