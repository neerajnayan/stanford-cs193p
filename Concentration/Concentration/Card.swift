//
//  Card.swift
//  Concentration
//
//  Created by Nayan, Neeraj on 11/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int
    {
        identifierFactory += 1
        return identifierFactory
    }
    
    // Swift provides default intializer which
    // initilizes all its variable
    
    // Custom initializer
    init()
    {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    
    
}
