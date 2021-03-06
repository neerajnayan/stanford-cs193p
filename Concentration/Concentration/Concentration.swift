//
//  Concentration.swift
//  Concentration
//
//  Created by Nayan, Neeraj on 11/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import Foundation

struct Concentration
{
    // All below lines are equivalent
    //    var cards = Array<Card>()  // Initializes with default init
    private(set) var cards = [Card]()
    
    // Computed property
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // Following statements are similar
//            let faceUpCardIndices = cards.indices.filter({ (operand: Int) -> Bool in return cards[operand].isFaceUp })
//            let faceUpCardIndices = cards.indices.filter({ (operand: Int) in return cards[operand].isFaceUp })
//            let faceUpCardIndices = cards.indices.filter({ (operand) in return cards[operand].isFaceUp })
//            let faceUpCardIndices = cards.indices.filter({ (operand) in cards[operand].isFaceUp })
//            let faceUpCardIndices = cards.indices.filter({ cards[$0].isFaceUp })
//            let faceUpCardIndices = cards.indices.filter() { cards[$0].isFaceUp }
            // Without extension declared at the end of this file
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            
            // With extension declared at the end of this file
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
//            var foundIndex: Int?
//            for index in cards.indices
//            {
//                if cards[index].isFaceUp
//                {
//                    if foundIndex == nil
//                    {
//                        foundIndex = index
//                    } else
//                    {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        // same as set(newValue) {
        set {
            for index in cards.indices
            {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    // Classes gets free init() if all its members
    // are already initialized
    // init() {}
    // Custom init
    // No external-internal names for numberOfPairsOfCards
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration:init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
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
    
    mutating private func shuffle() {
        let c = cards.count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(cards.indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = cards.index(firstUnshuffled, offsetBy: d)
            cards.swapAt(firstUnshuffled, i)
        }
    }
    
    mutating func chooseCard(at index: Int)
    {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index]
                {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else
            {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}

extension Collection
{
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
