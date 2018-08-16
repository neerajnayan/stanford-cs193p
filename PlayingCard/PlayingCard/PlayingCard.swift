//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Nayan, Neeraj on 16/08/18.
//  Copyright © 2018 Nayan, Neeraj. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible
{
    var description: String {
        return "\(rank)\(suit)"
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible
    {
        var description: String {
            return rawValue
        }
        
        case spades = "♠️"
        case hearts = "❤️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all: [Suit] {
            return [Suit.spades, .hearts, .diamonds, .clubs]
        }
    }
    
    enum Rank: CustomStringConvertible
    {
        var description: String {
            switch (self) {
            case .ace: return "A"
            case .number(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
        
        case ace
        case face(String)
        case number(Int)
        
        var order: Int {
            switch (self) {
            case .ace: return 1
            case .number(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRank = [Rank.ace]
            for pip in 2...10 {
               allRank.append(.number(pip))
            }
            allRank += [Rank.face("J"),Rank.face("Q"),Rank.face("K")]
            return allRank
        }
    }
}
