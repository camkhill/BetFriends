//
//  MyBetsViewController.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/19/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /////////// prepare the bets ////////////
        buildBetArrays()
        
        
        
        
        
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
                betDetailsViewController.betTextLabel.text = tappedBet.betSender + " bets that " + tappedBet.betText
                let fixWidthSize = CGSize(width: betDetailsViewController.detailsScrollView.frame.width-20, height: CGFloat.greatestFiniteMagnitude)
                let fitSizeBet = betDetailsViewController.betTextLabel.sizeThatFits(fixWidthSize)
                betDetailsViewController.betTextLabel.frame.size = fitSizeBet
                
                betDetailsViewController.stakesLabel.frame.origin.y = betDetailsViewController.betTextLabel.frame.height+10
                
                betDetailsViewController.stakesTextLabel.frame.origin.y = betDetailsViewController.stakesLabel.frame.origin.y + betDetailsViewController.stakesLabel.frame.height + 10
                
                let stakesBeginningText = getWinnerLoserText(isWinnerLoser: tappedBet.winnerLoserToggle)//winnerLoser!)
                betDetailsViewController.stakesTextLabel.text = stakesBeginningText + tappedBet.stakesText
                
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
                
                betDetailsViewController.myProfPic.image = currentUser.profilePicture
                betDetailsViewController.friendProfPic.image = getFriendProfPic(bet: tappedBet)
                
                if betViewHeight < betDetailsViewController.detailsScrollView.frame.size.height {
                    betDetailsViewController.detailsScrollView.frame.size.height = betViewHeight
                    //shrink the content, or also disable scrolling?
                    betDetailsViewController.detailsScrollView.contentSize.height = betViewHeight
                }
                
                betDetailsViewController.thisBetIndex = selectedCell
                betDetailsViewController.activeArray = activeArray
                betDetailsViewController.pendingArray = pendingArray
                betDetailsViewController.completedArray = completedArray
                
                
            } else if segmentedControl.selectedSegmentIndex == 0 {
                betDetailsViewController.statusLabel.text = "Pending"
                betDetailsViewController.statusLabel.textColor = UIColor.orange
                betDetailsViewController.acceptButton.isHidden = false
                betDetailsViewController.rejectButton.isHidden = false
                
                let tappedBet = pendingArray[selectedCell]
                betDetailsViewController.betTextLabel.text = tappedBet.betSender + " bets that " + tappedBet.betText
                let stakesBeginningText = getWinnerLoserText(isWinnerLoser: tappedBet.winnerLoserToggle)
                betDetailsViewController.stakesTextLabel.text = stakesBeginningText + tappedBet.stakesText
                betDetailsViewController.friendProfPic.image = getFriendProfPic(bet: tappedBet)
                betDetailsViewController.myProfPic.image = currentUser.profilePicture
                
                layoutBetDetailsView(betDetailsViewController)
                
                betDetailsViewController.thisBetIndex = selectedCell
                betDetailsViewController.activeArray = activeArray
                betDetailsViewController.pendingArray = pendingArray
                betDetailsViewController.completedArray = completedArray
                
            } else if segmentedControl.selectedSegmentIndex == 2 {
                betDetailsViewController.statusLabel.text = "Completed"
                betDetailsViewController.statusLabel.textColor = UIColor.green
                
                let tappedBet = completedArray[selectedCell]
                betDetailsViewController.betTextLabel.text = tappedBet.betSender + " bets that" + tappedBet.betText
                let stakesBeginningText = getWinnerLoserText(isWinnerLoser: tappedBet.winnerLoserToggle)
                betDetailsViewController.stakesTextLabel.text = stakesBeginningText + tappedBet.stakesText
                betDetailsViewController.friendProfPic.image = getFriendProfPic(bet: tappedBet)
                betDetailsViewController.myProfPic.image = currentUser.profilePicture
                
                // TODO if there is an image, display it, otherwise display "add Photo" (or just always display add/change photo?)
                betDetailsViewController.addPhotoButton.isHidden = false
                
                layoutBetDetailsView(betDetailsViewController)
                
                betDetailsViewController.thisBetIndex = selectedCell
                betDetailsViewController.activeArray = activeArray
                betDetailsViewController.pendingArray = pendingArray
                betDetailsViewController.completedArray = completedArray
                
            }
            
            betDetailsViewController.thisUsername = thisUsername
            betDetailsViewController.userArray = userArray
            betDetailsViewController.currentUser = currentUser
            
            
        } else if segueIndicator == "newbet" {
            let newBetViewController = segue.destination as! NewBetViewController
            //just need to pass user info?
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
    
    
    func buildBetArrays() -> Void {
        
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
    
    
}
