//
//  ViewController.swift
//  MGAuthenticator
//
//  Created by lm2343635 on 07/20/2018.
//  Copyright (c) 2018 lm2343635. All rights reserved.
//

import UIKit
import MGAuthenticator

class ViewController: UIViewController {

    @IBOutlet weak var bometricsType: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bometricsType.text = "\(MGAuthenticator.shared.biometricsType)"
    }

    @IBAction func bometricsAuthenticate(_ sender: Any) {
        MGAuthenticator.shared.authenticate { (success) in
            DispatchQueue.main.async {
                self.resultLabel.text = success ? "Success" : "Failed"
            }
        }
        
    }
    
}

