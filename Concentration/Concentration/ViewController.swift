//
//  ViewController.swift
//  Concentration
//
//  Created by Nayan, Neeraj on 10/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Lazy indicates -> Do not initialize as yet, until someone uses it
    // This is needed as initialization depends on cardButtons
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // Read only property
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1)/2
    }
    
    // Above list is same as: var flipCount = 0
    private(set) var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBAction private func touchNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
        flipCount = 0
        emoji.removeAll()
        emojiChoices = emojiChoicesCp
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen was not card in cardButtons")
        }
    }
    
    private func updateViewFromModel()
    {
        var isGameOver = true
        for index in cardButtons.indices
        {
            let card = game.cards[index]
            if !card.isMatched {
                isGameOver = false
                break
            }
        }
        
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            if isGameOver {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            } else {
                let card = game.cards[index]
                if card.isFaceUp
                {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else
                {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                }
            }
        }
    }
    
    // Both below lines are same.
    // var emojiChoices = ["🎃", "👻", "🎃", "👻"]
    private var emojiChoices: Array<String> = ["🎃", "👻", "🦇", "😈", "👹", "👺", "💩", "👽", "🍎", "⚽️", "🚗", "☎️", "🇹🇩", "💛"]
    private lazy var emojiChoicesCp = emojiChoices;
    
//    var emoji = Dictionary<Int, String>()
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String
    {
        print ("\(emojiChoices.count)  \(emojiChoicesCp.count)")
        
        // Comma separation for two consecutive if condition
        if emoji[card.identifier] == nil, emojiChoices.count > 0
        {
            // emojiChoices.count.arc4random: Uses Int extension created below
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
//        if let chosenEmoji = emoji[card.identifier]
//        {
//            return chosenEmoji
//        } else
//        {
//            return "?"
//        }
        return emoji[card.identifier] ?? "?"
    }
}

// Extension to Int to generate random number
extension Int {
    var arc4random: Int {
        if self > 0
        {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0
        {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else
        {
            return 0
        }
    }
}

