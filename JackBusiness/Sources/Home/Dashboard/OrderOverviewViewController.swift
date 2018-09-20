//
//  OrderOverviewViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 9/19/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel
import ArtUtilities

class OrderOverviewViewController: UIViewController {
    
    var orderTable: ProductsOrderTableViewController?
    
    @IBOutlet weak var businessLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var commandLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var stateLabel: UILabel?
    
    @IBOutlet weak var countdownView: CountdownView?
    
    @IBOutlet weak var actionsHeight: NSLayoutConstraint?
    @IBOutlet weak var acceptActionView: UIView?
    @IBOutlet weak var statusActionView: UIView?
    
    var order: JKOrder? {
        didSet {
//            setUp()
        }
    }
    
    func setUp() {
        guard let order = order, let business = JKBusinessCache.shared.getItem(id: order.businessId) else {
            return
        }
        
        let date = order.pickupDate.formatDate(dateFormat: "yyyy-MM-dd")
        let time = order.pickupDate.formatDate(dateFormat: "HH:mm")
        
        businessLabel?.text = JKUserCache.shared.getItem(id: order.userId)?.name
        addressLabel?.text = business.address
        commandLabel?.text = "Total de la commande: \(order.price)€"
        dateLabel?.text = "Le \(date), à \(time)"
        countdownView?.value = order.pickupDate.minutesSinceNow()
        stateLabel?.text = order.status.description
        stateLabel?.textColor = order.status.color
        
//        orderTable?.productIds = order.productIds
        
        actionsHeight?.constant = order.status.rawValue >= JKOrderStatus.DELIVERED.rawValue ? 0 : 45
        acceptActionView?.isHidden = order.status != JKOrderStatus.PENDING
        statusActionView?.isHidden = order.status.rawValue < JKOrderStatus.ACCEPTED.rawValue || order.status.rawValue >= JKOrderStatus.DELIVERED.rawValue

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUp()
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderProductsTableSegue") {
            orderTable = segue.destination as? ProductsOrderTableViewController
            if let products = order?.productIds {
                orderTable?.productIds = products
            }
        }
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        updateOrder(status: JKOrderStatus.ACCEPTED.rawValue)
    }

    @IBAction func refuseTapped(_ sender: Any) {
        updateOrder(status: JKOrderStatus.REJECTED.rawValue)
    }

    @IBAction func delayTapped(_ sender: Any) {
        updateOrder(status: JKOrderStatus.BUSINESS_CANCELED.rawValue)
    }

    @IBAction func canceledTapped(_ sender: Any) {
        updateOrder(status: JKOrderStatus.BUSINESS_CANCELED.rawValue)
    }

    func updateOrder(status: Int? = nil) {
        if let order = order {
            JKMediator.updateOrder(orderId: order.id, userId: order.userId, status: status, success: {
                if let order = self.order {
                    self.order = JKOrderCache.shared.getItem(id: order.id)
                }
            }, failure: {})
        }
    }
    
}
extension OrderOverviewViewController: OrderSelectDelegate {
    
    func orderSelected(order: JKOrder) {
        
    }
    
}
