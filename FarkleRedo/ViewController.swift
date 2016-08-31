//
//  ViewController.swift
//  FarkleRedo
//
//  Created by Yemi Ajibola on 8/20/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DiceImageViewDelegate {
    
    @IBOutlet weak var diceOne: DiceImageView!
    @IBOutlet weak var diceSix: DiceImageView!
    @IBOutlet weak var diceFive: DiceImageView!
    @IBOutlet weak var diceFour: DiceImageView!
    @IBOutlet weak var diceThree: DiceImageView!
    @IBOutlet weak var diceTwo: DiceImageView!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    @IBOutlet weak var roundScoreLabel: UILabel!
    @IBOutlet weak var rollScoreLabel: UILabel!
    @IBOutlet weak var gatherDiceLabel: UILabel!
   
    var playerOne:  Player!
    var playerTwo: Player!
    var currentPlayer:Player!
    var players:NSArray!
    
    var selectedDice = [DiceImageView]()
    var boardDice: [DiceImageView]!
    var animator = UIDynamicAnimator()
    var scoreLogic  = ScoreLogic()
    
    var roundScore = 0 {
        willSet {
            roundScoreLabel.text = "Round score: \(newValue)"
        }
    }
    var rollScore = 0 {
        willSet {
            rollScoreLabel.text = "Roll score: \(newValue)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundScore = 0
        
        playerOne = Player()
        playerTwo = Player()
        players = [playerOne, playerTwo]
        
        currentPlayer = players[0] as! Player
        
        gatherDiceLabel.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.gatherDice))
        gatherDiceLabel.addGestureRecognizer(tapGesture)
        
        boardDice = [diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix]

        for die in boardDice {
            die.delegate = self
        }
        
    }
    
    @IBAction func onRollButtonTapped(sender: UIButton) {
        selectedDice.removeAll(keepCapacity: true)
        
        for die in boardDice  {
            die.roll()
        }
        roundScore += rollScore
        
        print(scoreLogic.calculateScore(boardDice))
        
//        if checkForFarkle(boardDice) {
//            showMessage("Farkle!", message: "You farkled. You lose your round score.")
//            
//            roundScore = 0
//            reset()
//            switchPlayers()
//        }
    }
    
    @IBAction func onBankButtonTapped(sender: UIButton) {
        roundScore = roundScore + rollScore
        
        if players.indexOfObject(currentPlayer) == 0 {
            playerOne.score += roundScore
            playerOneScoreLabel.text = "Player One score: \(playerOne.score)"
        } else {
            playerTwo.score += roundScore
            playerTwoScoreLabel.text = "Player Two score: \(playerTwo.score)"
        }
        
        roundScore = 0
        reset()
        switchPlayers()
    }
    
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func diceImageViewTapped(die: DiceImageView) {
        if !selectedDice.contains(die) {
            die.alpha = 0.35
            boardDice.removeAtIndex(boardDice.indexOf(die)!)
            selectedDice.append(die)
        } else {
            die.alpha = 1.0
            selectedDice.removeAtIndex(selectedDice.indexOf(die)!)
            boardDice.append(die)
        }
        
        //scoreRoll(selectedDice)
        
        if checkForHotDice() {
            showMessage("Hot Dice!", message: "You get to roll again.")
            roundScore += rollScore
            reset()
        }
    }
    
    func gatherDice() {
        print("Gather Dice Label Tapped!")
        
    }
    
    
    func checkForHotDice() -> Bool {
        return boardDice.count == 0
    }
    
    func multiplierScore(diceNumber: Int, multiplierFactor: Int) -> Int {
        let realDiceNumber = diceNumber + 1
        
        switch realDiceNumber {
        case 1:
            if multiplierFactor == 1 { return 100 } else if multiplierFactor == 2 { return 200 } else { return 1000 }
        case 2:
            if multiplierFactor == 3 { return 200 } else { return 0 }
        case 3:
            if multiplierFactor == 3 { return 300 } else { return 0 }
        case 4:
            if multiplierFactor == 3 { return 400 } else { return 0 }
        case 5:
            if multiplierFactor == 1 { return 50 } else if multiplierFactor == 2 { return 100 } else { return 500 }
        case 6:
            if multiplierFactor == 3 { return 600 } else { return 0 }
        default:
            print("Error")
            return 0
        }
    }
    
    func switchPlayers() {
        if players.indexOfObject(currentPlayer) + 1 == players.count {
            currentPlayer = players[0] as! Player
        } else {
            currentPlayer = players[players.indexOfObject(currentPlayer) + 1] as! Player
        }
    }
    
    func reset() {
        rollScore = 0
        
        boardDice = [diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix]
        selectedDice.removeAll(keepCapacity: true)
        
        for die in boardDice {
            die.roll()
            die.alpha = 1.0
            die.userInteractionEnabled = true
        }
        //scoreRoll(boardDice)
        //scoreLogic.checkForFarkle(boardDice)
    }
    
}

