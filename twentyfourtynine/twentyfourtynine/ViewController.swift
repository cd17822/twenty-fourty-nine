//
//  ViewController.swift
//  twentyfourtynine
//
//  Created by Charles DiGiovanna on 1/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var background: UIView!
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
    var boxes = [UIView]()
    
    @IBOutlet weak var vertConstraint1: NSLayoutConstraint!
    @IBOutlet weak var vertConstraint2: NSLayoutConstraint!
    @IBOutlet weak var vertConstraint3: NSLayoutConstraint!
    @IBOutlet weak var horConstraint1: NSLayoutConstraint!
    @IBOutlet weak var horConstraint2: NSLayoutConstraint!
    @IBOutlet weak var horConstraint3: NSLayoutConstraint!
    var interBoxConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoxes()
        roundBoxes()
        initInterBoxConstraints()
        // updateInterBoxContraints() (viewDidAppear)
    }

    override func viewDidAppear(_ animated: Bool) {
        updateInterBoxContraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initBoxes() {
         boxes = [box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16]
    }
    
    func roundBoxes() {
        for box in boxes {
            box.layer.cornerRadius = 5
        }
    }

    func initInterBoxConstraints() {
        interBoxConstraints = [vertConstraint1,vertConstraint2,vertConstraint3,horConstraint1,horConstraint2,horConstraint3]
    }

    func updateInterBoxContraints() {
        for constraint in interBoxConstraints {
            constraint.constant = 11.0 * background.frame.width / 290 // 290.0 is the width of the background on an iPhone SE (where the constraints are best-looking)
        }
    }
}

