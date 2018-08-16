//
//  Card.swift
//  Concentration
//
//  Created by Nayan, Neeraj on 11/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import Foundation

struct Card : Hashable
{
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int
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
