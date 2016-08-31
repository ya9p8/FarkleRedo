//
//  ScoreLogic.swift
//  FarkleRedo
//
//  Created by Yemi Ajibola on 8/31/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import Foundation

class ScoreLogic {
    
    var multiplesArray:[Int] = [0, 0, 0, 0, 0, 0]
    
    func countMultiples(diceHand: [DiceImageView]) {
        multiplesArray.removeAll(keepCapacity: true)
        
        for die in diceHand {
            for i in 0..<multiplesArray.count  {
                if Int(die.imageName)! == i+1 {
                    multiplesArray[i] = multiplesArray[i] + 1
                }
            }
        }
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
            return 0
        }
    }
    
    func checkForFarkle(diceArray: [DiceImageView], rollScore: Int) -> Bool {
        return (rollScore == 0  && diceArray.count > 0) ? true : false
    }
    
    func calculateScore(diceHand: [DiceImageView]) -> Int {
        var rollScore = 0
        var singleCounter = 0
        var pairCounter = 0
        var tripleCounter = 0
        var fourOfAKind = false
        
        countMultiples(diceHand)
        
        for i in 0 ..< multiplesArray.count {
            let multipleOfI = multiplesArray[i]
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
        
        return rollScore
    }
}