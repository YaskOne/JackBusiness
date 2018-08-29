//
//  CreateProductViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/11/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

enum RegisterProductFormField: Int {
    case name
    case price
    case category
    case url
}

class CreateProductViewController: UIViewController {

    @IBOutlet weak var nameLabel: AFormLabel!
    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var priveLabel: AFormLabel!
    @IBOutlet weak var priceInput: UITextField!
    
    @IBOutlet weak var categoryLabel: AFormLabel!
    @IBOutlet weak var categoryInput: UITextField!
    
    @IBOutlet weak var urlLabel: AFormLabel!
    @IBOutlet weak var urlInput: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var formFields: [RegisterProductFormField: AFormField] = {
        var fields: [RegisterProductFormField: AFormField] = [:]
        fields[.name] = AFormField(input: nameInput, label: nameLabel, defaultValue: "") {
            return self.nameInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        fields[.price] = AFormField(input: priceInput, label: priveLabel, defaultValue: "") {
            return self.priceInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        fields[.category] = AFormField(input: categoryInput, label: categoryLabel, defaultValue: "") {
            return self.categoryInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        fields[.url] = AFormField(input: urlInput, label: urlLabel, defaultValue: "", mandatory: false)
        return fields
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .plain, target: self, action: #selector(validateTapped))
        
        print(formFields.count)
        handleKeyboardVisibility()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func validateTapped() {
        for field in formFields {
            if field.value.formStatus == .invalid
                || (field.value.formStatus == .none && field.value.mandatory) {
                return
            }
        }
        JKMediator.createProduct(name: nameInput.text!, price: Int(priceInput.text!) ?? 1, category: Int(categoryInput.text!) ?? 1, url: urlInput.text!, businessId: JKSession.shared.business!.id, success: { (_) in
            self.navigationController?.popViewController(animated: true)
            
        }, failure: {})
        
    }
}
