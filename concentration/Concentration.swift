//
//  Concentration.swift
//  concentration
//
//  Created by Yogesh Manghnani on 31/01/18.
//  Copyright © 2018 Yogesh Manghnani. All rights reserved.
//

import Foundation

class Concentration{
    
    
    
    //MARK: Variables
    private var notRandom = [Card]()
    private(set) var cards = [Card]()
    var flipCount = 0
    private var indexOfOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set (newValue){
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    var score = 0
    var openedCards: [Int] = []
    
    
    
    //MARK: Functions
    func chooseCard(at index: Int){
        //Checking legitimacy of selected card
        if !cards[index].isMatched, !cards[index].isFaceUp{
            flipCount += 1
            
            //checking if anyother card isFaceUP
            if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index{
                //check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }
                else { //if cards dont match negate the score
                    if openedCards.contains(cards[matchIndex].hashValue){
                        score -= 1
                    }
                    if openedCards.contains(cards[index].hashValue){
                        score -= 1
                    }
                }
                //Adding card to opened cards
                if !openedCards.contains(index){
                    openedCards.append(cards[index].hashValue)
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
        score = 0
        openedCards = []
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


extension Collection {
    var oneAndOnly:Element? {
        return count == 1 ? first : nil
    }
}
