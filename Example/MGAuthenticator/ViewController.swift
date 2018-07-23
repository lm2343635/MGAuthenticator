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

    @IBOutlet weak var bometricsTypeLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var passcodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bometricsTypeLabel.text = MGAuthenticator.shared.biometricsType.name
        passcodeLabel.text = MGAuthenticator.shared.passcodeSet ? "set" : "not set"
    }

    @IBAction func bometricsAuthenticate(_ sender: Any) {
        MGAuthenticator.shared.authenticateWithBiometrics(reason: "Test") { (success, error) in
            DispatchQueue.main.async {
                self.resultLabel.text = success ? "Success" : "Failed"
            }
            
            if !success {
                self.showAlert(title: "Error", content: error.message)
            }
        }
        
    }
    
    @IBAction func passcodeAuthenticate(_ sender: Any) {
        MGAuthenticator.shared.authenticateWithPasscode {
            DispatchQueue.main.async {
                self.resultLabel.text = "Success"
            }
        }
    }
    
    @IBAction func setPasscode(_ sender: Any) {
        MGAuthenticator.shared.setPasscode { passcode in
            self.showAlert(title: "Passcode set", content: passcode)
            self.passcodeLabel.text = "set"
        }
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
