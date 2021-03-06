//
//  Board.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 2/3/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Board {
    var b = [[Tile(0),Tile(0),Tile(0),Tile(0)],
             [Tile(0),Tile(0),Tile(0),Tile(0)],
             [Tile(0),Tile(0),Tile(0),Tile(0)],
             [Tile(0),Tile(0),Tile(0),Tile(0)]]

    var vc: ViewController? = nil
    var emptys: [(row: Int, col: Int)] {
        var tmp = [(row: Int, col: Int)]()
        for row in 0..<4 {
            for col in 0..<4 {
                if b[row][col].num == 0 {
                    tmp.append((row: row, col: col))
                }
            }
        }
        return tmp
    }
    var description: String {
        return String(describing: self.b.map { $0.map { $0.num } })
    }

    convenience init(on vc: ViewController) {
        self.init()

        self.vc = vc

        if let oldBoxes = CoreDataHandler.checkForBoxes() {
            b = oldBoxes.map { $0.map { Tile($0) } }
            vc.increaseScore(by: CoreDataHandler.checkForScore()!)
            checkForGameOver()
        } else {
            srandom(UInt32(time(nil)))
            let first = arc4random() % 16
            var second = arc4random() % 16
            while second == first {
                second = arc4random() % 16
            }

            let firstInt = Int(first)
            let secondInt = Int(second)

            let firstTileValue =  arc4random() %  10 != 0 ? BASE : BASE*BASE
            let secondTileValue = arc4random() %  10 != 0 ? BASE : BASE*BASE
            
            b[firstInt/4][firstInt%4] = Tile(firstTileValue)
            b[secondInt/4][secondInt%4] = Tile(secondTileValue)
        }

        showAllTiles()
    }

    func showAllTiles() {
        for (i, row) in b.enumerated() {
            for (j, e) in row.enumerated() {
                if e.num != 0 {
                    vc?.showTile(e)
                    e.create(withFrame: vc!.tileFrames[i][j])
                }
            }
        }
    }

    convenience init(_ b: [[Tile]]) {
        self.init()

        self.b = b.map { $0.map { Tile($0.num) } }
    }

    func testFullBoard() {
        b = [[Tile(2),Tile(4),Tile(2),Tile(4)],
             [Tile(4),Tile(2),Tile(4),Tile(2)],
             [Tile(2),Tile(4),Tile(2),Tile(4)],
             [Tile(0),Tile(4),Tile(2),Tile(4)]]
        showAllTiles()
    }

    func clear() {
        for row in b {
            for tile in row {
                tile.removeFromSuperview()
            }
        }
    }

    func right() {
        moveRight()
        mergeRight()
        moveRight()
    }

    func moveRight() {
        for i in 0..<4 {
            for j in [2,1,0] {
                if b[i][j].num != 0 && b[i][j+1].num == 0 {
                    var k = j
                    while k+1 < 4 && b[i][k+1].num == 0 {
                        k += 1
                    }
                    vc?.animateMove(fromRow: i, toRow: i, fromCol: j, toCol: k)
                    b[i][k] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }

    func mergeRight() {
        for i in 0..<4 {
            for j in [2,1,0] {
                if b[i][j].num != 0 && b[i][j].num == b[i][j+1].num {
                    vc?.animateMove(fromRow: i, toRow: i, fromCol: j, toCol: j+1)
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
            for j in 0..<4 {
                if b[i][j].num != 0 && b[i+1][j].num == 0 {
                    var k = i
                    while k+1 < 4 && b[k+1][j].num == 0 {
                        k += 1
                    }
                    vc?.animateMove(fromRow: i, toRow: k, fromCol: j, toCol: j)
                    b[k][j] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }

    func mergeDown() {
        for i in [2,1,0] {
            for j in 0..<4 {
                if b[i][j].num != 0 && b[i][j].num == b[i+1][j].num {
                    vc?.animateMove(fromRow: i, toRow: i+1, fromCol: j, toCol: j)
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
        for i in 0..<4 {
            for j in 1...3 {
                if b[i][j].num != 0 && b[i][j-1].num == 0 {
                    var k = j
                    while k-1 >= 0 && b[i][k-1].num == 0 {
                        k -= 1
                    }
                    vc?.animateMove(fromRow: i, toRow: i, fromCol: j, toCol: k)
                    b[i][k] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }

    func mergeLeft() {
        for i in 0..<4 {
            for j in 1...3 {
                if b[i][j].num != 0 && b[i][j].num == b[i][j-1].num {
                    vc?.animateMove(fromRow: i, toRow: i, fromCol: j, toCol: j-1)
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
        for i in 1...3 {
            for j in 0..<4 {
                if b[i][j].num != 0 && b[i-1][j].num == 0 {
                    var k = i
                    while k-1 >= 0 && b[k-1][j].num == 0 {
                        k -= 1
                    }
                    vc?.animateMove(fromRow: i, toRow: k, fromCol: j, toCol: j)
                    b[k][j] = b[i][j]
                    b[i][j] = Tile(0)
                }
            }
        }
    }

    func mergeUp() {
        for i in 1...3 {
            for j in 0..<4 {
                if b[i][j].num != 0 && b[i][j].num == b[i-1][j].num {
                    vc?.animateMove(fromRow: i, toRow: i-1, fromCol: j, toCol: j)
                    b[i-1][j].increment()
                    vc?.increaseScore(by: b[i-1][j].num)
                    b[i][j].removeFromSuperview()
                    b[i][j] = Tile(0)
                }
            }
        }
    }

    func insertNewTile() {
        srandom(UInt32(time(nil)))
        let tuple = emptys[Int(arc4random()) % emptys.count]
        b[tuple.row][tuple.col] = Tile(BASE)
        vc!.showTile(b[tuple.row][tuple.col])
        b[tuple.row][tuple.col].create(withFrame: vc!.tileFrames[tuple.row][tuple.col])
        // could generate BASE * BASE tiles also

        if emptys.count == 0 {
            checkForGameOver()
            return
        }
    }

    func checkForGameOver() {
        let fakeBoard = Board(b)

        fakeBoard.right()
        if !equals(fakeBoard) {
            return
        }

        fakeBoard.down()
        if !equals(fakeBoard) {
            return
        }

        fakeBoard.left()
        if !equals(fakeBoard) {
            return
        }

        fakeBoard.up()
        if !equals(fakeBoard) {
            return
        }

        vc!.gameOver()
    }

    func equals(_ b2: Board) -> Bool {
        for i in 0..<4 {
            for j in 0..<4 {
                if b[i][j].num != b2.b[i][j].num {
                    return false
                }
            }
        }

        return true
    }

    func equals(_ b2: [[Tile]]) -> Bool {
        for i in 0..<4 {
            for j in 0..<4 {
                if b[i][j].num != b2[i][j].num {
                    return false
                }
            }
        }

        return true
    }

    func save() {
        print("saving")
        CoreDataHandler.saveBoard(b, withScore: vc!.score)
        print("saved")
    }
}
