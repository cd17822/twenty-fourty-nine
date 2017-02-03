//
//  AI.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 2/2/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import UIKit

class AI {
    var vc: ViewController!
    
    convenience init(on vc: ViewController ) {
        self.init()
        
        self.vc = vc
    }
    
    func start() {
        AC = 0.5
        r()
    }
    
    func r() {
        UIView.animate(withDuration: 0.1*AC, animations: {
        self.vc.swipe(.Right)
        }, completion: { _ in
        self.vc.swipe(.Down)
        })
    }
}
