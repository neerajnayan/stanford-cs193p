//
//  ViewController.swift
//  Concentration
//
//  Created by Nayan, Neeraj on 10/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
//    override var vclLoggingName: String {
//        return "Game"
//    }
    
    // Lazy indicates -> Do not initialize as yet, until someone uses it
    // This is needed as initialization depends on visibleCardButtons
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // Read only property
    var numberOfPairsOfCards: Int {
        return (visibleCardButtons.count + 1)/2
    }
    
    // Above list is same as: var flipCount = 0
    private(set) var flipCount: Int = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBAction private func touchNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (visibleCardButtons.count + 1)/2)
        flipCount = 0
        emoji.removeAll()
        emojiChoices = emojiChoicesCp
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = visibleCardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen was not card in cardButtons")
        }
    }
    
    private func updateFlipCountLabel()
    {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips\n\(flipCount)" : "Flips: \(flipCount)",
            attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    // Callback when trait collection changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    
    private func updateViewFromModel()
    {
        // This is needed, because this method can be
        // invoked from theme.didSet which is invoked
        // from prepare method in ConcentrationThemeChooserViewControl
        // while seting the theme as part of preparing this viewcontroller
        if visibleCardButtons == nil {
            return
        }
        
        var isGameOver = true
        for index in visibleCardButtons.indices
        {
            let card = game.cards[index]
            if !card.isMatched {
                isGameOver = false
                break
            }
        }
        
        for index in visibleCardButtons.indices
        {
            let button = visibleCardButtons[index]
            if isGameOver {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            } else {
                let card = game.cards[index]
                if card.isFaceUp
                {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else
                {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    
    var theme: String? {
        didSet {
            emojiChoicesCp = theme ?? ""
            emojiChoices = emojiChoicesCp
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    // Both below lines are same.
//    private var emojiChoices: Array<String> = ["🎃", "👻", "🦇", "😈", "👹", "👺", "💩", "👽", "🍎", "⚽️", "🚗", "☎️", "🇹🇩", "💛"]
    private var emojiChoices = "🎃👻🦇😈👹👺💩👽🍎⚽️🚗☎️🇹🇩💛"
    private lazy var emojiChoicesCp = emojiChoices;
    
//    var emoji = Dictionary<Int, String>()
    // Card can be used as Key, since card inherits hashable
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String
    {   
        // Comma separation for two consecutive if condition
        if emoji[card] == nil, emojiChoices.count > 0
        {
            // emojiChoices.count.arc4random: Uses Int extension created below
//            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
//        if let chosenEmoji = emoji[card.identifier]
//        {
//            return chosenEmoji
//        } else
//        {
//            return "?"
//        }
        return emoji[card] ?? "?"
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

