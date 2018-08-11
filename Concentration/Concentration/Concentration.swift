//
//  Concentration.swift
//  Concentration
//
//  Created by Nayan, Neeraj on 11/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import Foundation

class Concentration
{
    // All below lines are equivalent
//    var cards = Array<Card>()  // Initializes with default init
    var cards = [Card]()
    
    // Classes gets free init() if all its members
    // are already initialized
    // init() {}
    // Custom init
    // No external-internal names for numberOfPairsOfCards
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
        
            // Assigning struct to another variable copies it
//            let matchingCard = card
            
            // Puting struct in array, copies them by value
//            cards.append(card)
//            cards.append(card)
            
            cards += [card, card]
        }
        //TODO: Shuffle the card
        shuffle()
    }
    
    func shuffle() {
        let c = cards.count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(cards.indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = cards.index(firstUnshuffled, offsetBy: d)
            cards.swapAt(firstUnshuffled, i)
        }
    }
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    func chooseCard(at index: Int)
    {
        if !cards[index].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier
                {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else
            {
                for faceUpCard in cards.indices
                {
                    cards[faceUpCard].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}
