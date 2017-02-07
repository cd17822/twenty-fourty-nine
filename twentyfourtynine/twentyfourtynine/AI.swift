//
//  AI.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 2/2/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

// THIS AI WAS ADAPTED FROM AN EARLIER WORK OF MINE WRITTEN IN PYTHON
// https://github.com/cd17822/Tkinter-Ventures/blob/master/2048%20%26%20AI.py

import Foundation
import UIKit

class AI {
    enum moveType {
        case nothing, shimmyDown, downNeedUp, leftAfterDown, leftNeedUp, rightNeedUp, leftNeedRight
    }
    
    var vc: ViewController!
    var b: [[Tile]] { return B.b }
    var lastMove: moveType = .nothing
    var on = false
    
    convenience init(on vc: ViewController ) {
        self.init()
        
        self.vc = vc
    }
    
    func toggle() {
        on = !on
        if on {
            AC = 0.6
            decide()
        } else {
            AC = 1
        }
    }
    
    func disable() {
        on = false
    }

    func goRight() {
        UIView.animate(withDuration: 0.1*AC, animations: {
            self.vc.swipe(.right)
        }, completion: { _ in
            self.decide()
        })
        lastMove = .nothing
    }
    
    func goLeft() {
        UIView.animate(withDuration: 0.1*AC, animations: {
            self.vc.swipe(.left)
        }, completion: { _ in
            self.decide()
        })
        lastMove = .nothing
    }
    
    func goUp() {
        UIView.animate(withDuration: 0.1*AC, animations: {
            self.vc.swipe(.up)
        }, completion: { _ in
            self.decide()
        })
        lastMove = .nothing
    }
    
    func goDown() {
        UIView.animate(withDuration: 0.1*AC, animations: {
            self.vc.swipe(.down)
        }, completion: { _ in
            self.decide()
        })
        lastMove = .nothing
    }
    
    func checkMergeUp() -> Bool {
        let fakeBoard = Board(b)
        let emptysCount1 = fakeBoard.emptys.count
        fakeBoard.up()
        return fakeBoard.emptys.count != emptysCount1
    }
    
    func checkMergeDown() -> Bool {
        let fakeBoard = Board(b)
        let emptysCount1 = fakeBoard.emptys.count
        fakeBoard.down()
        return fakeBoard.emptys.count != emptysCount1
    }
    
    func checkMergeLeft() -> Bool {
        let fakeBoard = Board(b)
        let emptysCount1 = fakeBoard.emptys.count
        fakeBoard.left()
        return fakeBoard.emptys.count != emptysCount1
    }
    
    func checkMergeRight() -> Bool {
        let fakeBoard = Board(b)
        let emptysCount1 = fakeBoard.emptys.count
        fakeBoard.right()
        return fakeBoard.emptys.count != emptysCount1
    }
    
    func checkUpMove() -> Bool {
        let fakeBoard = Board(b)
        fakeBoard.up()
        return !fakeBoard.equals(b)
    }
    
    func checkDownMove() -> Bool {
        let fakeBoard = Board(b)
        fakeBoard.down()
        return !fakeBoard.equals(b)
    }
    
    func checkLeftMove() -> Bool {
        let fakeBoard = Board(b)
        fakeBoard.left()
        return !fakeBoard.equals(b)
    }
    
    func checkRightMove() -> Bool {
        let fakeBoard = Board(b)
        fakeBoard.right()
        return !fakeBoard.equals(b)
    }
    
    func decide() {
        //last move cases
        if !on {
            lastMove = .nothing
            print("ai off")
        } else if lastMove == .shimmyDown && b[0][3].num == 0 {
            goRight()
            print( "completed the shimmy")
        } else if lastMove == .shimmyDown && b[0][3].num != 0 && b[0][3].num == b[1][3].num {
            goDown()
            //completed the shimmy
        } else if lastMove == .shimmyDown && b[0][3].num != 0 && b[0][3].num != b[1][3].num {
            goUp()
            //completed the shimmy
        } else if lastMove == .downNeedUp && b[0][3].num != 0 {
            goLeft()
            lastMove = .leftAfterDown
            print( "left after down")
        } else if lastMove == .leftAfterDown && b[0][3].num != 0 {
            goLeft()
            lastMove = .leftAfterDown
            print( "still left after down")
        } else if lastMove == .leftAfterDown && b[0][3].num == 0 {
            goUp()
            print( "up after left after down")
        } else if lastMove == .downNeedUp && (checkMergeUp() == true || checkUpMove() == true) {
            goUp()
            print( "down needed up")
        } else if lastMove == .leftNeedUp && (checkMergeUp() == true || checkUpMove() == true) {
            goUp()
            print( "left needed up")
        } else if lastMove == .rightNeedUp && (checkUpMove() == true || checkMergeUp() == true) {
            goUp()
            print( "right needed up")
            //shimmy cases
        } else if shimmyDown() == true {
            goDown()
            lastMove = .shimmyDown
            print( "shimmied down")
        } else if needaShimmy() == true && (checkLeftMove() == true || checkMergeLeft() == true) {
            goLeft()
            //lastMove = .shimmy
            print( "shimmied left")
        } else if needaShimmy() == true && (checkRightMove() == true || checkMergeRight() == true) {
            goRight()
            //lastMove = .shimmy
            print( "shimmied right")
            //last lastmove case (shimmy should override this)
        } else if lastMove == .leftNeedRight && (checkRightMove() == true || checkMergeRight() == true) {
            goRight()
            print( "left needed right")
        } else if topRightMerge() == true {
            goUp()
            print( "top right merge")
        } else if mergeRightBeforeUp() == true && (checkRightMove() == true || checkMergeRight() == true) {
            goRight()
            print( "go right for a merge instead of up")
        } else if goUpNotTopMerge() == true {
            goUp()
            print( "go up before merging the top")
        } else if slideRightBeforeUpMerge() == true && (checkRightMove() == true || checkMergeRight() == true) {
            goRight()
            print( "go right instead of up because you dont want a bad filler")
        } else if topRightCorrection() == true {
            goRight()
            lastMove = .rightNeedUp
            print( "top right correction")
        } else if upMergeToFrozen() == true || upMergeToTopFrozen() == true {
            goUp()
            print( "up merge to a frozen row")
        } else if topRowMergeCheck() == true {
            goRight()
            print( "merge the top row")
            //second row frozen cases
        } else if checkMergeRight() == true && secondRowGradient() == true {
            goRight()
            print( "right because top 2 rows are frozen && secrow gradient")
        } else if secondRowGradient() == true && checkRightMove() == true {
            goRight()
        } else if leftAndUp() == true && freezeCheck(1) == true {
            goLeft()
            lastMove = .leftNeedUp
            print( "beginning of left && up")
            //} else if checkMergeUp() == true || checkUpMove() == true { //new
            //   goUp()
        } else if rightAndUp() == true && freezeCheck(1) == true {
            goRight()
            print( "hypo'd right to go up")
        } else if checkMergeLeft() == true && freezeCheck(1) == true {
            goLeft()
            print( "left cuz second row is frozen")
            //general cases
        } else if rightAndUp() == true && freezeCheck(0) == true && oneZeroWrong() == false {
            goRight()
            print( "hypo'd right to go up")
        } else if leftAndUp() == true && freezeCheck(0) == true {
            goLeft()
            lastMove = .leftNeedUp
            print( "beginning of left && up")
        } else if rightAndUp() == true && freezeCheck(0) == true {
            goRight()
            print( "hypo'd right to go up")
        } else if oneZeroWrong() == true && b[1][0].num == b[2][0].num {
            goUp()
            print( "one zero correction")
        } else if checkMergeLeft() == true && topRowGradient() == true {
            goLeft()
            print( "left merge")
        } else if checkLeftMove() == true && topRowGradient() == true {
            goLeft()
        } else if checkMergeUp() == true {
            goUp()
            print( "up merge")
        } else if checkMergeRight() == true {
            goRight()
            print( "right merge")
        } else if checkUpMove() == true {
            goUp()
            print( "up move")
        } else if checkRightMove() == true {
            goRight()
            print( "right move")
        } else if freezeCheck(0) == true && (checkLeftMove() == true || checkMergeLeft() == true) {
            goLeft()
            print( "left move because needed && frozen top row")
        } else if checkLeftMove() == true {
            goLeft()
            lastMove = .leftNeedRight
            print( "left because ab&&oned")
        } else if rightColumnFullCheck() == true && checkDownMove() == true {
            goDown()
            lastMove = .downNeedUp
            print( "down move because right is filled")
        } else {
            goDown()
            lastMove = .downNeedUp
            print( "shit gotta go down")
        }
    }
    
    //functions for AI from here down
    func rightColumnFullCheck() -> Bool {
        if (b[0][3].num != 0 &&
            b[1][3].num != 0 &&
            b[2][3].num != 0 &&
            b[3][3].num != 0 &&
            b[3][3].num != b[2][3].num &&
            b[1][3].num != b[2][3].num &&
            b[1][3].num != b[0][3].num) {
            return true
        }
        return false
    }
    
    func greatestTile() -> Int {
        var bigBoy = 0 //greatestTile
        for a in [0, 1, 2] {
            for i in [0, 1, 2] {
                if b[a][i].num > bigBoy {
                    bigBoy = b[a][i].num
                }
            }
        }
        return bigBoy
    }
    
    func topRightCorrection() -> Bool { //if [1][2] equals topRight && [1][3] is 0 go right then up
        if (b[1][2].num != 0 &&
            b[1][2].num == b[0][3].num &&
            b[1][3].num == 0 &&
            b[1][1].num != b[1][2].num) {
            return true
        }
        return false
    }
    
    func topRowMergeCheck() -> Bool{ //are there tiles in the top row that can merge
        if ((b[0][0].num == b[0][1].num && b[0][0].num != 0) ||
            (b[0][1].num == b[0][2].num && b[0][2].num != 0) ||
            (b[0][2].num == b[0][3].num && b[0][2].num != 0) ||
            (b[0][0].num == b[0][3].num && b[0][0].num != 0 && b[0][1].num == 0 && b[0][2].num == 0) ||
            (b[0][0].num == b[0][2].num && b[0][0].num != 0 && b[0][1].num == 0) ||
            (b[0][1].num == b[0][3].num && b[0][1].num != 0 && b[0][2].num == 0)) {
            return true
        }
        return false
    }
    
    func freezeCheck(_ rowNum: Int) -> Bool { //rowNum checks for full unmergeable rows at the index && above
        var counter = 0
        var currRow = 0
        
        while currRow <= rowNum {
            if (b[currRow][0].num != 0 &&
                b[currRow][1].num != 0 &&
                b[currRow][2].num != 0 &&
                b[currRow][3].num != 0 && //no zeros
                b[currRow][0].num != b[currRow][1].num &&
                b[currRow][1].num != b[currRow][2].num &&
                b[currRow][2].num != b[currRow][3].num) { //no merge possibilities
                counter += 1
            }
            currRow += 1
        }
        
        return counter-1 == rowNum
    }
    
    func leftAndUp() -> Bool {
        var freezedRow = -1
        for a in [0, 1, 2] {
            if freezeCheck(a) == true {
                freezedRow += 1
            }
        }
        
        if freezedRow >= 0 {
            let fakeBoard = Board(b)
            fakeBoard.left()
            
            for i in [0, 1, 2, 3] {
                if fakeBoard.b[freezedRow][i].num == fakeBoard.b[freezedRow+1][i].num {
                    if b[freezedRow][i].num != b[freezedRow+1][i].num {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func rightAndUp() -> Bool {
        var freezedRow = -1
        
        for a in [0, 1, 2] {
            if freezeCheck(a) == true {
                freezedRow += 1
            }
        }
        
        if freezedRow >= 0 {
            let fakeBoard = Board(b)
            fakeBoard.right()
            
            for i in [0, 1, 2, 3] {
                if fakeBoard.b[freezedRow][i].num == fakeBoard.b[freezedRow+1][i].num {
                    if b[freezedRow][i].num != b[freezedRow+1][i].num {
                        return true
                    }
                }
            }
        }
    
        return false
    }
    
    func upMergeToFrozen() -> Bool {
        var freezedRow = -1
        for a in [0, 1, 2, 3] {
            if freezeCheck(a) == true {
                freezedRow += 1
            } else {
                break
            }
        }
        
        if freezedRow == 2 {
            for i in [0, 1, 2, 3] {
                if (b[freezedRow][i].num == b[freezedRow+1][i].num) {
                    return true
                }
            }
        } else if freezedRow==1 {
            for i in [0, 1, 2, 3] {
                if (b[freezedRow][i].num == b[freezedRow+1][i].num ||
                    b[freezedRow][i].num == b[freezedRow+2][i].num &&
                    b[freezedRow+1][i].num == 0) {
                    return true
                }
            }
        } else if freezedRow==0 {
            for i in [0, 1, 2, 3] {
                if (b[freezedRow][i].num == b[freezedRow+1][i].num ||
                    b[freezedRow][i].num == b[freezedRow+2][i].num &&
                    b[freezedRow+1][i].num == 0 ||
                    b[freezedRow][i].num == b[freezedRow+3][i].num &&
                    b[freezedRow+1][i].num == 0  && b[freezedRow+2][i].num == 0) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func upMergeToTopFrozen() -> Bool {
        for a in [0, 1, 2, 3] {
            if b[0][a].num == b[1][a].num && b[0][a].num != 0 {
                return true //just incase upmergetofrozen doesnt work
            }
        }
        
        return false
    }
    
    func mergeRightBeforeUp() -> Bool { //jamisons first scenario where 00 10 && 11 are the same || same thing over 1
        if (b[0][0].num != 0 &&
            b[0][0].num == b[1][0].num &&
            b[0][0].num == b[1][1].num &&
            b[0][1].num == b[0][0].num*2) {
            return true
        } else if (b[0][1].num != 0 &&
            b[0][1].num == b[1][1].num &&
            b[0][1].num == b[1][2].num &&
            b[0][2].num == b[1][1].num*2) {
            return true
        }
        
        return false
    }
    
    func slideRightBeforeUpMerge() -> Bool { //jamisons second scenario where you should make sure theres a clear column before a 00 && 10 merge
        if (b[0][0].num == b[1][0].num &&
            b[0][0].num >= 0 &&
            freezeCheck(0) == true &&
            b[2][0].num != 0 &&
            b[3][0].num != 0) {
            return true
        }
        
        return false
    }
    
    func topRightMerge() -> Bool { //you always want to make the 03 higher
        if ((b[0][3].num == b[1][3].num ||
            (b[0][3].num == b[2][3].num  && b[1][3].num == 0) ||
            (b[0][3].num == b[3][3].num && b[1][3].num == 0 && b[2][3].num == 0)) &&
            b[0][3].num != 0) {
            return true
        }
        
        return false
    }
    
    func goUpNotTopMerge() -> Bool {
        if b[0][0].num == b[0][1].num && b[1][1].num == b[0][0].num && b[0][0].num != 0 {
            return true
        } else if b[0][1].num == b[0][2].num && b[0][2].num == b[1][1].num && b[0][1].num != 0 {
            return true
        } else if b[0][2].num == b[0][3].num && b[0][3].num == b[1][2].num && b[0][2].num != 0 {
            return true
        } else {
            return false
        }
    }
    
    func needaShimmy() -> Bool {
        if b[0][3].num < b[0][2].num / 32 && b[0][3].num != 0 {
            return true
        }
        
        return false
    }
    
    func shimmyDown() -> Bool {
        if needaShimmy() {
            let fakeBoard = Board(b)
            fakeBoard.down()
            fakeBoard.right()
            
            return fakeBoard.b[0][3].num == b[0][2].num
        }
        return false
    }
    
    func topRowGradient() -> Bool { //gradient && frozen
        if b[0][3].num > b[0][2].num && b[0][2].num > b[0][1].num && b[0][1].num > b[0][0].num {
            if b[0][0].num != 0 && b[0][1].num != 0 && b[0][2].num != 0 && b[0][3].num != 0 {
                return true
            }
        }
        return false
    }
    
    func secondRowGradient() -> Bool {
        if b[1][3].num < b[1][2].num && b[1][2].num < b[1][1].num && b[1][1].num < b[1][0].num {
            if b[1][0].num != 0 && b[1][1].num != 0 && b[1][2].num != 0 && b[1][3].num != 0 {
                return true
            }
        }
        return false
    }
    
    func oneZeroWrong() -> Bool {
        if topRowGradient() {
            if b[1][0].num < b[1][1].num && b[1][0].num != 0 {
                return true
            }
        }
        return false
    }
    
    
}
