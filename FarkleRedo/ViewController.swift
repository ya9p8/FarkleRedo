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
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var roundScoreLabel: UILabel!
    
    var selectedDice = NSMutableArray()
    var boardDice = NSMutableArray()
    var multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
    var bankScore = 0
    var roundScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardDice.addObjectsFromArray([diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix])
        userScoreLabel.text = "User score: \(bankScore)"
        roundScoreLabel.text = "Round score: \(roundScore)"
        
        for die in boardDice {
            let realDie = die as! DiceImageView
            realDie.delegate = self
        }
    }
    
    @IBAction func onRollButtonTapped(sender: UIButton) {
        multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
        
        for die in boardDice  {
            let realDie = die as! DiceImageView
            realDie.roll()
        }
        
        if checkForFarkle(boardDice) == true {
            print("You farkled!")
            reset()
        }
        else {
            print("You're good")
        }
        
    }
    
    @IBAction func onBankButtonTapped(sender: UIButton) {
        bankScore = bankScore + roundScore
        userScoreLabel.text = "User score: \(bankScore)"
        reset()
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
        scoreRound(selectedDice)
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
    
    func scoreRound(diceArray: NSMutableArray) -> Int {
        var scoreForRound = 0
        var singleCounter = 0
        var pairCounter = 0
        var tripleCounter = 0
        var fourOfAKind = false

        countMultiples(diceArray)
        
        for i in 0 ..< multiplesArray.count {
            
            let multipleOfI = multiplesArray[i] as! Int
            //print("There are \(multipleOfI) \(i+1)'s")
            
            switch multipleOfI {
            case 1:
                scoreForRound += multiplierScore(i, multiplierFactor: 1)
                singleCounter += 1
                break
            case 2:
                scoreForRound += multiplierScore(i, multiplierFactor: 2)
                pairCounter += 1
                break
            case 3:
                scoreForRound += multiplierScore(i, multiplierFactor: 3)
                tripleCounter += 1
                break
            case 4:
                scoreForRound += 1000
                fourOfAKind = true
                break
            case 5:
                scoreForRound += 2000
                break
            case 6:
                scoreForRound += 3000
                break
            default:
                break
            }
            if tripleCounter == 2 {
                scoreForRound = 2500
            }
            if pairCounter == 3 {
                scoreForRound = 1500
            }
            if pairCounter == 1 && fourOfAKind {
                scoreForRound = 1500
            }
            if singleCounter == 6 {
                scoreForRound = 1500
            }
        }
        
        roundScoreLabel.text = "Round score: \(scoreForRound)"
        return scoreForRound
    }
    
    
    func checkForFarkle(diceArray: NSMutableArray) -> Bool {
        return scoreRound(diceArray) == 0 ? true : false
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
    
    func reset() {
        multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
        roundScore = 0
        roundScoreLabel.text = "Round score: \(roundScore)"
        
        boardDice.addObjectsFromArray([diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix])
        selectedDice = NSMutableArray()
        for die in boardDice {
            let realDie = die as! DiceImageView
            realDie.alpha = 1.0
        }
    }
    
}

