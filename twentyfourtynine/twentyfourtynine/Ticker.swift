//
//  Ticker.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 1/30/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class Ticker: UIView {
    var ticks: Int = 0
    let label = UILabel()
    var mod0Frame: CGRect? = nil
    var mod1Frame: CGRect? = nil
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    convenience init() {
        self.init()
        configureLabel()
    }
    
    func configureLabel() {
        label.text = String(ticks)
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        label.textAlignment = .center
        addSubview(label)
    }
    
    func configureModFrames() {
        mod0Frame = frame
        mod1Frame = self.frame.offsetBy(dx: self.superview!.frame.width - 80, dy: 0)
    }
    
    func tock() {
        if mod0Frame == nil || mod1Frame == nil {
            configureModFrames()
        }
        ticks += 1
        label.text = String(ticks)
        animateTock()
        print(ticks)
    }
    
    func animateTock() {
        if ticks % 2 == 1 {
            UIView.animate(withDuration: 0.2, animations: {
                self.frame = self.mod1Frame!
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.frame = self.mod0Frame!
            })
        }
    }

}
