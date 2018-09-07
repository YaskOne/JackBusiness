//
//  ViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/5/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import GoogleMaps
import GooglePlaces
import AWSUserPoolsSignIn
import AWSAuthUI

class AuthentificationViewController: UIViewController {

    @IBOutlet weak var businessEmail: UITextField!
    @IBOutlet weak var businessPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleKeyboardVisibility()
        handleKeyboardOffset()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ sender: Any) {
    }
    
    @IBAction func createBusinessTapped(_ sender: Any) {
    }

    @IBAction func loginBusiness(_ sender: Any) {
        if let email = businessEmail.text,
            let password = businessPassword.text {
            JKMediator.logBusiness(email: email, password: password, success: { business in
                JKSession.shared.business = business
                
                let vc = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }, failure: {
                
            })
        }
    }
}

extension AuthentificationViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        loginButton.isEnabled = textField.text != ""
    }
    
}
