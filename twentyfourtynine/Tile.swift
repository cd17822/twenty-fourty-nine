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
    let label = UILabel()
    
    convenience init(_ i: Int) {
        self.init()
        updateNum(i)
        roundCorners()
    }
    
    func create(withFrame f: CGRect) {
        frame = CGRect(x: f.minX + f.width/2, y: f.minY + f.height/1.9, width: 1, height: 1)
        UIView.animate(withDuration: 0.2*AC, animations: {
            self.frame = f
            self.configureLabel() // doesnt really work
        })
    }
    
    func configureLabel() {
        label.text = String(num)
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir Next", size: 40)
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        label.textAlignment = .center
        addSubview(label)
    }
    
    func roundCorners() {
        layer.cornerRadius = 5
    }
    
    func updateNum(_ i: Int) {
        num = i
        
        UIView.animate(withDuration: 0.2*AC, animations: {
            self.label.text = String(self.num)
            
            let colorBasedOff = self.num == BASE ? BASE + 1 : self.num
            
            self.backgroundColor = UIColor(hue:0.73, saturation:0.45, brightness:0.97, alpha: 1 + (1 / 14) - (log2(CGFloat(BASE))/log2(CGFloat(colorBasedOff))))    
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
