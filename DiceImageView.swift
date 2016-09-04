//
//  DiceImageView.swift
//  FarkleRedo
//
//  Created by Yemi Ajibola on 8/20/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit

protocol DiceImageViewDelegate {
    func diceImageViewTapped(die: DiceImageView)
}

class DiceImageView: UIImageView {
    
    var delegate: DiceImageViewDelegate?
    var imageName: String!
    var origin: CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DiceImageView.diceImageViewWasTapped))
        self.addGestureRecognizer(tapGesture)
        
        origin = self.center
    }
    
    func diceImageViewWasTapped() {
       delegate?.diceImageViewTapped(self)
    }
    
    func roll() {
        let imageName = "\(arc4random()%6+1)"
        self.image = UIImage(named: imageName)
        self.imageName = imageName
    }
}
