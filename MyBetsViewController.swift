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

class MyBetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pendingTableView: UITableView!
    @IBOutlet weak var activeTableView: UITableView!
    @IBOutlet weak var completedTableView: UITableView!
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var newBetButton: UIButton!
    
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

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Firebase reference for users and bets
        usersRef = FIRDatabase.database().reference().child("Users")
        betsRef = FIRDatabase.database().reference().child("Bets")
        
        /////////// prepare the bets ////////////
        // Get all bets for the particular user
        
        
        betArray = getUsersBets(username: currentUser.username)
        //Separate them into pending, active, completed bets
        buildBetArrays(betArray: betArray)
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

        
        //Set segmentedControl state, location
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.center = CGPoint(x: view.center.x, y: 90)
        
        //Set Up New Bet button
        newBetButton.frame.origin = CGPoint(x: screenWidth-(screenWidth/4), y: screenHeight-(screenWidth/4))
        let newBetButtonSize = CGFloat(screenWidth/6)
        
        newBetButton.frame.size = CGSize(width: newBetButtonSize, height: newBetButtonSize)
        
        
        
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
        profPicSize = CGFloat(tableViewSize.width/5)
        
        pendingTableView.frame.size = tableViewSize
        activeTableView.frame.size = tableViewSize
        completedTableView.frame.size = tableViewSize
        
        pendingTableView.frame.origin = CGPoint(x: sideMargins, y: 0)
        activeTableView.frame.origin = CGPoint(x: sideMargins+screenWidth, y: 0)
        completedTableView.frame.origin = CGPoint(x: sideMargins+(2*screenWidth), y: 0)
        
        
        self.pendingTableView.reloadData()
        self.activeTableView.reloadData()
        self.completedTableView.reloadData()
        
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
            let margin = CGFloat(10)
            cell.pendingLabel.text = pendingArray[indexPath.row].betSender + " bets that " + pendingArray[indexPath.row].betText
            cell.layer.cornerRadius = 10
            
            
            
            //// Position elements within pending cell
            profPicSize = CGFloat(tableViewSize.width/5)
            
            // get prof pic - if the username = sender name & username is not this username
            var friendProfPic: UIImage!
            for users in userArray {
                if users.username != thisUsername {
                    if users.username == pendingArray[indexPath.row].betSender || users.username == pendingArray[indexPath.row].betReceiver {
                        friendProfPic = users.profilePicture
                    }
                }
            }
            
            cell.profPicImageView.image = friendProfPic
            cell.profPicImageView.frame = CGRect(x: margin, y: margin, width: profPicSize, height: profPicSize)
            cell.profPicImageView.layer.cornerRadius = profPicSize/2
            cell.profPicImageView.layer.masksToBounds = true
            cell.pendingLabel.frame = CGRect(x: profPicSize+2*margin, y: margin, width: tableViewSize.width-profPicSize-3*margin, height: profPicSize)
            cell.stakesLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.stakesLabel.frame.origin.y = profPicSize
            
            let stakesBegnningText: String!
            if pendingArray[indexPath.row].winnerLoserToggle == true {
                 stakesBegnningText = "Winner gets "
            } else {
                stakesBegnningText = "Loser has to "
            }
            
            cell.stakesInputLabel.text = stakesBegnningText + pendingArray[indexPath.row].stakesText
            
            
            let fixWidthSize = CGSize(width: tableViewSize.width-2*margin, height: CGFloat.greatestFiniteMagnitude)
            let fitSize = cell.stakesInputLabel.sizeThatFits(fixWidthSize)
            cell.stakesInputLabel.frame = CGRect(x: margin, y: profPicSize+cell.stakesLabel.frame.height, width: tableViewSize.width-2*margin, height: fitSize.height)
            
            thisRowHeight = cell.stakesInputLabel.frame.origin.y+cell.stakesInputLabel.frame.height+margin
            self.pendingTableView.rowHeight = thisRowHeight
            
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
                stakesBegnningText = "Winner gets "
            } else {
                stakesBegnningText = "Loser has to "
            }
            
            cell.stakesTextLabel.text = stakesBegnningText + activeArray[indexPath.row].stakesText
            
            let fitSizeStakes = cell.stakesTextLabel.sizeThatFits(fixWidthSize)
            cell.stakesTextLabel.frame = CGRect(x: margin, y: cell.stakesLabel.frame.origin.y+cell.stakesLabel.frame.height+margin, width: fitSizeStakes.width, height: fitSizeStakes.height)
            
            thisRowHeight = cell.stakesTextLabel.frame.origin.y+cell.stakesTextLabel.frame.height+margin
            self.activeTableView.rowHeight = thisRowHeight
            
            return cell
        } else if tableView == self.completedTableView {
            let cell = completedTableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath) as! CompletedBetTableViewCell
            cell.layer.cornerRadius = 10
            
            profPicSize = CGFloat(tableViewSize.width/4)
            let margin = CGFloat(10)
            
            //TODO Update win/loss field based on who won the bet
            let winlossText: String!
            if completedArray[indexPath.row].betState == 2 {
                if completedArray[indexPath.row].betSender == thisUsername {
                    winlossText = "You won!"
                } else {
                    winlossText = "You lost!"
                }
            } else {
                if completedArray[indexPath.row].betSender == thisUsername {
                    winlossText = "You lost :("
                } else {
                    winlossText = "You won :)"
                }
                
            }
            
            cell.winLossLabel.text = winlossText
            
            
            cell.winLossLabel.frame.size = CGSize(width: tableViewSize.width-2*profPicSize-3*margin, height: 25)
            cell.winLossLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.winLossLabel.center.y = CGFloat(margin+profPicSize/2)
            
            // TODO update my profilepic to have correct image
            cell.myProfPic.image = UIImage(named: "headshot")
            cell.myProfPic.frame = CGRect(x: margin, y: margin, width: profPicSize, height: profPicSize)
            cell.myProfPic.layer.cornerRadius = profPicSize/2
            cell.myProfPic.layer.masksToBounds = true
            
            // TODO update friend prof pic with image
            cell.friendProfPic.image = UIImage(named: "profpic")
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
                stakesBegnningText = "Winner gets "
            } else {
                stakesBegnningText = "Loser has to "
            }
            
            
            cell.stakesTextLabel.text = stakesBegnningText + completedArray[indexPath.row].stakesText
            let fitSizeStakes = cell.stakesTextLabel.sizeThatFits(fixWidthSize)
            cell.stakesTextLabel.frame = CGRect(x: margin, y: cell.stakesLabel.frame.origin.y+cell.stakesLabel.frame.height+margin, width: fitSizeStakes.width, height: fitSizeStakes.height)
            
            cell.resultLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.resultLabel.frame.origin.y = cell.stakesTextLabel.frame.origin.y+cell.stakesTextLabel.frame.height+margin
            
            // TODO if image exists, display the image. If not, display "Add a pic!" button
            if (indexPath as NSIndexPath).row == 0 {
                cell.addPhotoButton.isHidden = true
                cell.photoImage.isHidden = false
                let photoSize = CGFloat(tableViewSize.width-2*margin)
                let photoPosition = CGPoint(x: margin, y: cell.resultLabel.frame.origin.y+cell.resultLabel.frame.height+margin)
                cell.photoImage.frame = CGRect(x: photoPosition.x, y: photoPosition.y, width: photoSize, height: photoSize)
                cell.photoImage.layer.cornerRadius = 10
                cell.photoImage.layer.masksToBounds = true
                cell.photoImage.image = UIImage(named: "waterslide")
                
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
            
            
            return cell
        } else {
            
            print("hit the else")
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
                betDetailsViewController.acceptButton.isHidden = false
                betDetailsViewController.rejectButton.isHidden = false
                
                let tappedBet = pendingArray[selectedCell]
                populateBetDetailsView(tappedBet: tappedBet, betDetailsViewController: betDetailsViewController)
                layoutBetDetailsView(betDetailsViewController)
                
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
            //just need to pass user info?
            
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
            } else {
                completedArray.append(bet)
                
            }
        }
    }
    
    
    func getWinnerLoserText(isWinnerLoser: Bool) -> String {
        let stakesBeginningText: String!
        if isWinnerLoser == true {
            stakesBeginningText = "Winner gets "
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
        
        let usersArray = [user0,user1,user2,user3,user4,user5]
        return usersArray
        
    }
    
    //TODO delete this eventually
    func getUsersBets(username : String) -> [BetStruct] {
        
        
        //Get all bets
        
        
        let emptyImage: UIImage! = nil
        let waterslideImage = #imageLiteral(resourceName: "waterslide")
        
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
 
        //Get all the bets from firebase
        let allBets : [BetStruct] = [bet0,bet1,bet2,bet3,bet4,bet5,bet6,bet7,bet8,bet9,bet10,bet11,bet12,bet13]
        
        /*let newBetsRef = self.betsRef.child("1")
        
        //newBetsRef.setValue(betDictionary)
        //let allFIRBets = item as! FIRDataSnapshot
        var tempIDsList = [String]()
        
        // For each bet in the database, look at the name of the bet (a number). For each of these, if it exists set all values to values in a BetStruct and append this BetStruct to a [BetStruct] IF sender or receiver match username
        var newBetStruct = [BetStruct]()
        var betsExist: Bool = true
        var testBetDictionary = [String:String]()
        var totalBets = Int()
        
        // Get total number of bets
        betsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            totalBets = Int(snapshot.childrenCount)
            print("total bets: \(totalBets)")
            
            print(snapshot)
            let betSnapshot = snapshot.value as? NSDictionary
            var betSnapshotArray = NSArray()
            var isDictionary = true
            
            if betSnapshot == nil {
                betSnapshotArray = (snapshot.value as? NSArray)!
                isDictionary = false
            }
                
            print("bet snapshot: \(betSnapshot)")
            print("bet array: \(betSnapshotArray)")
            
            print("Is it a dictionary? \(isDictionary)")
            
            for betCount in 1...2 {
                let countString = String(betCount)
                
                if isDictionary == true {
                    let thisBet = betSnapshot?[countString] as? NSDictionary as! [String : String]
                    print(thisBet)
                    
                    let thisBetStruct = BetStruct(betID: betCount, betText: thisBet["betText"] , betSender: thisBet["betSender"], betReceiver: thisBet["betReceiver"], winnerLoserToggle: true, stakesText: thisBet["stakesText"], endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 10000), betState: 0, image: waterslideImage, lastModified: Date(timeIntervalSinceReferenceDate: 10000))
                    
                    newBetStruct.append(thisBetStruct)
                } else {
                    
                    let thisBet = betSnapshotArray[betCount] as! NSDictionary //as? NSDictionary as! [String: String]
                    print(thisBet["betReceiver"])
                    
                    let betReceiver = thisBet["betReceiver"] as? String
                    let betSender = thisBet["betSender"] as? String
                    let betText = thisBet["betText"] as? String
                    let stakesText = thisBet["stakesText"] as? String
                    
                    let thisBetStruct = BetStruct(betID: betCount, betText: betText, betSender: betSender, betReceiver: betReceiver, winnerLoserToggle: true, stakesText: stakesText, endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 10000), betState: 0, image: waterslideImage, lastModified: Date(timeIntervalSinceReferenceDate: 10000))
                    
                    
                    newBetStruct.append(thisBetStruct)
                    
                }
                
                print("bet count: \(betCount)")
            }
            print("bet struct: \(newBetStruct)")
            
        })*/
        
        
        
        
        var usersBets = [BetStruct]()
        
        // Go through all bets and get all ones where user is sender or receiver
        for bet in allBets {
            if bet.betSender == username || bet.betReceiver == username {
                usersBets.append(bet)
            }
        }
        
        //return newBetStruct
        return usersBets
        
    }
    
    func getFirebaseBets() {
        
        let waterslideImage = #imageLiteral(resourceName: "waterslide")
        var newBetStruct = [BetStruct]()
        var totalBets = Int()
        
        betsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            totalBets = Int(snapshot.childrenCount)
            print("total bets: \(totalBets)")
            
            print(snapshot)
            let betSnapshot = snapshot.value as? NSDictionary
            var betSnapshotArray = NSArray()
            var isDictionary = true
            
            if betSnapshot == nil {
                betSnapshotArray = (snapshot.value as? NSArray)!
                isDictionary = false
            }
            
            print("bet snapshot: \(betSnapshot)")
            print("bet array: \(betSnapshotArray)")
            
            print("Is it a dictionary? \(isDictionary)")
            
            for betCount in 1...2 {
                let countString = String(betCount)
                
                if isDictionary == true {
                    let thisBet = betSnapshot?[countString] as? NSDictionary as! [String : String]
                    print(thisBet)
                    
                    let thisBetStruct = BetStruct(betID: betCount, betText: thisBet["betText"] , betSender: thisBet["betSender"], betReceiver: thisBet["betReceiver"], winnerLoserToggle: true, stakesText: thisBet["stakesText"], endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 10000), betState: 0, image: waterslideImage, lastModified: Date(timeIntervalSinceReferenceDate: 10000))
                    
                    newBetStruct.append(thisBetStruct)
                } else {
                    
                    let thisBet = betSnapshotArray[betCount] as! NSDictionary //as? NSDictionary as! [String: String]
                    print(thisBet["betReceiver"])
                    
                    let betReceiver = thisBet["betReceiver"] as? String
                    let betSender = thisBet["betSender"] as? String
                    let betText = thisBet["betText"] as? String
                    let stakesText = thisBet["stakesText"] as? String
                    
                    let thisBetStruct = BetStruct(betID: betCount, betText: betText, betSender: betSender, betReceiver: betReceiver, winnerLoserToggle: true, stakesText: stakesText, endDate: Date(timeIntervalSinceReferenceDate: 10000), creationDate: Date(timeIntervalSinceReferenceDate: 10000), betState: 0, image: waterslideImage, lastModified: Date(timeIntervalSinceReferenceDate: 10000))
                    
                    
                    newBetStruct.append(thisBetStruct)
                    
                }
                
                print("bet count: \(betCount)")
            }
            print("bet struct: \(newBetStruct)")
            
            //Use this newBetStruct to get users bets
            let userBets = self.getUsersBets(username: self.currentUser.username)
            self.buildBetArrays(betArray: userBets)
            
        })
        
    }
    
}
