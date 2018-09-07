//
//  StartViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/22/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let authStoryboard = UIStoryboard(name: "Authentification", bundle: nil)

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        if JKSession.shared.businessId == 0 {
            let controller = authStoryboard.instantiateViewController(withIdentifier: "AuthentificationViewController")
            navigationController?.pushViewController(controller, animated: false)
        } else {
            let controller = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            navigationController?.pushViewController(controller, animated: false)
        }
    }

}
