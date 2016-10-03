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
    
    let testBetText: [String] = ["Short bet","Medium sized bet Medium sized bet Medium sized bet Medium sized bet","Here is a very long bet with lots of text Here is a very long bet with lots of text Here is a very long bet with lots of text Here is a very long bet with lots of text","short bet","short bet"]
    let testStakesText: [String] = ["Short Stakes","Medium sized Stakes Medium sized bet Medium sized bet Medium sized bet","Here is a very long stakes with lots of text Here is a very long bet with lots of text Here is a very long bet with lots of text Here is a very long bet with lots of text Here is a very long bet with lots of text Here is a very long bet with lots of text","short bet","The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time The biggest stakse of all time"]
    
    //let betArray = [BetStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pendingTableView.delegate = self
        pendingTableView.dataSource = self
        activeTableView.delegate = self
        activeTableView.dataSource = self
        completedTableView.delegate = self
        completedTableView.dataSource = self
        
        
        //Determine screen size
        let screenWidth = CGFloat(UIScreen.mainScreen().bounds.size.width)
        let screenWidth3 = CGFloat(3 * UIScreen.mainScreen().bounds.size.width)
        let screenHeight = CGFloat(UIScreen.mainScreen().bounds.size.height)
        
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
        //print(tableViewSize)
        
        pendingTableView.frame.size = tableViewSize
        activeTableView.frame.size = tableViewSize
        completedTableView.frame.size = tableViewSize
        
        pendingTableView.frame.origin = CGPoint(x: sideMargins, y: 0)
        activeTableView.frame.origin = CGPoint(x: sideMargins+screenWidth, y: 0)
        completedTableView.frame.origin = CGPoint(x: sideMargins+(2*screenWidth), y: 0)
        
        
        self.pendingTableView.reloadData()
        self.activeTableView.reloadData()
        self.completedTableView.reloadData()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Required TableView functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //initialize cell based on pending/active/completed type
        //var pendingCell:PendingBetsTableViewCell?
        //var activeCell:ActiveBetTableViewCell?
        //var completedCell:CompletedBetTableViewCell?
        //var cell:UITableViewCell?
        
        //temp crash fix
        let blankcell:UITableViewCell! = nil
        //let cell = pendingTableView.dequeueReusableCellWithIdentifier("pendingCell") as! PendingBetsTableViewCell
        
        //cell.pendingLabel.text = "pending..."
        
        //for each of the 3 table views, define the cells
        
        // Set up cells for Pending table
        if tableView == self.pendingTableView {
            let cell = pendingTableView.dequeueReusableCellWithIdentifier("pendingCell") as! PendingBetsTableViewCell
            let margin = CGFloat(10)
            cell.pendingLabel.text = testBetText[indexPath.row]
            cell.layer.cornerRadius = 10
            
            //// Position elements within pending cell
            profPicSize = CGFloat(tableViewSize.width/5)
            cell.profPicImageView.frame = CGRect(x: margin, y: margin, width: profPicSize, height: profPicSize)
            cell.profPicImageView.layer.cornerRadius = profPicSize/2
            cell.profPicImageView.layer.masksToBounds = true
            cell.pendingLabel.frame = CGRect(x: profPicSize+2*margin, y: margin, width: tableViewSize.width-profPicSize-3*margin, height: profPicSize)
            cell.stakesLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.stakesLabel.frame.origin.y = profPicSize

            cell.stakesInputLabel.text = testStakesText[indexPath.row]
            let fixWidthSize = CGSize(width: tableViewSize.width-2*margin, height: CGFloat.max)
            let fitSize = cell.stakesInputLabel.sizeThatFits(fixWidthSize)
            cell.stakesInputLabel.frame = CGRect(x: margin, y: profPicSize+cell.stakesLabel.frame.height, width: tableViewSize.width-2*margin, height: fitSize.height)
            
            thisRowHeight = cell.stakesInputLabel.frame.origin.y+cell.stakesInputLabel.frame.height+margin
            self.pendingTableView.rowHeight = thisRowHeight
            
            return cell
        } else if tableView == self.activeTableView {
            let cell = activeTableView.dequeueReusableCellWithIdentifier("activeCell") as! ActiveBetTableViewCell
            cell.layer.cornerRadius = 10
            let margin = CGFloat(10)
            profPicSize = CGFloat(tableViewSize.width/4)
            
            // TODO Update the time remaining based on the endDate field, or if this is nil say "Open Bet"
            cell.timeRemainingLabel.text = "1 Day Left"
            cell.timeRemainingLabel.frame.size = CGSize(width: tableViewSize.width-2*profPicSize-3*margin, height: 25)
            cell.timeRemainingLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.timeRemainingLabel.center.y = CGFloat(margin+profPicSize/2)
            
            
            // TODO update my profile pic to have the correct image
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
            cell.betTextLabel.text = "You bet that here is the bet text, what a crazy bet this is. No one would have ever guessed what this bet would be!"
            let fixWidthSize = CGSize(width: tableViewSize.width-2*margin, height: CGFloat.max)
            let fitSizeBet = cell.betTextLabel.sizeThatFits(fixWidthSize)
            cell.betTextLabel.frame = CGRect(x: margin, y: profPicSize+2*margin, width: fitSizeBet.width, height: fitSizeBet.height)
            
            cell.stakesLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.stakesLabel.frame.origin.y = cell.betTextLabel.frame.origin.y+cell.betTextLabel.frame.height-5
            
            // TODO populate text with "Loser has to..." or "Winner has to..."
            cell.stakesTextLabel.text = "Loser has to do this thing which is truly outrageous, you do not want to lose this bet because the stakes are so incredibly high. Your friend will enjoy taking a photo of this and posting it on BetFriends."
            let fitSizeStakes = cell.stakesTextLabel.sizeThatFits(fixWidthSize)
            cell.stakesTextLabel.frame = CGRect(x: margin, y: cell.stakesLabel.frame.origin.y+cell.stakesLabel.frame.height+margin, width: fitSizeStakes.width, height: fitSizeStakes.height)
            
            thisRowHeight = cell.stakesTextLabel.frame.origin.y+cell.stakesTextLabel.frame.height+margin
            self.activeTableView.rowHeight = thisRowHeight
            
            return cell
        } else if tableView == self.completedTableView {
            let cell = completedTableView.dequeueReusableCellWithIdentifier("completedCell", forIndexPath: indexPath) as! CompletedBetTableViewCell
            cell.layer.cornerRadius = 10
            
            profPicSize = CGFloat(tableViewSize.width/4)
            let margin = CGFloat(10)
            
            //TODO Update win/loss field based on who won the bet
            cell.winLossLabel.text = "You Won!"
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
            cell.betTextLabel.text = "You bet that here is the bet text, what a crazy bet this is. No one would have ever guessed what this bet would be!"
            let fixWidthSize = CGSize(width: tableViewSize.width-2*margin, height: CGFloat.max)
            let fitSizeBet = cell.betTextLabel.sizeThatFits(fixWidthSize)
            cell.betTextLabel.frame = CGRect(x: margin, y: profPicSize+2*margin, width: fitSizeBet.width, height: fitSizeBet.height)
            
            cell.stakesLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.stakesLabel.frame.origin.y = cell.betTextLabel.frame.origin.y+cell.betTextLabel.frame.height-5
            
            // TODO populate text with "Loser has to..." or "Winner has to..."
            cell.stakesTextLabel.text = "Loser has to do this thing which is truly outrageous, you do not want to lose this bet because the stakes are so incredibly high. Your friend will enjoy taking a photo of this and posting it on BetFriends."
            let fitSizeStakes = cell.stakesTextLabel.sizeThatFits(fixWidthSize)
            cell.stakesTextLabel.frame = CGRect(x: margin, y: cell.stakesLabel.frame.origin.y+cell.stakesLabel.frame.height+margin, width: fitSizeStakes.width, height: fitSizeStakes.height)
            
            cell.resultLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.resultLabel.frame.origin.y = cell.stakesTextLabel.frame.origin.y+cell.stakesTextLabel.frame.height+margin
            
            // TODO if image exists, display the image. If not, display "Add a pic!" button
            if indexPath.row == 0 {
                cell.addPhotoButton.hidden = true
                cell.photoImage.hidden = false
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
                cell.photoImage.hidden = true
                cell.addPhotoButton.hidden = false
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
    @IBAction func onSelectSegment(sender: AnyObject) {
        
        var index = sender.selectedSegmentIndex
        let screenWidth = CGFloat(UIScreen.mainScreen().bounds.size.width)
        let screenWidth2 = CGFloat(2*screenWidth)
        
        if index == 0 {
            UIView.animateWithDuration(0.2, animations: {
                self.horizontalScrollView.contentOffset = CGPoint(x: 0, y: 0)
                }, completion: { (Bool) in
            })
            
        } else if index == 1 {
            UIView.animateWithDuration(0.2, animations: {
                self.horizontalScrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
                }, completion: { (Bool) in
            })
            
        } else if index == 2 {
            UIView.animateWithDuration(0.2, animations: {
                self.horizontalScrollView.contentOffset = CGPoint(x: screenWidth2, y: 0)
                }, completion: { (Bool) in
            })
            
        }
        
        
        
    }
    
    
    //on tapping a bet, send to bet details
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedCell = indexPath.row
        segueIndicator = "cell"
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        performSegueWithIdentifier("toDetails", sender: self)
        
    }
    
    // On tapping the new bet button, set the segue indicator
    @IBAction func onTapNewBetButton(sender: AnyObject) {
        
        segueIndicator = "newbet"
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segueIndicator == "cell" {
            let betDetailsViewController = segue.destinationViewController as! BetDetailsViewController
            betDetailsViewController.view.layoutIfNeeded()
            // Set status, prof pics, bet text, stakes, etc. in destination
            if segmentedControl.selectedSegmentIndex == 1 {
                betDetailsViewController.statusLabel.text = "Active"
                betDetailsViewController.closeBetButton.hidden = false
                betDetailsViewController.statusLabel.textColor = UIColor.blueColor()
                //set bet text, size it, and set/size stakes text
                betDetailsViewController.betTextLabel.text = testBetText[selectedCell]
                let fixWidthSize = CGSize(width: betDetailsViewController.detailsScrollView.frame.width-20, height: CGFloat.max)
                let fitSizeBet = betDetailsViewController.betTextLabel.sizeThatFits(fixWidthSize)
                betDetailsViewController.betTextLabel.frame.size = fitSizeBet
                
                betDetailsViewController.stakesLabel.frame.origin.y = betDetailsViewController.betTextLabel.frame.height+10
                
                betDetailsViewController.stakesTextLabel.frame.origin.y = betDetailsViewController.stakesLabel.frame.origin.y + betDetailsViewController.stakesLabel.frame.height + 10
                betDetailsViewController.stakesTextLabel.text = testStakesText[selectedCell]
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
                
                
                
                if betViewHeight < betDetailsViewController.detailsScrollView.frame.size.height {
                    betDetailsViewController.detailsScrollView.frame.size.height = betViewHeight
                    //shrink the content, or also disable scrolling?
                    betDetailsViewController.detailsScrollView.contentSize.height = betViewHeight
                }
                
                
                
                
            } else if segmentedControl.selectedSegmentIndex == 0 {
                betDetailsViewController.statusLabel.text = "Pending"
                betDetailsViewController.statusLabel.textColor = UIColor.orangeColor()
                betDetailsViewController.acceptButton.hidden = false
                betDetailsViewController.rejectButton.hidden = false
                
                layoutBetDetailsView(betDetailsViewController)
                
            } else if segmentedControl.selectedSegmentIndex == 2 {
                betDetailsViewController.statusLabel.text = "Completed"
                betDetailsViewController.statusLabel.textColor = UIColor.greenColor()
                
                // TODO if there is an image, display it, otherwise display "add Photo" (or just always display add/change photo?)
                betDetailsViewController.addPhotoButton.hidden = false
                
                layoutBetDetailsView(betDetailsViewController)
                
            }
            
            betDetailsViewController.myProfPic.image = UIImage(named: "headshot")
            betDetailsViewController.friendProfPic.image = UIImage(named: "profpic")
            
            
            
        } else if segueIndicator == "newbet" {
            let newBetViewController = segue.destinationViewController as! NewBetViewController
            //just need to pass user info?
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

    func layoutBetDetailsView(betDetailsViewController: BetDetailsViewController) -> Void {
        
        betDetailsViewController.betTextLabel.text = testBetText[selectedCell]
        let fixWidthSize = CGSize(width: betDetailsViewController.detailsScrollView.frame.width-20, height: CGFloat.max)
        let fitSizeBet = betDetailsViewController.betTextLabel.sizeThatFits(fixWidthSize)
        betDetailsViewController.betTextLabel.frame.size = fitSizeBet
        
        betDetailsViewController.stakesLabel.frame.origin.y = betDetailsViewController.betTextLabel.frame.height+10
        
        betDetailsViewController.stakesTextLabel.frame.origin.y = betDetailsViewController.stakesLabel.frame.origin.y + betDetailsViewController.stakesLabel.frame.height + 10
        betDetailsViewController.stakesTextLabel.text = testStakesText[selectedCell]
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
    
}
