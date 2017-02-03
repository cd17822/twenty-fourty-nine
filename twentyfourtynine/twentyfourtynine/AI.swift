//
//  AI.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 2/2/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation

class AI {
    var vc: ViewController!
    
    convenience init(on vc: ViewController ) {
        self.init()
        
        self.vc = vc
    }
    
    func start() {
        r()
    }
    
    func r() {
        vc.swipe(.Right)
    }
}
