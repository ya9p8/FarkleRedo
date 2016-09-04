//
//  Player.swift
//  FarkleRedo
//
//  Created by Yemi Ajibola on 8/25/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import Foundation

protocol PlayerDelegate {
    func playerScoreWasUpdated()
}

class Player:Equatable {
    var score: Int {
        didSet {
            delegate?.playerScoreWasUpdated()
        }
    }
    var selectedDice:[DiceImageView]!
    var name:String? = ""
    var delegate: PlayerDelegate?
    
    
   init() {
        score = 0
        selectedDice = [DiceImageView]()
    }
    
    init(nameString: String) {
        score = 0
        selectedDice = [DiceImageView]()
        name = nameString
    }
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
}


