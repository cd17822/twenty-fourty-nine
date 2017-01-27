//
//  Tile.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 1/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class Tile: UIView {
    var number: Int = 0
    
    convenience init(_ i: Int) {
        self.init()
        number = i
        layer.cornerRadius = 5
        backgroundColor = UIColor.red
    }
    
    func create(withFrame f: CGRect) {
        frame = CGRect(x: f.minX + f.width/2, y: f.minY + f.height/1.9, width: 0, height: 0)
        print(self.frame)
        UIView.animate(withDuration: 0.2*AC, animations: {
            self.frame = f
            print(self.frame)
        })
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
