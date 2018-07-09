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

class ViewController: UIViewController {

    @IBOutlet weak var businessIdText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JKNetwork.shared.server = "http://127.0.0.1:8080"
//        GMSServices.provideAPIKey("AIzaSyC2IT49iFLikS_ZU7-8HHTt8nt1GCisaO0")
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
        if let text = businessIdText.text, let id = Int(text) {
            JKMediator.fetchBusiness(ids: [id], success: { businesses in
                JKSession.shared.business = businesses[0]
                print("JKSession : \(businesses[0].id)")
                
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessViewController") as? BusinessViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }, failure: {})
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        loginButton.isEnabled = textField.text != ""
    }
    
}
