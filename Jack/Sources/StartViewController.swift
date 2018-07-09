//StartViewController
//  StartViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 07/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let placeStoryboard = UIStoryboard(name: "Place", bundle: nil)

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let controller = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
