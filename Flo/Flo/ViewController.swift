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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushButtonPressed(_ pushButton: PushButton) {
        if pushButton.isAddButton {
            counterView.count += 1
        } else {
            if counterView.count > 0 {
                counterView.count -= 1
            }
        }
        counterLabel.text = String(counterView.count)
    }
    
}

