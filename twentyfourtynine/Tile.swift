//
//  Tile.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 1/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class Tile: UIView {
    var num: Int = 0
    @IBOutlet weak var label: UILabel!
    
    convenience init(_ i: Int) {
        self.init()
        updateNum(i)
        layer.cornerRadius = 5
    }
    
    func create(withFrame f: CGRect) {
        frame = CGRect(x: f.minX + f.width/2, y: f.minY + f.height/1.9, width: 0, height: 0)
        UIView.animate(withDuration: 0.2*AC, animations: {
            self.frame = f
        })
    }
    
    func updateNum(_ i: Int) {
        num = i
        
        UIView.animate(withDuration: 0.2*AC, animations: {
            //label.text = "0"
            switch self.num {
            case 0: self.backgroundColor = UIColor.white
            case BASE: self.backgroundColor = UIColor.blue
            case Int(pow(Double(BASE), 2)): self.backgroundColor = UIColor.red
            default: self.backgroundColor = UIColor.black
            }
        })
    }
    
    func increment() {
        updateNum(num * BASE)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
