//
//  CreateCategoryViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/11/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

class CreateCategoryViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    var validateButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validateButton = UIBarButtonItem(title: AULocalized.string("validate_action"), style: .plain, target: self, action: #selector(validateTapped))
        navigationItem.rightBarButtonItem = validateButton
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func validateTapped() {
        if nameInput.text != nil && nameInput.text != "" {
            validateButton?.isEnabled = false
            JKMediator.createCategory(name: nameInput.text!, businessId: JKSession.shared.business!.id, success: { (_) in
                
                self.navigationController?.popViewController(animated: true)
                self.validateButton?.isEnabled = true
            }, failure: {
                self.validateButton?.isEnabled = true
            })
        }
        
    }
    
}
