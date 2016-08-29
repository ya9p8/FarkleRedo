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
   
    var playerOne:  Player!
    var playerTwo: Player!
    var currentPlayer:Player!
    var players:NSArray!
    
    var selectedDice = NSMutableArray()
    var boardDice = NSMutableArray()
    var multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
    
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
        
        boardDice.addObjectsFromArray([diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix])
        rollScore = 0
        roundScore = 0
        
        playerOne = Player()
        playerTwo = Player()
        players = [playerOne, playerTwo]
        
        currentPlayer = players[0] as! Player

        for die in boardDice {
            let realDie = die as! DiceImageView
            realDie.delegate = self
        }
    }
    
    @IBAction func onRollButtonTapped(sender: UIButton) {
        
        multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
        selectedDice.removeAllObjects()
        
        for die in boardDice  {
            let realDie = die as! DiceImageView
            realDie.roll()
        }
        roundScore += rollScore
        
        scoreRoll(boardDice)
        
        if checkForFarkle(boardDice) {
            showMessage("Farkle!", message: "You farkled. You lose your round score.")
            
            roundScore = 0
            reset()
            switchPlayers()
        }
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
        multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
        
        if !selectedDice.containsObject(die) {
            die.alpha = 0.35
            boardDice.removeObject(die)
            selectedDice.addObject(die)
        } else {
            die.alpha = 1.0
            selectedDice.removeObject(die)
            boardDice.addObject(die)
        }
        
        scoreRoll(selectedDice)
        
        if checkForHotDice() {
            showMessage("Hot Dice!", message: "You get to roll again.")
            roundScore += rollScore
            reset()
        }
    }
    
    func countMultiples(diceArray: NSMutableArray) {
        for die in diceArray {
            let realDie = die as! DiceImageView
            
            for i in 0..<multiplesArray.count  {
                if Int(realDie.imageName)! == i+1 {
                    multiplesArray[i] = multiplesArray[i] as! Int + 1
                }
            }
        }
    }
    
    func scoreRoll(diceArray: NSMutableArray) {
        rollScore = 0
        var singleCounter = 0
        var pairCounter = 0
        var tripleCounter = 0
        var fourOfAKind = false

        countMultiples(diceArray)
        //print(multiplesArray)
        
        for i in 0 ..< multiplesArray.count {
            let multipleOfI = multiplesArray[i] as! Int
            //print("There are \(multipleOfI) \(i+1)'s")
            
            switch multipleOfI {
            case 1:
                rollScore += multiplierScore(i, multiplierFactor: 1)
                singleCounter += 1
                break
            case 2:
                rollScore += multiplierScore(i, multiplierFactor: 2)
                pairCounter += 1
                break
            case 3:
                rollScore += multiplierScore(i, multiplierFactor: 3)
                tripleCounter += 1
                break
            case 4:
                rollScore += 1000
                fourOfAKind = true
                break
            case 5:
                rollScore += 2000
                break
            case 6:
                rollScore += 3000
                break
            default:
                break
            }
            if tripleCounter == 2 {
                rollScore = 2500
            }
            if pairCounter == 3 || (pairCounter == 1 && fourOfAKind) || singleCounter == 6 {
                rollScore = 1500
            }
        }
        //print("---------------")
        
        // Disable selected dice
//        for die in selectedDice {
//            let realDie  = die as! DiceImageView
//            realDie.userInteractionEnabled = false
//        }
    }
    
    
    func checkForFarkle(diceArray: NSMutableArray) -> Bool {
        return (rollScore == 0  && boardDice.count > 0) ? true : false
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
        multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
        rollScore = 0
        
        boardDice = NSMutableArray(array: [diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix])
        selectedDice = NSMutableArray()
        
        for die in boardDice {
            let realDie = die as! DiceImageView
            realDie.roll()
            realDie.alpha = 1.0
            realDie.userInteractionEnabled = true
        }
        scoreRoll(boardDice)
        checkForFarkle(boardDice)
    }
    
}

