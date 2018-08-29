//
//  BusinessDashboardViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/22/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel

class BusinessDashboardViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var productsOrderTable: ProductsOrderTableViewController?
    var orderTable: OrdersTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = JKSession.shared.business?.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderTableSegue") {
            orderTable = segue.destination as? OrdersTableViewController
            orderTable?.delegate = self
        }
        if (segue.identifier == "ProductOrderTableSegue") {
            productsOrderTable = segue.destination as? ProductsOrderTableViewController
        }
    }

    @IBAction func refreshTapped(_ sender: Any) {
        orderTable?.setUp()
    }
}

extension BusinessDashboardViewController: OrderSelectDelegate {

    func orderSelected(order: JKOrder) {
        productsOrderTable?.productIds = order.productIds
    }

}
