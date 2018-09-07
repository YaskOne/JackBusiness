//
//  ProductsViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/23/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel

class StocksOverviewViewController: UIViewController {

    var categoriesOverviewTable: CategoriesOverviewTableViewController?
    var productsOverviewTable: ProductsOverviewTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        categoriesOverviewTable?.setUp()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CategoriesOverviewTableSegue") {
            categoriesOverviewTable = segue.destination as? CategoriesOverviewTableViewController
            categoriesOverviewTable?.delegate = self
        }
        if (segue.identifier == "ProductsOverviewTableSegue") {
            productsOverviewTable = segue.destination as? ProductsOverviewTableViewController
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        categoriesOverviewTable?.setUp()
    }
}

extension StocksOverviewViewController: CategorySelectedDelegate {
    
    func categorySelected(category: JKCategory) {
        productsOverviewTable?.categoryId = category.id
    }
    
}
