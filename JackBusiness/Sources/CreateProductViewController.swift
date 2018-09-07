//
//  CreateProductViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/11/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

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
    
    var categoryTable: CategoriesOverviewTableViewController?
    var categoryId: UInt = 0
    
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
    
    var validateButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)

        validateButton = UIBarButtonItem(title: AULocalized.string("validate_action"), style: .plain, target: self, action: #selector(validateTapped))
        navigationItem.rightBarButtonItem = validateButton
        
        print(formFields.count)
        handleKeyboardVisibility()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCategoryTapped(_ sender: Any) {
        categoryTable = homeStoryboard.instantiateViewController(withIdentifier: "CategoriesOverviewTableViewController") as? CategoriesOverviewTableViewController
        categoryTable?.delegate = self
        self.navigationController?.pushViewController(categoryTable!, animated: true)
    }
    
    @objc func validateTapped() {
        for field in formFields {
            if field.value.formStatus == .invalid
                || (field.value.formStatus == .none && field.value.mandatory) {
                return
            }
        }
        guard let text = priceInput.text else {
            return
        }
        let price = ((text.replacingOccurrences(of: ",", with: ".") as NSString).floatValue * 100).rounded() / 100
        
        self.validateButton?.isEnabled = false
        JKMediator.createProduct(name: nameInput.text!, price: price, category: categoryId, url: urlInput.text!, businessId: JKSession.shared.business!.id, success: { (_) in
            self.navigationController?.popViewController(animated: true)
            self.validateButton?.isEnabled = true
        }, failure: {
            self.validateButton?.isEnabled = true
        })
        
    }
}

extension CreateProductViewController: CategorySelectedDelegate {
    func categorySelected(category: JKCategory) {
        categoryTable?.navigationController?.popViewController(animated: true)
        
        categoryInput.text = category.name
        categoryId = category.id
        
        formFields[.category]?.checkFieldStatus()
    }
}
