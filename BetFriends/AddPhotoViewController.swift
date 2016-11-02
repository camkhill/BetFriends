//
//  AddPhotoViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 11/1/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MobileCoreServices
import FirebaseStorage

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var stakesTextLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var addPicLaterButton: UIButton!
    
    
    private var imagePicker: UIImagePickerController!
    var currentUser: UserStruct!
    var currentBet: BetStruct!
    var thisUsername: String!
    var seguetype: String!
    
    let screenSize = UIScreen.main.bounds.size
    let greyColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topMargin = CGFloat(50)
        let sideMargin = CGFloat(25)
        let effectiveScreenWidth = screenSize.width-2*sideMargin

        
        congratsLabel.frame = CGRect(x: sideMargin,
                                     y: topMargin,
                                     width: effectiveScreenWidth,
                                     height: congratsLabel.frame.height)
        stakesTextLabel.frame = CGRect(x: sideMargin,
                                       y: congratsLabel.frame.maxY,
                                       width: effectiveScreenWidth,
                                       height: 100)
        
        resultImage.frame = CGRect(x: sideMargin,
                                   y: stakesTextLabel.frame.maxY+10,
                                   width: effectiveScreenWidth,
                                   height: effectiveScreenWidth)
        resultImage.layer.cornerRadius = 10

        resultImage.image = #imageLiteral(resourceName: "transparent-placeholder")
        resultImage.alpha = 0.5
        resultImage.layer.masksToBounds = true
        
        addPhotoButton.frame = resultImage.frame
        addPhotoButton.setTitle("Tap to add a photo!", for: .normal)
        
        
        addPicLaterButton.frame = CGRect(x: 0, y: screenSize.height-75, width: screenSize.width/2, height: 75)
        
        uploadButton.frame = CGRect(x: screenSize.width/2, y: screenSize.height-75, width: screenSize.width/2, height: 75)
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapAddPicLater(_ sender: AnyObject) {
        seguetype = "addpiclater"
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
            self.resultImage.alpha = 1.0
            self.addPhotoButton.setTitle("Tap to change photo", for: .normal)
            self.resultImage.layer.borderWidth = 2
            self.resultImage.layer.borderColor = self.greyColor.cgColor

            
        } else {
            print("video was taken")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func onTapUpload(_ sender: AnyObject) {
        
        seguetype = "addpiclater"
        
        if resultImage.image != #imageLiteral(resourceName: "transparent-placeholder") {
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://betfriends-ea4bb.appspot.com")
            let bfImagesRef = storageRef.child("bfimages")
            let filepath = String(currentBet.betID)
            
            let data = UIImageJPEGRepresentation(self.resultImage.image!, 0.8)!
            print("uploading image!!!!")
            
            // Disabling uploading for testing
            //bfImagesRef.child(filepath).put(data)
            performSegue(withIdentifier: "addphoto2mybets", sender: self)

        } else {
            print("No image selected")
        }
        
        
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
