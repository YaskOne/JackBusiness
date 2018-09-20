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

    @IBOutlet weak var nameInput: AUFormLabeledField!
    @IBOutlet weak var priceInput: AUFormLabeledField!
    @IBOutlet weak var categoryInput: AUFormLabeledField!
    @IBOutlet weak var urlInput: AUFormLabeledField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBar: AUNavigationBar!
    
    var product: JKProduct?
    
    var categoryTable: CategoriesTableViewController?
    var categoryId: UInt = 0
    
    var formFields: [AUFormLabeledField] {
        return   [
            self.nameInput,
            priceInput,
            categoryInput,
            urlInput
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.rightAction = {
            self.validateTapped()
        }
        
        nameInput.initialize() {
            return self.nameInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        priceInput.initialize() {
            return self.priceInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        categoryInput.initialize() {
            return self.categoryInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        urlInput.initialize(mandatory: false)
        
        setUpProduct()
        handleKeyboardVisibility()
    }
    
    func setUpProduct() {
        guard let product = product else {
            return
        }
        nameInput.text = product.name
        priceInput.text = product.price.description
        categoryInput.text = JKCategoryCache.shared.getItem(id: product.categoryId)?.name ?? ""
        nameInput.text = product.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCategoryTapped(_ sender: Any) {
        categoryTable = homeStoryboard.instantiateViewController(withIdentifier: "CategoriesTableViewController") as? CategoriesTableViewController
        categoryTable?.delegate = self
        self.navigationController?.pushViewController(categoryTable!, animated: true)
    }
    
    @objc func validateTapped() {
        for field in formFields {
            if field.formStatus == .invalid
                || (field.formStatus == .none && field.mandatory) {
                return
            }
        }
        guard let text = priceInput.text else {
            return
        }
        let price = ((text.replacingOccurrences(of: ",", with: ".") as NSString).floatValue * 100).rounded() / 100
        
        self.navigationBar.leftButton.isEnabled = false
        if product == nil {
            JKMediator.createProduct(name: nameInput.text!, price: price, category: categoryId, url: urlInput.text!, businessId: JKSession.shared.business!.id, success: { (_) in
                self.navigationController?.popViewController(animated: true)
                self.navigationBar.leftButton.isEnabled = true
            }, failure: {
                self.navigationBar.leftButton.isEnabled = true
            })
        } else {
            JKMediator.updateProduct(id: product!.id, name: nameInput.text!, price: price, category: categoryId, url: urlInput.text!, success: {
                self.navigationController?.popViewController(animated: true)
                self.navigationBar.leftButton.isEnabled = true
            }, failure: {
                self.navigationBar.leftButton.isEnabled = true
            })
        }
        
    }
}

extension CreateProductViewController: AUCellSelectedDelegate {
    func cellSelected(cell: AUTableViewCell) {
        if let category = (cell as? CategoryOverviewTableCell)?.category {
            categoryTable?.navigationController?.popViewController(animated: true)
            
            categoryInput.text = category.name
            categoryId = category.id
        }
    }
    
    func categorySelected(category: JKCategory) {
    }
}
