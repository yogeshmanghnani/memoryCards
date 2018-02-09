//
//  ViewController.swift
//  concentration
//
//  Created by Yogesh Manghnani on 30/01/18.
//  Copyright © 2018 Yogesh Manghnani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    //MARK: Typealias
    typealias themeData = (emojis: [String], bgColor: UIColor, cardColor: UIColor)
    
    

    //MARK: Variables
    @IBOutlet weak private var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    var numberOfPairsOfCards: Int{
        get{
            return (cardButtons.count+1)/2
        }
    }
    
    var themeSet : [String: themeData] = [
        "halloween" : (["👻", "🎃", "🍭", "😈", "🤡", "🍫", "🧟‍♂️", "💀"], #colorLiteral(red: 0.2540834248, green: 0.2756176293, blue: 0.3027161956, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        "animals" : (["🐕", "🐈", "🐴", "🐭", "🐘", "🐷", "🐮", "🦁"], #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)),
        "faces":  (["😀", "🤪", "😬", "😭", "😎", "😍", "🤠", "😇", "🤩", "🤢"], #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)),
        "fruits": (["🍏", "🥑", "🍇", "🍒", "🍑", "🥝", "🍐", "🍎", "🍉", "🍌"], #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
        "transport": (["🚗", "🚓", "🚚", "🏍", "✈️", "🚜", "🚎", "🚲", "🚂", "🛴"], #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        "sports": (["🏊🏽‍♀️", "🤽🏻‍♀️", "🤾🏾‍♂️", "⛹🏼‍♂️", "🏄🏻‍♀️", "🚴🏻‍♀️", "🚣🏿‍♀️", "⛷", "🏋🏿‍♀️", "🤸🏼‍♂️"], #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
    ]
    
    
    private var newTheme : themeData{
        let randomIndex = themeSet.count.arc4random
        let key = Array(themeSet.keys)[randomIndex]
        return themeSet[key]!
    }
    
    
    
    
    private var emojiChoices:[String] = ["👻", "🎃", "🍭", "😈", "🤡", "🍫", "🧟‍♂️", "💀"]
    private var bgColor:UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    private var fgColor:UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private var emoji = [Card:String]()
    
    //MARK: Methods
    ///////////The UDF may or may not be linked to UI
    ///////////These are my functions
    ///////////Beware before editing
    
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.count.arc4random
            emoji[card] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card] ?? "?"
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else{
            print("Not in the array")
        }
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        (emojiChoices, bgColor, fgColor) = newTheme
        view.backgroundColor = bgColor
        game.newGame()
        updateViewFromModel()
        emoji = [:]
        flipCountLabel.textColor = fgColor
        scoreLabel.textColor = fgColor
    }
    
    
    
    
    func updateViewFromModel() {
        flipCountLabel.text = "Flips : \(game.flipCount)"
        scoreLabel.text = "Score : \(game.score)"
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : fgColor
            }
        }
    }

}

extension Int{
    var arc4random : Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}
