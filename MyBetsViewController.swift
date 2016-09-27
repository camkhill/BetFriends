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
        newBetButton.frame.origin = CGPoint(x: screenWidth-75, y: screenHeight-70)
        newBetButton.frame.size = CGSize(width: 50, height: 50)
        
        
        
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

        //let cell = pendingTableView.dequeueReusableCellWithIdentifier("pendingCell") as! PendingBetsTableViewCell
        
        //cell.pendingLabel.text = "pending..."
        
        //for each of the 3 table views, define the cells
        if tableView == self.pendingTableView {
            let cell = pendingTableView.dequeueReusableCellWithIdentifier("pendingCell") as! PendingBetsTableViewCell
            let margin = CGFloat(10)
            cell.pendingLabel.text = "Display bet text here Display bet text here Display bet text here Display bet text here Display bet text here Display bet text herea"
            cell.layer.cornerRadius = 10
            
            //// Position elements within pending cell
            cell.profPicImageView.frame = CGRect(x: margin, y: margin, width: profPicSize, height: profPicSize)
            cell.profPicImageView.layer.cornerRadius = profPicSize/2
            cell.profPicImageView.layer.masksToBounds = true
            cell.pendingLabel.frame = CGRect(x: profPicSize+2*margin, y: margin, width: tableViewSize.width-profPicSize-3*margin, height: profPicSize)
            cell.stakesLabel.center.x = CGFloat(tableViewSize.width/2)
            cell.stakesLabel.frame.origin.y = profPicSize+margin
            cell.stakesInputLabel.frame = CGRect(x: margin, y: profPicSize+margin+cell.stakesLabel.frame.height, width: tableViewSize.width-2*margin, height: 15)
            
            let cellHeight = CGFloat(margin+profPicSize+cell.stakesLabel.frame.height+cell.stakesInputLabel.frame.height+margin)
            cell.frame.size = CGSize(width: tableViewSize.width, height: cellHeight)
            
            
            return cell
        } else if tableView == self.activeTableView {
            let cell = activeTableView.dequeueReusableCellWithIdentifier("activeCell") as! ActiveBetTableViewCell
            cell.layer.cornerRadius = 10
            return cell
        } else if tableView == self.completedTableView {
            let cell = completedTableView.dequeueReusableCellWithIdentifier("completedCell", forIndexPath: indexPath) as! CompletedBetTableViewCell
            cell.layer.cornerRadius = 10
            return cell
        } else {
            var cell:UITableViewCell?
            return cell!
        }
        
        
        
        
        
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
        
        segueIndicator = "cell"
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
                
            } else if segmentedControl.selectedSegmentIndex == 0 {
                betDetailsViewController.statusLabel.text = "Pending"
                betDetailsViewController.acceptButton.hidden = false
                betDetailsViewController.rejectButton.hidden = false
            } else if segmentedControl.selectedSegmentIndex == 2 {
                betDetailsViewController.statusLabel.text = "Completed"
            }
            
            betDetailsViewController.myProfPic.image = UIImage(named: "headshot")
            betDetailsViewController.friendProfPic.image = UIImage(named: "profpic")
        } else if segueIndicator == "newbet" {
            let newBetViewController = segue.destinationViewController as! NewBetViewController
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
