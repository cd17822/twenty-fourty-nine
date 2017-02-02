//
//  ViewController.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 1/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    var score: Int = 0
    
    @IBOutlet weak var ticker: Ticker!

    @IBOutlet weak var board: Board!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        board.draw(on: self)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        board.draw(on: self)
    }
    
    
    func increaseScore(by amount: Int) {
        score += amount
        scoreLabel.text = String(score)
    }
    
    func tockTicker() {
        ticker.tock()
    }

    
}

