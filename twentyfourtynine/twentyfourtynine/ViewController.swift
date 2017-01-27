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
    
    var b = [[Tile(0),Tile(0),Tile(0),Tile(0)],
                 [Tile(0),Tile(0),Tile(0),Tile(0)],
                 [Tile(0),Tile(0),Tile(0),Tile(0)],
                 [Tile(0),Tile(0),Tile(0),Tile(0)]]
    var tileFrames = [[CGRect]]()
    var bOld = [[0,0,0,0],
             [0,0,0,0],
             [0,0,0,0],
             [0,0,0,0]] // delete this
    
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
    var boxes = [[UIView]]()
    
    @IBOutlet weak var vertConstraint1: NSLayoutConstraint!
    @IBOutlet weak var vertConstraint2: NSLayoutConstraint!
    @IBOutlet weak var vertConstraint3: NSLayoutConstraint!
    @IBOutlet weak var horConstraint1: NSLayoutConstraint!
    @IBOutlet weak var horConstraint2: NSLayoutConstraint!
    @IBOutlet weak var horConstraint3: NSLayoutConstraint!
    var interBoxConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        initBoxes()
        roundBoxes()
        initTileFrames()
        initBoard() // has to be after initTileFrames
        initInterBoxConstraints()
        updateInterBoxContraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTileFrames() {
        for row in boxes {
            var tileRow = [CGRect]()
            for tile in row {
                tileRow.append(tile.frame)
            }
            tileFrames.append(tileRow)
        }
    }
    
    func initBoard() {
        // handle case where there is a board saved in coredata
        srandom(UInt32(time(nil)))
        let first = arc4random() % 16
        var second = arc4random() % 16
        while second == first {
            second = arc4random() % 16
        }
        
        let firstInt = Int(first)
        let secondInt = Int(second)
        
        b[firstInt/4][firstInt%4] = Tile(2)
        b[secondInt/4][secondInt%4] = Tile(2)
    
        b[firstInt/4][firstInt%4].create(withFrame: tileFrames[firstInt/4][firstInt%4])
        b[secondInt/4][secondInt%4].create(withFrame: tileFrames[secondInt/4][secondInt%4])
        
    }

    func initBoxes() {
         boxes = [[box1, box2, box3, box4], [box5, box6, box7, box8], [box9, box10, box11, box12], [box13, box14, box15, box16]]
    }
    
    func roundBoxes() {
        for row in boxes {
            for box in row {
                box.layer.cornerRadius = 5
            }
        }
    }

    func initInterBoxConstraints() {
        interBoxConstraints = [vertConstraint1,vertConstraint2,vertConstraint3,horConstraint1,horConstraint2,horConstraint3]
    }

    func updateInterBoxContraints() {
        for constraint in interBoxConstraints {
            constraint.constant = 11.0 * background.frame.width / 290 // 290.0 is the width of the background on an iPhone SE (where the constraints are best-looking)
        }
    }
    
    func showTiles(/**/) {
        // TODO
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
        let oldBoard = b // does a deep copy because swift is wild
    
        switch direction {
        case .Right: right()
        case .Down: down()
        case .Left: left()
        case .Up: up()
        }
        
        var nothingChanged = true
        for i in [0,1,2,3] {
            if nothingChanged == false {
                break
            }
            for j in [0,1,2,3] {
                if b[i][j] != oldBoard[i][j] {
                    nothingChanged = false
                    break
                }
            }
        }
        if nothingChanged {
            insertNewTile()
        }
        
    }
    
    func animateMove(fromRow: Int, toRow: Int, fromCol: Int, toCol: Int) {
        UIView.animate(withDuration: 2, animations: {
            self.b[fromRow][fromCol].frame = self.tileFrames[toRow][toCol]
        })
    }
    
    func right() {
        moveRight()
        mergeRight()
        moveRight()
    }
    
    func moveRight() {
        for i in [0,1,2,3] {
            for j in [2,1,0] {
                if b[i][j].number != 0 {
                    var k = 0
                    while j+k+1 < 4 && b[i][j+k+1].number == 0 {
                        k += 1
                    }
                    animateMove(fromRow: i, toRow: i, fromCol: j, toCol: k)
                    b[i][j] = Tile(0)
                    b[i][j+k] = b[i][j]
                }
            }
        }
    }
    
    func mergeRight() {
        for i in [0,1,2,3] {
            for j in [2,1,0] {
                if b[i][j].number == b[i][j+1].number {
                    // animate this
                    b[i][j+1].number *= 2
                    b[i][j].number = 0
                }
            }
        }
    }
    
    func down() {
        moveDown()
        mergeDown()
        moveDown()
    }
    
    func moveDown() {
        
    }
    
    func mergeDown() {
        
    }
    
    func left() {
        moveLeft()
        mergeLeft()
        moveLeft()
    }
    
    func moveLeft() {
        
    }
    
    func mergeLeft() {
        
    }
    
    func insertNewTile() {
        
    }
    
    func up() {
        moveUp()
        mergeUp()
        moveUp()
    }
    
    func moveUp() {
        
    }
    
    func mergeUp() {
        
    }
}

