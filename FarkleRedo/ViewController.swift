//
//  ViewController.swift
//  FarkleRedo
//
//  Created by Yemi Ajibola on 8/20/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DiceImageViewDelegate, ScoreLogicDelegate, PlayerDelegate {
    
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
    @IBOutlet weak var rollButton: UIButton!
   
    var playerOne:  Player!
    var playerTwo: Player!
    var currentPlayer:Player!
    //var players:[Player]!
    
    var boardDice: [DiceImageView]!
    var scoreLogic: ScoreLogic!
    var animator: UIDynamicAnimator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLogic = ScoreLogic()
        
        
        playerOne = Player(nameString: "Yemi")
        playerTwo = Player()
        
        currentPlayer = playerOne
        
        playerOne.delegate = self
        playerTwo.delegate = self
        
        gatherDiceLabel.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.gatherDice))
        gatherDiceLabel.addGestureRecognizer(tapGesture)
        
        animator = UIDynamicAnimator(referenceView: view)
        
        
        boardDice = [diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix]

        for die in boardDice {
            die.delegate = self
        }
        scoreLogic.delegate = self
    }
    
    @IBAction func onRollButtonTapped(sender: UIButton) {
        currentPlayer.selectedDice.removeAll(keepCapacity: true)
        
        for die in boardDice {
            die.roll()
        }
        
        scoreLogic.calculateScore(boardDice)
        
        if checkForFarkle(boardDice) {
            showMessage("Farkle!", message: "You farkled. You lose your round score.")
            
            scoreLogic.roundScore = 0
            reset()
            switchPlayers()
        }
        
        rollButton.enabled = false
    }
    
    @IBAction func onBankButtonTapped(sender: UIButton) {        
        if currentPlayer == playerOne {
            playerOne.score += scoreLogic.roundScore
        } else {
            playerTwo.score += scoreLogic.roundScore
        }
        
        scoreLogic.roundScore = 0
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
        if !currentPlayer.selectedDice.contains(die) {
            die.alpha = 0.35
            boardDice.removeAtIndex(boardDice.indexOf(die)!)
            currentPlayer.selectedDice.append(die)
        } else {
            die.alpha = 1.0
            currentPlayer.selectedDice.removeAtIndex(currentPlayer.selectedDice.indexOf(die)!)
            boardDice.append(die)
        }
        
        scoreLogic.calculateScore(currentPlayer.selectedDice)
        
        if checkForHotDice() {
            showMessage("Hot Dice!", message: "You get to roll again.")
            scoreLogic.roundScore += scoreLogic.rollScore
            reset()
        }
    }
    
    func rollScoreWasUpdated() {
        rollScoreLabel.text = "Roll score: \(scoreLogic.rollScore)"
    }
    
    func roundScoreWasUpdated() {
        roundScoreLabel.text =  "Round score: \(scoreLogic.roundScore)"
    }
    
    func playerScoreWasUpdated() {
        if currentPlayer == playerOne {
            playerOneScoreLabel.text = "Player One score: \(playerOne.score)"
        } else {
            playerTwoScoreLabel.text = "Player Two score: \(playerTwo.score)"
        }
    }
    
    
    func gatherDice() {
        scoreLogic.roundScore += scoreLogic.rollScore
        
        for die in currentPlayer.selectedDice {
            let snapBehavior = UISnapBehavior(item: die, snapToPoint: gatherDiceLabel.center)
            animator?.addBehavior(snapBehavior)
        }
        
        rollButton.enabled = true
    }
    
    func checkForFarkle(diceHand: [DiceImageView]) -> Bool {
        return (scoreLogic.rollScore == 0  && diceHand.count > 0) ? true : false
    }
    
    func checkForHotDice() -> Bool {
        return boardDice.count == 0
    }
    
    func switchPlayers() {
        if currentPlayer == playerTwo {
            currentPlayer = playerOne
        } else {
            currentPlayer = playerTwo
        }
    }
    
    func reset() {
        boardDice = [diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix]
        currentPlayer.selectedDice.removeAll(keepCapacity: true)
        
        for die in boardDice {
            die.roll()
            die.alpha = 1.0
            die.userInteractionEnabled = true
        }
        scoreLogic.calculateScore(boardDice)
        checkForFarkle(boardDice)
    }
    
}

