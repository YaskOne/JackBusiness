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
    
    var productsOrderTable: ProductsOrderTableViewController?
    var orderTable: OrdersTableViewController?
    
    @IBOutlet weak var currentOrderPreview: UIView!
    @IBOutlet weak var statusActions: UIView!
    @IBOutlet weak var stateAction: UIView!
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var refuseButton: UIButton!
    
    @IBOutlet weak var waitingButton: UIButton!
    @IBOutlet weak var preparingButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var deliveredButton: UIButton!
    @IBOutlet weak var canceledButton: UIButton!
    
    @IBOutlet weak var currentOrderHeightConstrain: NSLayoutConstraint!
    
    var currentOrder: JKOrder? {
        didSet {
            currentOrderPreview.isHidden = currentOrder == nil
            
            if let order = currentOrder {
                orderLabel.text = "Commande \(order.id)"
                
                
                print("Status \(order.status)")
                print("State \(order.state)")
                statusActions.isHidden = order.status != .PENDING
                stateAction.isHidden = order.status == .PENDING
                
                acceptButton.isSelected = order.status == .ACCEPTED
                refuseButton.isSelected = order.status == .REJECTED
                
                waitingButton.isSelected = order.state == .WAITING
                preparingButton.isSelected = order.state == .PREPARING
                readyButton.isSelected = order.state == .READY
                deliveredButton.isSelected = order.state == .DELIVERED
                canceledButton.isSelected = order.state == .CANCELED
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currentOrder = nil
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
    
    @IBAction func acceptTapped(_ sender: Any) {
        updateOrder(status: JKOrderStatus.ACCEPTED.description)
    }
    
    @IBAction func refuseTapped(_ sender: Any) {
        updateOrder(status: JKOrderStatus.REJECTED.description)
    }
    
    @IBAction func waitingTapped(_ sender: Any) {
        updateOrder(state: JKOrderState.WAITING.description)
    }
    
    @IBAction func preparingTapped(_ sender: Any) {
        updateOrder(state: JKOrderState.PREPARING.description)
    }
    
    @IBAction func readyTapped(_ sender: Any) {
        updateOrder(state: JKOrderState.READY.description)
    }
    
    @IBAction func deliveredTapped(_ sender: Any) {
        updateOrder(state: JKOrderState.DELIVERED.description)
    }
    
    @IBAction func canceledTapped(_ sender: Any) {
        updateOrder(state: JKOrderState.CANCELED.description)
    }
    
    func updateOrder(status: String? = nil, state: String? = nil) {
        if let order = currentOrder {
            JKMediator.updateOrder(orderId: order.id, userId: order.userId, status: status, state: state, success: { 
                if let order = self.currentOrder {
                    self.currentOrder = JKOrderCache.shared.getItem(id: order.id)
                }
            }, failure: {})
        }
    }
}

extension BusinessDashboardViewController: OrderSelectDelegate {

    func orderSelected(order: JKOrder) {
        currentOrder = JKOrderCache.shared.getItem(id: order.id)
        productsOrderTable?.productIds = currentOrder?.productIds ?? []
    }

}
