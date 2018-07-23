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
        
        bometricsType.text = MGAuthenticator.shared.biometricsType.name
    }

    @IBAction func bometricsAuthenticate(_ sender: Any) {
        MGAuthenticator.shared.authenticateWithBiometrics { (success, error) in
            DispatchQueue.main.async {
                self.resultLabel.text = success ? "Success" : "Failed"
            }
            
            if !success {
                self.showAlert(title: "Error", content: error.message)
            }
        }
        
    }
    
    @IBAction func passcodeAuthenticate(_ sender: Any) {
        present(MGPasscodeViewController(), animated: true)
        
    }
    
}

extension ViewController {
    
    func showAlert(title: String, content: String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title,
                                                    message: content,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel))
            self?.present(alertController, animated: true)
        }
        
    }
    
}
