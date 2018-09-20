//
//  CreateCategoryViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/11/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

class CreateCategoryViewController: UIViewController {

    @IBOutlet weak var nameInput: AUFormLabeledField?
    var validateButton: UIBarButtonItem?
    @IBOutlet weak var navigationBar: AUNavigationBar!
    
    var category: JKCategory? {
        didSet {
            setUpCategory()
        }
    }
    
    func setUpCategory() {
        guard let category = category else {
            return
        }
        
        nameInput?.text = category.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.rightAction = {
            self.validateTapped()
        }
        
        setUpCategory()
        handleKeyboardVisibility()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func validateTapped() {
        guard nameInput?.text != nil && nameInput?.text != "" else {
            return
        }
        validateButton?.isEnabled = false
        
        if category == nil {
            JKMediator.createCategory(name: nameInput!.text!, businessId: JKSession.shared.business!.id, success: { (_) in
                
                self.navigationController?.popViewController(animated: true)
                self.validateButton?.isEnabled = true
            }, failure: {
                self.validateButton?.isEnabled = true
            })
        } else {
            JKMediator.updateCategory(id: category!.id, name: nameInput!.text!, success: {
                
                self.navigationController?.popViewController(animated: true)
                self.validateButton?.isEnabled = true
            }, failure: {
                self.validateButton?.isEnabled = true
            })
        }
    }
    
}
