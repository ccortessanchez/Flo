//
//  ViewController.swift
//  Flo
//
//  Created by Carlos Cortés Sánchez on 25/09/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.count)
    }

    @IBAction func pushButtonPressed(_ pushButton: PushButton) {
        if pushButton.isAddButton {
            if counterView.count != 8 {
                counterView.count += 1
            }
        } else if counterView.count > 0{
            counterView.count -= 1
        }
        counterLabel.text = String(counterView.count)
    }
    
}

