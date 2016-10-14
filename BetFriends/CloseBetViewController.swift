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


class CloseBetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var myProfPic: UIImageView!
    @IBOutlet weak var friendProfPic: UIImageView!
    @IBOutlet weak var closeBetLabel: UILabel!
    @IBOutlet weak var betDetailsView: UIView!
    @IBOutlet weak var betTextLabel: UILabel!
    @IBOutlet weak var stakesTextLabel: UILabel!
    @IBOutlet weak var stakesLabel: UILabel!
    @IBOutlet weak var whoWonLabel: UILabel!
    @IBOutlet weak var winnerToggle: UISegmentedControl!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    private var imagePicker: UIImagePickerController!
    
    var currentBet: BetStruct!
    var currentUser: UserStruct!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Set up the view (everything fractions of 1/20
        let screenSize = UIScreen.main.bounds.size
        let screenHeight = screenSize.height
        let screenUnit = screenHeight/20
        
        let screenCenterX = CGFloat(screenSize.width/2)
        let profPicSize = CGFloat(3*screenUnit)
        let profPicOffset = CGFloat(25)
    
        myProfPic.frame = CGRect(x: profPicOffset, y: screenUnit, width: profPicSize, height: profPicSize)
        myProfPic.layer.cornerRadius = profPicSize/2
        myProfPic.layer.masksToBounds = true
        friendProfPic.frame = CGRect(x: screenSize.width-profPicOffset-profPicSize, y: screenUnit, width: profPicSize, height: profPicSize)
        friendProfPic.layer.cornerRadius = profPicSize/2
        friendProfPic.layer.masksToBounds = true
        closeBetLabel.center = CGPoint(x: screenCenterX, y: myProfPic.center.y)
        
        let detailsSideMargin = CGFloat(15)
        let detailsViewWidth = CGFloat(screenSize.width-2*detailsSideMargin)
        //TODO height dynamically
        betDetailsView.frame = CGRect(x: detailsSideMargin, y: 4*screenUnit+10, width: detailsViewWidth, height: 5*screenUnit)
        betDetailsView.layer.cornerRadius = 10
        
        
        
        
        whoWonLabel.frame.origin = CGPoint(x: 0, y: 9*screenUnit+15)
        whoWonLabel.center.x = screenCenterX
        
        winnerToggle.frame = CGRect(x: screenSize.width/4, y: 10*screenUnit+10, width: screenSize.width/2, height: screenUnit)
        winnerToggle.selectedSegmentIndex = -1
        
        resultImage.frame = CGRect(x: 0, y: 11*screenUnit+15, width: 7*screenUnit, height: 7*screenUnit)
        resultImage.center.x = screenCenterX
        resultImage.layer.cornerRadius = 10
        resultImage.layer.masksToBounds = true
        addPhotoButton.center = resultImage.center
        
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
        } else {
            print("video was taken")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func onTapCancel(_ sender: AnyObject) {
        dismiss(animated: true) {}
    }
    
    
}
