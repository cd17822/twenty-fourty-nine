//
//  CoreDataHandler.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 2/3/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler {
    static func checkForBoxes() -> [[Int]]? {
        var boards = [NSManagedObject]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedBoard")
        
        do {
            boards = try context.fetch(request) as! [NSManagedObject]
        } catch let error as NSError {
            print(error)
        }
        
        if boards.count > 0 {
            let board = boards[0]
            var nonEmptyBoard = false
            var boxes = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
            for i in 0..<16 {
                boxes[i/4][i%4] = board.value(forKey: "box\(i)") as! Int
                if boxes[i/4][i%4] != 0 {
                    nonEmptyBoard = true
                }
            }
            
            if nonEmptyBoard {
                return boxes
            }
        }else{
            print("found 0 saved boards")
        }
        
        return nil
    }
    
    static func checkForScore() -> Int? {
        var boards = [NSManagedObject]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedBoard")
        
        do {
            boards = try context.fetch(request) as! [NSManagedObject]
        } catch let error as NSError {
            print(error)
        }
        
        if boards.count > 0 {
           return boards[0].value(forKey: "score") as? Int
        }else{
            print("found 0 saved boards")
        }
        
        return nil
    }
    
    static func saveBoard(_ tiles: [[Tile]], withScore score: Int) {
        deletePastBoards()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "SavedBoard", in: context)
        let board_object = NSManagedObject(entity: entity!, insertInto: context)
        
        let boxNums = tiles.flatMap { $0 } .map { $0.num }
        print(boxNums)
        
        for (i, num) in boxNums.enumerated() {
            board_object.setValue(num, forKey: "box\(i)")
            print(board_object.value(forKey: "box\(i)") as! Int)
        }
        board_object.setValue(score, forKey: "score")
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func deletePastBoards() {
        var boards = [NSManagedObject]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedBoard")
        
        do {
            boards = try context.fetch(request) as! [NSManagedObject]
            for object in boards {
                context.delete(object)
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
