//
//  Board.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 2/1/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class Board: UIView {
    
//    var contentView : UIView!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        xibSetup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        xibSetup()
//    }
//    
//    func xibSetup() {
//        contentView = loadViewFromNib()
//        
//        // use bounds not frame or it'll be offset
//        contentView.frame = bounds
//        
//        // Make the view stretch with containing view
//        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
//        
//        // Adding custom subview on top of our view (over any custom drawing > see note below)
//        addSubview(contentView)
//    }
//    
//    func loadViewFromNib() -> UIView! {
//        
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(describing: self), bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
//        
//        return view
//    }
    
    var vc: ViewController? = nil
    
    enum SwipeDirection {
        case Right, Down, Left, Up
    }
    
    var b = [[Tile(0),Tile(0),Tile(0),Tile(0)],
             [Tile(0),Tile(0),Tile(0),Tile(0)],
             [Tile(0),Tile(0),Tile(0),Tile(0)],
             [Tile(0),Tile(0),Tile(0),Tile(0)]]
    var tileFrames = [[CGRect]]()
    
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
    
    convenience init (b: [[Tile]]) {
        self.init()
        self.b = b
    }
    
    
    
    func draw(on vc: ViewController) {
        self.vc = vc
        vc.view.addSubview(self)
//        while(box1 == nil) {
//            print("")
//        }
        
        initBoxes()
        roundBoxes()
        initInterBoxConstraints()
        updateInterBoxContraints()
        UIView.animate(withDuration: 0.1, animations: { // HACKY
            self.alpha = 0.99
        }, completion: { _ in
            self.alpha = 1.0
            self.initTileFrames()
            self.initBoard() // has to be after initTileFrames and the constraint stuff
        })
    }
    
    func swipe(_ direction: SwipeDirection) {
        print("swipe")
        let oldBoard = Board(b: b)
        
        switch direction {
        case .Right: right()
        case .Down: down()
        case .Left: left()
        case .Up: up()
        }
        
        
        if !nothingChangedBetween(oldBoard, self) {
            vc?.tockTicker()
            insertNewTile()
            checkForGameOver()
        }
        
    }
    
    func animateMove(fromRow: Int, toRow: Int, fromCol: Int, toCol: Int) {
        UIView.animate(withDuration: 0.1*AC, animations: {
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
                if b[i][j].num != 0 && b[i][j+1].num == 0 {
                    var k = j
                    while k+1 < 4 && b[i][k+1].num == 0 {
                        k += 1
                    }
                    animateMove(fromRow: i, toRow: i, fromCol: j, toCol: k)
                    b[i][k] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }
    
    func mergeRight() {
        for i in [0,1,2,3] {
            for j in [2,1,0] {
                if b[i][j].num != 0 && b[i][j].num == b[i][j+1].num {
                    //                    print("Mergeright")
                    animateMove(fromRow: i, toRow: i, fromCol: j, toCol: j+1)
                    b[i][j+1].increment()
                    vc?.increaseScore(by: b[i][j+1].num)
                    b[i][j].removeFromSuperview()
                    b[i][j] = Tile(0)
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
        for i in [2,1,0] {
            for j in [0,1,2,3] {
                if b[i][j].num != 0 && b[i+1][j].num == 0 {
                    var k = i
                    while k+1 < 4 && b[k+1][j].num == 0 {
                        k += 1
                    }
                    animateMove(fromRow: i, toRow: k, fromCol: j, toCol: j)
                    b[k][j] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }
    
    func mergeDown() {
        for i in [2,1,0] {
            for j in [0,1,2,3] {
                if b[i][j].num != 0 && b[i][j].num == b[i+1][j].num {
                    //                    print("Mergedown")
                    animateMove(fromRow: i, toRow: i+1, fromCol: j, toCol: j)
                    b[i+1][j].increment()
                    vc?.increaseScore(by: b[i+1][j].num)
                    b[i][j].removeFromSuperview()
                    b[i][j] = Tile(0)
                }
            }
        }
    }
    
    func left() {
        moveLeft()
        mergeLeft()
        moveLeft()
    }
    
    func moveLeft() {
        for i in [0,1,2,3] {
            for j in [1,2,3] {
                if b[i][j].num != 0 && b[i][j-1].num == 0 {
                    var k = j
                    while k-1 >= 0 && b[i][k-1].num == 0 {
                        k -= 1
                    }
                    animateMove(fromRow: i, toRow: i, fromCol: j, toCol: k)
                    b[i][k] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }
    
    func mergeLeft() {
        for i in [0,1,2,3] {
            for j in [1,2,3] {
                if b[i][j].num != 0 && b[i][j].num == b[i][j-1].num {
                    //                    print("mergeleft")
                    animateMove(fromRow: i, toRow: i, fromCol: j, toCol: j-1)
                    b[i][j-1].increment()
                    vc?.increaseScore(by: b[i][j-1].num)
                    b[i][j].removeFromSuperview()
                    b[i][j] = Tile(0)
                }
            }
        }
    }
    
    func up() {
        moveUp()
        mergeUp()
        moveUp()
    }
    
    func moveUp() {
        for i in [1,2,3] {
            for j in [0,1,2,3] {
                if b[i][j].num != 0 && b[i-1][j].num == 0 {
                    var k = i
                    while k-1 >= 0 && b[k-1][j].num == 0 {
                        k -= 1
                    }
                    animateMove(fromRow: i, toRow: k, fromCol: j, toCol: j)
                    b[k][j] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }
    
    func mergeUp() {
        for i in [1,2,3] {
            for j in [0,1,2,3] {
                if b[i][j].num != 0 && b[i][j].num == b[i-1][j].num {
                    //                    print("mergeup")
                    animateMove(fromRow: i, toRow: i-1, fromCol: j, toCol: j)
                    b[i-1][j].increment()
                    vc?.increaseScore(by: b[i-1][j].num)
                    b[i][j].removeFromSuperview()
                    b[i][j] = Tile(0)
                }
            }
        }
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
        
        b[firstInt/4][firstInt%4] = Tile(BASE)
        b[secondInt/4][secondInt%4] = Tile(BASE)
        
        addSubview(b[firstInt/4][firstInt%4])
        addSubview(b[secondInt/4][secondInt%4])
        
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
            constraint.constant = 11.0 * frame.width / 290.0 // 290.0 is the width of the background on an iPhone SE (where the constraints are best-looking)
        }
    }
    
    
    
    func insertNewTile() {
        var emptys = [(row: Int, col: Int)]()
        for row in [0,1,2,3] {
            for col in [0,1,2,3] {
                if b[row][col].num == 0 {
                    emptys.append((row: row, col: col))
                }
            }
        }
        
        if emptys.count == 0 {
            gameOver()
            return
        }
        
        srandom(UInt32(time(nil)))
        let tuple = emptys[Int(arc4random()) % emptys.count]
        b[tuple.row][tuple.col] = Tile(BASE)
        addSubview(b[tuple.row][tuple.col])
        b[tuple.row][tuple.col].create(withFrame: tileFrames[tuple.row][tuple.col])
        // could generate BASE * BASE tiles also
        
        //        print(b.map {$0.map { $0.num}})
    }
    
    func checkForGameOver() {
        let boardCopy = Board(b: b)
        right()
        down()
        left()
        up()
        
        if nothingChangedBetween(boardCopy, self) {
            print(b)
            print(boardCopy)
            gameOver()
        }
    }
    
    func gameOver() {
        print("GAMEOVER")
    }
    
    // this should be nicer
    func nothingChangedBetween(_ b1: Board, _ b2: Board) -> Bool {
        for i in [0,1,2,3] {
            for j in [0,1,2,3] {
                if b1.b[i][j] != b2.b[i][j] {
                    return false
                }
            }
        }
        return true
    }
}
