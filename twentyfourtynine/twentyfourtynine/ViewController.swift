//
//  ViewController.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 1/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum SwipeDirection {
        case Right, Down, Left, Up
    }
    
    var b = Board()
    var ai: AI?
    var tileFrames: [[CGRect]] {
        var tmp = [[CGRect]]()
        for row in boxes {
            var tileRow = [CGRect]()
            for tile in row {
                tileRow.append(tile.frame)
            }
            tmp.append(tileRow)
        }
        return tmp
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    var score: Int = 0
    
    var checkingForGameOver = false
    
    @IBOutlet var gameOverView: UIView!

    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var box1: UIView!
    @IBOutlet weak var box2: UIView!
    @IBOutlet weak var box3: UIView!
    @IBOutlet weak var box4: UIView!
    @IBOutlet weak var box5: UIView!
    @IBOutlet weak var box6: UIView!
    @IBOutlet weak var box7: UIView!
    @IBOutlet weak var box8: UIView!
    @IBOutlet weak var box9: UIView!
    @IBOutlet weak var box10: UIView!
    @IBOutlet weak var box11: UIView!
    @IBOutlet weak var box12: UIView!
    @IBOutlet weak var box13: UIView!
    @IBOutlet weak var box14: UIView!
    @IBOutlet weak var box15: UIView!
    @IBOutlet weak var box16: UIView!
    var boxes: [[UIView]] {
        return [[box1, box2, box3, box4], [box5, box6, box7, box8], [box9, box10, box11, box12], [box13, box14, box15, box16]]
    }
    
    @IBOutlet weak var vertConstraint1: NSLayoutConstraint!
    @IBOutlet weak var vertConstraint2: NSLayoutConstraint!
    @IBOutlet weak var vertConstraint3: NSLayoutConstraint!
    @IBOutlet weak var horConstraint1: NSLayoutConstraint!
    @IBOutlet weak var horConstraint2: NSLayoutConstraint!
    @IBOutlet weak var horConstraint3: NSLayoutConstraint!
    var interBoxConstraints: [NSLayoutConstraint] {
        return [vertConstraint1,vertConstraint2,vertConstraint3,horConstraint1,horConstraint2,horConstraint3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 0.99
            self.roundBoxes()
            self.updateInterBoxContraints()
        }, completion: { _ in
            self.view.alpha = 1.00
            self.initBoard() // has to be after initTileFrames and the constraint stuff
        })
    }
    
    func initBoard() {
        // handle case where there is a board saved in coredata?
        gameOverView.isHidden = true
        
        b.clear()
        
        b = Board(on: self)
    }
    
    func showTile(_ tile: Tile) {
        background.addSubview(tile)
    }
    
    func roundBoxes() {
        for row in boxes {
            for box in row {
                box.layer.cornerRadius = 5
            }
        }
    }
    
    func updateInterBoxContraints() {
        for constraint in interBoxConstraints {
            constraint.constant = 11.0 * background.frame.width / 290.0 // 290.0 is the width of the background on an iPhone SE (where the constraints are best-looking)
        }
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        swipe(.Right)
    }
    @IBAction func swipeDown(_ sender: Any) {
        swipe(.Down)
    }
    @IBAction func swipeLeft(_ sender: Any) {
        swipe(.Left)
    }
    @IBAction func swipeUp(_ sender: Any) {
        swipe(.Up)
    }
    
    func swipe(_ direction: SwipeDirection) {
        let oldBoard = Board(b.b)
        
        switch direction {
        case .Right: b.right()
        case .Down: b.down()
        case .Left: b.left()
        case .Up: b.up()
        }
        
        if !b.equals(oldBoard) {
            b.checkForGameOver()
            b.insertNewTile()
        }
        
    }
    
    func animateMove(fromRow: Int, toRow: Int, fromCol: Int, toCol: Int) {
        UIView.animate(withDuration: 0.1*AC, animations: {
            self.b.b[fromRow][fromCol].frame = self.tileFrames[toRow][toCol]
        })
    }
    
    func increaseScore(by amount: Int) {
        score += amount
        scoreLabel.text = String(score)
    }
    
    func gameOver() {
        self.gameOverView.alpha = 0
        self.gameOverView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.gameOverView.alpha = 1
        })
        
    }
    
    @IBAction func newGamePressed(_ sender: Any) {
        increaseScore(by: -1 * score)
        initBoard()
    }
    
    @IBAction func aiPressed(_ sender: Any) {
        if ai == nil {
            ai = AI(on: self)
        }
        
        ai!.toggle()
    }
}

