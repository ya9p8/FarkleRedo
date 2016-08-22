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
    @IBOutlet weak var userScore: UILabel!
    
    var selectedDice = NSMutableArray()
    var boardDice = NSMutableArray()
    var multiplesArray = NSMutableArray(array: [0,0,0,0,0,0])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardDice.addObjectsFromArray([diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix])
        
        for die in boardDice {
            let realDie = die as! DiceImageView
            realDie.delegate = self
        }
    }
    
    @IBAction func onRollButtonTapped(sender: UIButton) {
        for die in boardDice  {
            let realDie = die as! DiceImageView
            realDie.roll()
        }
        
        checkForFarkle(boardDice) == true ? print("You farkled") : print("You're good")
        
    }
    
    func diceImageViewTapped(die: DiceImageView) {
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
                    selectedDice.removeObject(die)
                }
            }
        }
    }
    
    func scoreRound(diceArray: NSMutableArray) -> Int {
        var roundScore = 0
        var singleCounter = 0
        var pairCounter = 0
        var tripleCounter = 0
        var fourOfAKind = false
        
        self.countMultiples(diceArray)
        
        for i in 0 ..< multiplesArray.count {
            
            let multipleOfI = multiplesArray[i] as! Int
            print("There are \(multipleOfI) \(i+1)'s")
            
            switch multipleOfI {
            case 1:
                roundScore += singleScore(i)
                singleCounter += 1
                break
            case 2:
                roundScore += pairScore(i)
                pairCounter += 1
            case 3:
                roundScore += tripleScore(i)
                tripleCounter += 1
            case 4:
                roundScore += 1000
                fourOfAKind = true
            case 5:
                roundScore += 2000
            case 6:
                roundScore += 3000
            default:
                print("Error.")
            }
            
            if tripleCounter == 2 {
                roundScore = 2500
            }
            
            if pairCounter == 3 {
                roundScore = 1500
            }
            
            if pairCounter == 1 && fourOfAKind {
                roundScore = 1500
            }
            
            if singleCounter == 6 {
                roundScore = 1500
            }
        }
        
        print("Round score is: \(roundScore)")
        return roundScore
    }
    
    
    func checkForFarkle(diceArray: NSMutableArray) -> Bool {
        return scoreRound(diceArray) == 0 ? true : false
    }
    
    func singleScore(diceNumber: Int) -> Int {
        let realDiceNumber = diceNumber + 1
        
        switch realDiceNumber {
        case 1:
            return 100
        case 5:
            return 50
        default:
            return 0
        }
        
    }
    
    func pairScore(diceNumber: Int) -> Int {
        let realDiceNumber = diceNumber + 1
        
        switch realDiceNumber {
        case 1:
            return 200
        case 5:
            return 100
        default:
            return 0
        }
    }
    
    func tripleScore(diceNumber: Int) -> Int {
        let realDiceNumber = diceNumber + 1
        
        switch realDiceNumber {
        case 1:
            return 1000
        case 2:
            return 200
        case 3:
            return 300
        case 4:
            return 400
        case 5:
            return 500
        case 6:
            return 600
        default:
            return 0
        }
    }
}

