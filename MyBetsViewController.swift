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
    @IBOutlet weak var pendingCell: PendingBetsTableViewCell!
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var newBetButton: UIButton!
    
    //temp cell
    let cell: UITableViewCell! = nil
    
    
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
        let tableViewSize = CGSize(width: horizontalScrollViewWidth-(2*sideMargins), height: horizontalScrollViewHeight)
        print(tableViewSize)
        
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
            cell.pendingLabel.text = "updated"
            return cell
        } else if tableView == self.activeTableView {
            let cell = activeTableView.dequeueReusableCellWithIdentifier("activeCell") as! ActiveBetTableViewCell
            return cell
        } else if tableView == self.completedTableView {
            let cell = completedTableView.dequeueReusableCellWithIdentifier("completedCell", forIndexPath: indexPath) as! CompletedBetTableViewCell
            return cell
        } else {
            print("hit the else")
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
        performSegueWithIdentifier("toDetails", sender: self)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
