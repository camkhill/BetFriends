//
//  BetStruct.swift
//  BetFriends
//
//  Created by Hill, Cameron on 9/29/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

struct BetStruct {
    
    var betID: Int!
    var betText: String!
    var betSender: String!
    var betReceiver: String!
    var winnerLoserToggle: Bool!
    
    
    var stakesText: String!
    let endDate: Date!
    let creationDate: Date!
    
    // 0 = pending, 1 = active, 2 = sender won, 3 = receiver won, 4 = rejected? use enum?
    
    var betState: Int!
    let image: UIImage!
    
    let lastModified: Date!
    
    
}
