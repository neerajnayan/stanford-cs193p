//
//  MultiCardViewController.swift
//  PlayingCard
//
//  Created by Nayan, Neeraj on 24/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import UIKit

class MultiCardViewController: UIViewController {

    private var deck = PlayingCardDeck()
  
    @IBOutlet var cardViews: [PlayingCardView]!
  
    // Ensure all cards in the board is moving
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            // Add tap gesture
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            // adding item to card behavior
            cardBehavior.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
        faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    private var lastChosenCardView: PlayingCardView?
    
    // Hnadle tap gesture
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            // Once the flip gesture has ended, animate the card-flip
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                // Once a card is selected, stop its movement
                cardBehavior.removeItem(chosenCardView)
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        // Animate the UI change when card faceUp changes
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                    },
                    // Handle, when animation is finished
                    completion: { finished in
                        let cardsToAnimate = self.faceUpCardViews
                        // If there are two faceup cards
                        // and if they match, show animation and vanish them
                        if self.faceUpCardViewsMatch {
                            // First, make them enlarge thrice as their initial size
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                                },
                                completion: { position in
                                    // On completion, make them extremely small and vanish them
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            cardsToAnimate.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.transform = .identity
                                                $0.alpha = 1
                                            }
                                        }
                                    )
                                }
                            )
                        } else if self.faceUpCardViews.count == 2 {
                            if chosenCardView == self.lastChosenCardView {
                                // If there are two faceup cards and if they
                                // do not match, flip them over again
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.6,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            cardView.isFaceUp = false
                                        },
                                        completion: { finished in
                                            self.cardBehavior.addItem(cardView)
                                        }
                                    )
                                }
                            }
                        } else if !chosenCardView.isFaceUp {
                            self.cardBehavior.addItem(chosenCardView)
                        }
                    }
                )
            }
        default: break
        }
    }
}
