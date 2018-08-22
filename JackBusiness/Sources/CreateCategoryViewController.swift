//
//  CreateCategoryViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/11/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

class CreateCategoryViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .plain, target: self, action: #selector(validateTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func validateTapped() {
        if nameInput.text != nil && nameInput.text != "" {
            JKMediator.createCategory(name: nameInput.text!, businessId: JKSession.shared.business!.id, success: { (_) in
                
                self.navigationController?.popViewController(animated: true)
            }, failure: {})
        }
        
    }
    
}
