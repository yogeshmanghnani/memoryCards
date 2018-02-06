//
//  Concentration.swift
//  concentration
//
//  Created by Yogesh Manghnani on 31/01/18.
//  Copyright © 2018 Yogesh Manghnani. All rights reserved.
//

import Foundation

class Concentration{
    
    
    
    
    private var notRandom = [Card]()
    private(set) var cards = [Card]()
    var flipCount = 0
    private var indexOfOnlyFaceUpCard: Int?{
        get{
            var foundIndex: Int?
            for index in cards.indices{
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set (newValue){
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int){
        if !cards[index].isMatched, !cards[index].isFaceUp{
            flipCount += 1
            if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index{
                //check if cards match
                
                if cards[matchIndex].identifier == cards[index].identifier{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }
            else {
                //either no cards or 2 cards are face up
                indexOfOnlyFaceUpCard = index
            }
        }
        
    }
    
    
    func newGame() {
        for index in 0..<cards.count{
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        flipCount = 0
        cards = shuffle(cardIn: cards)
    }
    
    
    private func shuffle(cardIn notRandom: [Card]) -> [Card]{
        var notRandomVar = notRandom
        var random = [Card]()
        for _ in 0..<notRandomVar.count{
            let randomIndex = notRandomVar.count.arc4random
            random.append(notRandomVar[randomIndex])
            notRandomVar.remove(at: randomIndex)
        }
        return random
    }
    
    init(numberOfPairsOfCards : Int) {
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            notRandom += [card, card]
        }
        cards = shuffle(cardIn: notRandom)
    }
}
