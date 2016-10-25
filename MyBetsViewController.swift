//
//  MyBetsViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/19/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class MyBetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pendingTableView: UITableView!
    @IBOutlet weak var activeTableView: UITableView!
    @IBOutlet weak var completedTableView: UITableView!
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var newBetButton: UIButton!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    
    //temp cell
    let cell: UITableViewCell! = nil
    var segueIndicator: String!
    var profPicSize: CGFloat!
    var tableViewSize: CGSize!
    var thisRowHeight: CGFloat!
    var selectedCell: Int!
    
    var rowNum: Int!
    var thisUsername: String!
    
    
    var betArray = [BetStruct]()
    var pendingArray = [BetStruct]()
    var activeArray = [BetStruct]()
    var completedArray = [BetStruct]()
    var userArray = [UserStruct]()
    var currentUser: UserStruct!
    
    var usersRef: FIRDatabaseReference!
    var betsRef: FIRDatabaseReference!
    var storage: FIRStorage!
    var storageRef: FIRStorageReference!
    
    var totalBets = Int()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segueIndicator = "sign-out"
        
        // Get Firebase reference for users and bets
        usersRef = FIRDatabase.database().reference().child("Users")
        betsRef = FIRDatabase.database().reference().child("Bets")
        storage = FIRStorage.storage()
        storageRef = storage.reference(forURL: "gs://betfriends-ea4bb.appspot.com").child("bfimages")
        
        /////////// prepare the bets ////////////
        // Get all bets for the particular user
        
        
        //betArray = getUsersBets(username: currentUser.username)
        //Separate them into pending, active, completed bets
        //buildBetArrays(betArray: betArray)
        getFirebaseBets()
        // Get all users so their info can be used
        userArray = getAllUserData()
        
        
        
        pendingTableView.delegate = self
        pendingTableView.dataSource = self
        activeTableView.delegate = self
        activeTableView.dataSource = self
        completedTableView.delegate = self
        completedTableView.dataSource = self
        
        
        //Determine screen size
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)
        let screenWidth3 = CGFloat(3 * UIScreen.main.bounds.size.width)
        let screenHeight = CGFloat(UIScreen.main.bounds.size.height)
        
        //Set My Bets label position
        signOutButton.tintColor = UIColor(colorLiteralRed: 17/255, green: 141/255, blue: 204/255, alpha: 100)
        
        //Set segmentedControl state, location
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.center = CGPoint(x: view.center.x, y: 90)
        segmentedControl.tintColor = UIColor(colorLiteralRed: 17/255, green: 141/255, blue: 204/255, alpha: 100)
        
        //Set Up New Bet button
        newBetButton.frame.origin = CGPoint(x: screenWidth-(screenWidth/4), y: screenHeight-(screenWidth/4))
        let newBetButtonSize = CGFloat(screenWidth/6)
        
        newBetButton.frame.size = CGSize(width: newBetButtonSize, height: newBetButtonSize)
        newBetButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        newBetButton.layer.shadowOpacity = Float(0.5)
        newBetButton.layer.shadowRadius = CGFloat(3)
        
        
        
        //Set Margins
        let screenTopMargin = CGFloat(115)
        let screenBottomMargin = CGFloat(10)
        
        let horizontalScrollViewHeight = screenHeight-screenTopMargin-screenBottomMargin
        let horizontalScrollViewWidth = screenWidth
        
        //Set the properties of scrollview
        horizontalScrollView.frame.origin = CGPoint(x: 0, y: screenTopMargin)
        horizontalScrollView.frame.size = CGSize(width: horizontalScrollViewWidth, height: horizontalScrollViewHeight)
        horizontalScrollView.contentSize = CGSize(width: screenWidth3, height: horizontalScrollViewHeight)
        horizontalScrollView.contentOffset = CGPoint(x: horizontalScrollViewWidth, y: 0)
        
        // Do any additional setup after loading the view.
        
        //Set size/positions of 3 table views
        let sideMargins = CGFloat(10)
        tableViewSize = CGSize(width: horizontalScrollViewWidth-(2*sideMargins), height: horizontalScrollViewHeight)
        profPicSize = CGFloat(tableViewSize.width/4)
        
        pendingTableView.frame.size = tableViewSize
        activeTableView.frame.size = tableViewSize
        completedTableView.frame.size = tableViewSize
        
        pendingTableView.frame.origin = CGPoint(x: sideMargins, y: 0)
        activeTableView.frame.origin = CGPoint(x: sideMargins+screenWidth, y: 0)
        completedTableView.frame.origin = CGPoint(x: sideMargins+(2*screenWidth), y: 0)
        
        
        //self.pendingTableView.reloadData()
        //self.activeTableView.reloadData()
        //self.completedTableView.reloadData()
        
        print("My bets view reloaded")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Determine the number of rows in each table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == self.pendingTableView{
            rowNum = pendingArray.count
        } else if tableView == self.activeTableView{
            rowNum = activeArray.count
        } else if tableView == self.completedTableView{
            rowNum = completedArray.count
        }
        
        return rowNum
    }
    
    
    //Build each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //temp crash fix
        let blankcell:UITableViewCell! = nil
        
        
        //for each of the 3 table views, define the cells
        // Set up cells for Pending table
        if tableView == self.pendingTableView {
            let cell = pendingTableView.dequeueReusableCell(withIdentifier: "pendingCell") as! PendingBetsTableViewCell
            let thisBet = pendingArray[indexPath.row]
            
            let margin = CGFloat(15)
            cell.frame.size.width = tableView.frame.width
            
            let fixWidthSize = CGSize(width: cell.frame.width-2*margin, height: CGFloat.greatestFiniteMagnitude)
            
            // Set up friend prof pic
            var friendProfPic: UIImage!
            for users in userArray {
                if users.username != thisUsername {
                    if users.username == thisBet.betSender || users.username == thisBet.betReceiver {
                        friendProfPic = users.profilePicture
                    }
                }
            }
            
            profPicSize = CGFloat(tableViewSize.width/4)
            cell.profPicImageView.image = friendProfPic
            cell.profPicImageView.frame = CGRect(x: margin, y: margin+5, width: profPicSize, height: profPicSize)
            cell.profPicImageView.layer.cornerRadius = profPicSize/2
            cell.profPicImageView.layer.masksToBounds = true
            cell.profPicImageView.layer.borderColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1).cgColor
            cell.profPicImageView.layer.borderWidth = 2

            
            cell.betSentLabel.text = String(thisBet.betSender + " sent " + thisBet.betReceiver + " a bet").uppercased()
            cell.betSentLabel.frame = CGRect(x: margin+profPicSize+margin, y: 0, width: cell.frame.width-3*margin-profPicSize, height: 18)
            cell.betSentLabel.center.y = margin+5+profPicSize/2
            cell.betSentLabel.textColor = UIColor(colorLiteralRed: 140/255, green: 140/255, blue: 140/255, alpha: 1)

            cell.whoBetsWhoLabel.text = thisBet.betSender + " bets " + thisBet.betReceiver + " that..."
            cell.whoBetsWhoLabel.frame = CGRect(x: margin, y: cell.profPicImageView.frame.maxY+margin, width: cell.frame.width-2*margin, height: 15)
            
            //pending label is the bet text
            cell.pendingLabel.text = thisBet.betText
            let pendingLabelFitSize = cell.pendingLabel.sizeThatFits(fixWidthSize)
            cell.pendingLabel.frame = CGRect(x: margin, y: cell.whoBetsWhoLabel.frame.maxY, width: cell.frame.width-2*margin, height: pendingLabelFitSize.height)
            
            let stakesBegnningText: String!
            if pendingArray[indexPath.row].winnerLoserToggle == true {
                 stakesBegnningText = "Winner gets to..."
            } else {
                stakesBegnningText = "Loser has to..."
            }
            
            cell.stakesLabel.text = stakesBegnningText
            cell.stakesLabel.frame = CGRect(x: margin, y: cell.pendingLabel.frame.maxY+10, width: cell.frame.width-2*margin, height: 15)
            
            cell.stakesInputLabel.text = thisBet.stakesText
            let stakesFitSize = cell.stakesInputLabel.sizeThatFits(fixWidthSize)
            cell.stakesInputLabel.frame = CGRect(x: margin, y: cell.stakesLabel.frame.maxY, width: cell.frame.width-2*margin, height: stakesFitSize.height)
            
            thisRowHeight = cell.stakesInputLabel.frame.maxY+margin
            self.pendingTableView.rowHeight = thisRowHeight
            cell.frame.size = CGSize(width: tableView.frame.width, height: thisRowHeight)
            
            

            cell.backgroundColor = UIColor.clear

            cell.whiteBackgroundView.frame = CGRect(x: 0, y: 5, width: cell.frame.width, height: cell.frame.height-10)
            cell.whiteBackgroundView.backgroundColor = UIColor.white
            cell.whiteBackgroundView.layer.cornerRadius = 10
            cell.whiteBackgroundView.layer.borderColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 1).cgColor
            cell.whiteBackgroundView.layer.borderWidth = 2
            
            
            return cell
            
        } else if tableView == self.activeTableView {
            let cell = activeTableView.dequeueReusableCell(withIdentifier: "activeCell") as! ActiveBetTableViewCell
            cell.layer.cornerRadius = 10
            let margin = CGFloat(10)
            profPicSize = CGFloat(tableViewSize.width/4)
            
            // TODO Update the time remaining based on the endDate field, or if this is nil say "Open Bet"
            cell.timeRemainingLabel.text = "1 Day Left"
            cell.timeRemainingLabel.frame.size = CGSize(width: tableViewSize.width-2*profPicSize-3*margin, height: 25)
            cell.timeRemainingLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.timeRemainingLabel.center.y = CGFloat(margin+profPicSize/2)
            
            
            cell.myProfPic.image = currentUser.profilePicture
            cell.myProfPic.frame = CGRect(x: margin, y: margin, width: profPicSize, height: profPicSize)
            cell.myProfPic.layer.cornerRadius = profPicSize/2
            cell.myProfPic.layer.masksToBounds = true
            
            var friendProfPicImage: UIImage!
            for users in userArray {
                if users.username != thisUsername {
                    if users.username == activeArray[indexPath.row].betSender || users.username == activeArray[indexPath.row].betReceiver {
                        friendProfPicImage = users.profilePicture
                    }
                }
            }
            cell.friendProfPic.image = friendProfPicImage
            cell.friendProfPic.frame = CGRect(x: tableViewSize.width-margin-profPicSize, y: margin, width: profPicSize, height: profPicSize)
            cell.friendProfPic.layer.cornerRadius = profPicSize/2
            cell.friendProfPic.layer.masksToBounds = true
            
            // TODO populate bet with correct text
            cell.betTextLabel.text = activeArray[indexPath.row].betSender + " bets that " + activeArray[indexPath.row].betText
            let fixWidthSize = CGSize(width: tableViewSize.width-2*margin, height: CGFloat.greatestFiniteMagnitude)
            let fitSizeBet = cell.betTextLabel.sizeThatFits(fixWidthSize)
            cell.betTextLabel.frame = CGRect(x: margin, y: profPicSize+2*margin, width: fitSizeBet.width, height: fitSizeBet.height)
            
            cell.stakesLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.stakesLabel.frame.origin.y = cell.betTextLabel.frame.origin.y+cell.betTextLabel.frame.height-5
            
            // TODO populate text with "Loser has to..." or "Winner has to..."
            let stakesBegnningText: String!
            if activeArray[indexPath.row].winnerLoserToggle == true {
                stakesBegnningText = "Winner gets to "
            } else {
                stakesBegnningText = "Loser has to "
            }
            
            cell.stakesTextLabel.text = stakesBegnningText + activeArray[indexPath.row].stakesText
            
            let fitSizeStakes = cell.stakesTextLabel.sizeThatFits(fixWidthSize)
            cell.stakesTextLabel.frame = CGRect(x: margin, y: cell.stakesLabel.frame.origin.y+cell.stakesLabel.frame.height+margin, width: fitSizeStakes.width, height: fitSizeStakes.height)
            
            thisRowHeight = cell.stakesTextLabel.frame.origin.y+cell.stakesTextLabel.frame.height+margin
            self.activeTableView.rowHeight = thisRowHeight
            cell.frame.size = CGSize(width: tableView.frame.width, height: thisRowHeight)
            
            
            cell.backgroundColor = UIColor.clear
            let whiteCellView: UIView = UIView(frame: CGRect(x: 0, y: 5, width: cell.frame.width , height: cell.frame.height-10))
            whiteCellView.backgroundColor = UIColor.white
            whiteCellView.layer.cornerRadius = 10
            whiteCellView.layer.borderColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 222/255).cgColor
            whiteCellView.layer.borderWidth = 2
            cell.addSubview(whiteCellView)
            cell.sendSubview(toBack: whiteCellView)
            
            return cell
        } else if tableView == self.completedTableView {
            let cell = completedTableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath) as! CompletedBetTableViewCell
            cell.layer.cornerRadius = 10
            
            profPicSize = CGFloat(tableViewSize.width/4)
            let margin = CGFloat(10)
            
            //TODO Update win/loss field based on who won the bet
            var winlossText =  String()
            if completedArray[indexPath.row].betState == 2 {
                if completedArray[indexPath.row].betSender == currentUser.username {
                    winlossText = "You won!"
                } else {
                    winlossText = "You lost!"
                }
            } else if completedArray[indexPath.row].betState == 3 {
                if completedArray[indexPath.row].betSender == currentUser.username {
                    winlossText = "You lost :("
                } else {
                    winlossText = "You won :)"
                }
                
            }
            
            cell.winLossLabel.text = winlossText
            
            
            cell.winLossLabel.frame.size = CGSize(width: tableViewSize.width-2*profPicSize-3*margin, height: 25)
            cell.winLossLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.winLossLabel.center.y = CGFloat(margin+profPicSize/2)
            
            cell.myProfPic.image = currentUser.profilePicture
            cell.myProfPic.frame = CGRect(x: margin, y: margin, width: profPicSize, height: profPicSize)
            cell.myProfPic.layer.cornerRadius = profPicSize/2
            cell.myProfPic.layer.masksToBounds = true
            
            let friendProfPic = getFriendProfPic(bet: completedArray[indexPath.row])
            cell.friendProfPic.image = friendProfPic
            cell.friendProfPic.frame = CGRect(x: tableViewSize.width-margin-profPicSize, y: margin, width: profPicSize, height: profPicSize)
            cell.friendProfPic.layer.cornerRadius = profPicSize/2
            cell.friendProfPic.layer.masksToBounds = true
            
            // TODO populate bet with correct text
            cell.betTextLabel.text = completedArray[indexPath.row].betSender + " bets that " + completedArray[indexPath.row].betText
            let fixWidthSize = CGSize(width: tableViewSize.width-2*margin, height: CGFloat.greatestFiniteMagnitude)
            let fitSizeBet = cell.betTextLabel.sizeThatFits(fixWidthSize)
            cell.betTextLabel.frame = CGRect(x: margin, y: profPicSize+2*margin, width: fitSizeBet.width, height: fitSizeBet.height)
            
            cell.stakesLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.stakesLabel.frame.origin.y = cell.betTextLabel.frame.origin.y+cell.betTextLabel.frame.height-5
            
            // TODO populate text with "Loser has to..." or "Winner has to..."
            let stakesBegnningText: String!
            if completedArray[indexPath.row].winnerLoserToggle == true {
                stakesBegnningText = "Winner gets to "
            } else {
                stakesBegnningText = "Loser has to "
            }
            
            
            cell.stakesTextLabel.text = stakesBegnningText + completedArray[indexPath.row].stakesText
            let fitSizeStakes = cell.stakesTextLabel.sizeThatFits(fixWidthSize)
            cell.stakesTextLabel.frame = CGRect(x: margin, y: cell.stakesLabel.frame.origin.y+cell.stakesLabel.frame.height+margin, width: fitSizeStakes.width, height: fitSizeStakes.height)
            
            cell.resultLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.resultLabel.frame.origin.y = cell.stakesTextLabel.frame.origin.y+cell.stakesTextLabel.frame.height+margin
            
            // TODO if image exists, display the image. If not, display "Add a pic!" button
            //if completedArray[indexPath.row].image == nil {
            
            
            //if (indexPath as NSIndexPath).row == 0 {
            //let image = UIImage(completedArray[indexPath.row].image!)
            //let imgData: NSData = UIImageJPEGRepresentation(image, 1)
            //let imgDataSize = imgData.length
            //print(imgDataSize)
            
            //let waterslideData: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "waterslide"))
            //let currentBetImage: NSData = UIImagePNGRepresentation(completedArray[indexPath.row].image)
            
            
            
            if completedArray[indexPath.row].image != nil {
                print("image exists")
                cell.addPhotoButton.isHidden = true
                cell.photoImage.isHidden = false
                let photoSize = CGFloat(tableViewSize.width-2*margin)
                let photoPosition = CGPoint(x: margin, y: cell.resultLabel.frame.origin.y+cell.resultLabel.frame.height+margin)
                cell.photoImage.frame = CGRect(x: photoPosition.x, y: photoPosition.y, width: photoSize, height: photoSize)
                cell.photoImage.layer.cornerRadius = 10
                cell.photoImage.layer.masksToBounds = true
                cell.photoImage.image = completedArray[indexPath.row].image
                
                //Set size of cell
                thisRowHeight = cell.photoImage.frame.origin.y+cell.photoImage.frame.height+margin
                self.completedTableView.rowHeight = thisRowHeight
                
                
            } else {
                cell.photoImage.isHidden = true
                cell.addPhotoButton.isHidden = false
                cell.addPhotoButton.center.x = CGFloat(tableViewSize.width/2)
                cell.addPhotoButton.frame.origin.y = cell.resultLabel.frame.origin.y+cell.resultLabel.frame.height+margin
                
                thisRowHeight = cell.addPhotoButton.frame.origin.y+cell.addPhotoButton.frame.height+margin
                self.completedTableView.rowHeight = thisRowHeight
            }
            
            cell.frame.size = CGSize(width: tableView.frame.width, height: thisRowHeight)
            
            
            cell.backgroundColor = UIColor.clear
            let whiteCellView: UIView = UIView(frame: CGRect(x: 0, y: 5, width: cell.frame.width , height: cell.frame.height-10))
            whiteCellView.backgroundColor = UIColor.white
            whiteCellView.layer.cornerRadius = 10
            whiteCellView.layer.borderColor = UIColor(colorLiteralRed: 222/255, green: 222/255, blue: 222/255, alpha: 222/255).cgColor
            whiteCellView.layer.borderWidth = 2
            cell.addSubview(whiteCellView)
            cell.sendSubview(toBack: whiteCellView)
            
            
            return cell
        } else {
            
            return blankcell
        }
        
        
        
        //return cell
        
    }
    
    
    //set up the segmented selector control and animation
    @IBAction func onSelectSegment(_ sender: AnyObject) {
        
        let index = sender.selectedSegmentIndex
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)
        let screenWidth2 = CGFloat(2*screenWidth)
        
        if index == 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.horizontalScrollView.contentOffset = CGPoint(x: 0, y: 0)
                }, completion: { (Bool) in
            })
            
        } else if index == 1 {
            UIView.animate(withDuration: 0.2, animations: {
                self.horizontalScrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
                }, completion: { (Bool) in
            })
            
        } else if index == 2 {
            UIView.animate(withDuration: 0.2, animations: {
                self.horizontalScrollView.contentOffset = CGPoint(x: screenWidth2, y: 0)
                }, completion: { (Bool) in
            })
            
        }
        
        
        
    }
    
    
    //on tapping a bet, send to bet details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = (indexPath as NSIndexPath).row
        segueIndicator = "cell"
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: "toDetails", sender: self)
        
    }
    
    // On tapping the new bet button, set the segue indicator
    @IBAction func onTapNewBetButton(_ sender: AnyObject) {
        
        segueIndicator = "newbet"
    }
    
    @IBAction func onTapSignOut(_ sender: AnyObject) {
        print("tapped sign out")
        segueIndicator = "sign-out"
        performSegue(withIdentifier: "logout2", sender: self)
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segueIndicator == "cell" {
            
            
            let betDetailsViewController = segue.destination as! BetDetailsViewController
            betDetailsViewController.view.layoutIfNeeded()
            
            
            // Set status, prof pics, bet text, stakes, etc. in destination
            if segmentedControl.selectedSegmentIndex == 1 {
                
                let tappedBet = activeArray[selectedCell]
                betDetailsViewController.statusLabel.text = "Active"
                betDetailsViewController.closeBetButton.isHidden = false
                betDetailsViewController.statusLabel.textColor = UIColor.blue
  
                //set bet text, size it, and set/size stakes text
                
                populateBetDetailsView(tappedBet: tappedBet, betDetailsViewController: betDetailsViewController)
                layoutBetDetailsView(betDetailsViewController)
                
                
                betDetailsViewController.thisBetIndex = selectedCell
                betDetailsViewController.currentBet = tappedBet

                
            } else if segmentedControl.selectedSegmentIndex == 0 {
                betDetailsViewController.statusLabel.text = "Pending"
                betDetailsViewController.statusLabel.textColor = UIColor.orange
                
                
                
                
                
                let tappedBet = pendingArray[selectedCell]
                populateBetDetailsView(tappedBet: tappedBet, betDetailsViewController: betDetailsViewController)
                layoutBetDetailsView(betDetailsViewController)
                
                if currentUser.username == tappedBet.betSender {
                    betDetailsViewController.cancelBetButton.isHidden = false
                } else {
                    betDetailsViewController.acceptButton.isHidden = false
                    betDetailsViewController.rejectButton.isHidden = false
                }
                
                
                betDetailsViewController.currentBet = tappedBet
                betDetailsViewController.thisBetIndex = selectedCell

                
            } else if segmentedControl.selectedSegmentIndex == 2 {
                betDetailsViewController.statusLabel.text = "Completed"
                betDetailsViewController.statusLabel.textColor = UIColor.green
                
                
                let tappedBet = completedArray[selectedCell]
                populateBetDetailsView(tappedBet: tappedBet, betDetailsViewController: betDetailsViewController)
                
                // TODO if there is an image, display it, otherwise display "add Photo" (or just always display add/change photo?)
                betDetailsViewController.addPhotoButton.isHidden = false
                
                layoutBetDetailsView(betDetailsViewController)
                
                betDetailsViewController.thisBetIndex = selectedCell
                betDetailsViewController.currentBet = tappedBet

                
            }
            
            
            betDetailsViewController.thisUsername = thisUsername
            //betDetailsViewController.userArray = userArray
            betDetailsViewController.currentUser = currentUser
            
            
        } else if segueIndicator == "newbet" {
            let newBetViewController = segue.destination as! NewBetViewController
            newBetViewController.totalBets = totalBets
            newBetViewController.currentUser = currentUser
            //just need to pass user info?
            
        } else {
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    // Set the prof pics, bet text, winner/loser, stakes text
    // TODO set the created date, ending date
    func populateBetDetailsView(tappedBet : BetStruct, betDetailsViewController : BetDetailsViewController) -> Void {
        
        betDetailsViewController.betTextLabel.text = tappedBet.betSender + " bets that " + tappedBet.betText
        let stakesBeginningText = getWinnerLoserText(isWinnerLoser: tappedBet.winnerLoserToggle)
        betDetailsViewController.stakesTextLabel.text = stakesBeginningText + tappedBet.stakesText
        betDetailsViewController.friendProfPic.image = getFriendProfPic(bet: tappedBet)
        betDetailsViewController.myProfPic.image = currentUser.profilePicture
    }
    
    func layoutBetDetailsView(_ betDetailsViewController: BetDetailsViewController) -> Void {
        
        let fixWidthSize = CGSize(width: betDetailsViewController.detailsScrollView.frame.width-20, height: CGFloat.greatestFiniteMagnitude)
        let fitSizeBet = betDetailsViewController.betTextLabel.sizeThatFits(fixWidthSize)
        betDetailsViewController.betTextLabel.frame.size = fitSizeBet
        betDetailsViewController.stakesLabel.frame.origin.y = betDetailsViewController.betTextLabel.frame.height+10
        betDetailsViewController.stakesTextLabel.frame.origin.y = betDetailsViewController.stakesLabel.frame.origin.y + betDetailsViewController.stakesLabel.frame.height + 10
        let fitSizeStakes = betDetailsViewController.stakesTextLabel.sizeThatFits(fixWidthSize)
        betDetailsViewController.stakesTextLabel.frame.size = fitSizeStakes
        let stakesBottom = CGFloat(betDetailsViewController.stakesTextLabel.frame.maxY)
        betDetailsViewController.createdLabel.frame.origin.y = stakesBottom + 20
        betDetailsViewController.endLabel.frame.origin.y = stakesBottom + 20
        let createdLabelBottom = CGFloat(betDetailsViewController.createdLabel.frame.maxY)
        betDetailsViewController.createdDateLabel.frame.origin.y = createdLabelBottom
        betDetailsViewController.endDateLabel.frame.origin.y = createdLabelBottom
        
        let betViewHeight = betDetailsViewController.endDateLabel.frame.maxY+20
        betDetailsViewController.betDetailsView.frame.size.height = betViewHeight
        
        // IF the full bet details view is smaller than the initial scrollview, shrink it
        if betViewHeight < betDetailsViewController.detailsScrollView.frame.size.height {
            betDetailsViewController.detailsScrollView.frame.size.height = betViewHeight
        }
        betDetailsViewController.detailsScrollView.contentSize.height = betViewHeight
        
    }
    
    
    
    
    func buildBetArrays(betArray : [BetStruct]) -> Void {
        
        for bet in betArray {
            
            if bet.betState == 0 {
                pendingArray.append(bet)
            } else if bet.betState == 1 {
                activeArray.append(bet)
            } else if bet.betState == 2 || bet.betState == 3 {
                completedArray.append(bet)
            }
        }
        print("built bet arrays: pendings - \(pendingArray.count), actives - \(activeArray.count), completed - \(completedArray.count)")
        
    }
    
    
    func getWinnerLoserText(isWinnerLoser: Bool) -> String {
        let stakesBeginningText: String!
        if isWinnerLoser == true {
            stakesBeginningText = "Winner gets to "
        } else {
            stakesBeginningText = "Loser has to "
        }
        return stakesBeginningText
    }
    
    func getFriendProfPic(bet: BetStruct) -> UIImage {
        var friendProfPic: UIImage!
        for users in userArray {
            if users.username != thisUsername {
                if users.username == bet.betSender || users.username == bet.betReceiver {
                    friendProfPic = users.profilePicture
                    break
                }
            }
        }
        return friendProfPic
    }
    
    //TODO get users from firebase. Eventually this would only get friends
    func getAllUserData() -> [UserStruct] {
        let user0 = UserStruct(username: "Cam", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "headshot"))
        let user1 = UserStruct(username: "Adey", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "adey-headshot"))
        let user2 = UserStruct(username: "Ravi", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "nopic-headshot"))
        let user3 = UserStruct(username: "Dani", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "dani-headshot"))
        let user4 = UserStruct(username: "Bex", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "bex-headshot"))
        let user5 = UserStruct(username: "Zach", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "zach-headshot"))
        let user6 = UserStruct(username: "Vic", password: "a", email: "camkhill@gmail.com", profilePicture: #imageLiteral(resourceName: "vic-headshot"))
        
        let usersArray = [user0,user1,user2,user3,user4,user5,user6]
        return usersArray
        
    }
    
    //Take all firebase bets and only get bets for the current user
    func getUsersBets(username : String, firebaseBets: [BetStruct]) -> [BetStruct] {
        
        var usersBets = [BetStruct]()
        
        // Go through all bets and get all ones where user is sender or receiver
        for bet in firebaseBets {
            if bet.betSender == username || bet.betReceiver == username {
                usersBets.append(bet)
            }
        }
        
        print("Got all bets for this user, total bets: \(usersBets.count)")
        //return firebaseBets
        return usersBets
        
    }
    
    func getFirebaseBets() {
        
        print("getting firebase bets")
        let waterslideImage = #imageLiteral(resourceName: "waterslide")
        var newBetStruct = [BetStruct]()
        
        betsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("firebase snapshot acquired")
            self.totalBets = Int(snapshot.childrenCount)
            print("total bets: \(self.totalBets)")
            
            let betSnapshot = snapshot.value as? NSDictionary
            var betSnapshotArray = NSArray()
            var isDictionary = true
            var imageDictionary = [String: UIImage]()
            
            if betSnapshot == nil {
                betSnapshotArray = (snapshot.value as? NSArray)!
                isDictionary = false
                print("not a dictionary")
            }
            
            // Need to get user bets first here so not downloading all images
            
            
            for betCount in 1...self.totalBets {
                
                print("iterating through bets, currently on: \(betCount)")
                let countString = String(betCount)
                var image: UIImage? = nil
                
                
                self.storageRef.child(countString).data(withMaxSize: 1024*1024, completion: { (data, error) in
                    if error != nil {
                        // Leave image as nil if there is no image there
                        print("No image for this bet: \(betCount)")

                    } else {
                        print("downloaded image for this bet: \(betCount)")
                        image = UIImage(data: data!)!
                        imageDictionary.updateValue(image!, forKey: countString)

                    }
                    
                    //After going through all of them, build the final bet array
                    
                    if betCount == self.totalBets {

                        print("bet count is the same as total bets (should be once)")
                        print("full image dictionary count: \(imageDictionary.count)")
                        // Go through the whole thing again, and add bet info with images
                        for betCount in 1...self.totalBets {
                            if isDictionary == true {
                                
                                // If this starts being a dictionary, will need some changes here
                                let thisBet = betSnapshot?[countString] as? NSDictionary as! [String : String]
                                
                                let thisBetStruct = BetStruct(betID: betCount, betText: thisBet["betText"] , betSender: thisBet["betSender"], betReceiver: thisBet["betReceiver"], winnerLoserToggle: true, stakesText: thisBet["stakesText"], endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 10000), betState: Int(thisBet["betState"]!), image: waterslideImage, lastModified: Date(timeIntervalSinceReferenceDate: 10000))
                                
                                newBetStruct.append(thisBetStruct)
                            } else {
                                
                                let thisBet = betSnapshotArray[betCount] as! NSDictionary //as? NSDictionary as! [String: String]
                                var winnerLoserToggleBool = Bool()
                                
                                let betReceiver = thisBet["betReceiver"] as? String
                                let betSender = thisBet["betSender"] as? String
                                let betText = thisBet["betText"] as? String
                                let stakesText = thisBet["stakesText"] as? String
                                let betState = thisBet["betState"] as? String
                                let betStateInt = Int(betState!)
                                let winnerLoserString = thisBet["winnerLoserToggle"] as? String
                                if winnerLoserString == "Loser" {
                                    winnerLoserToggleBool = false
                                } else {
                                    winnerLoserToggleBool = true
                                }
                                
                                let image = imageDictionary[String(betCount)]
                                
                                let thisBetStruct = BetStruct(betID: betCount, betText: betText, betSender: betSender, betReceiver: betReceiver, winnerLoserToggle: winnerLoserToggleBool, stakesText: stakesText, endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 10000), betState: betStateInt, image: image, lastModified: Date(timeIntervalSinceReferenceDate: 10000))
                                
                                
                                newBetStruct.append(thisBetStruct)
                                print("bet appended with id: \(betCount)")
                                
                                if betCount == self.totalBets {
                                    //Use this newBetStruct to get users bets
                                    
                                    let userBets = self.getUsersBets(username: self.currentUser.username, firebaseBets: newBetStruct)
                                    self.buildBetArrays(betArray: userBets)
                                    
                                    
                                    self.pendingTableView.reloadData()
                                    self.completedTableView.reloadData()
                                    self.activeTableView.reloadData()
                                    print("reloaded all table views")
                                }
                                
                            }
                            
                        }
                    }
                    
                    
                })
                
            }
        })
        
    }
    
}
