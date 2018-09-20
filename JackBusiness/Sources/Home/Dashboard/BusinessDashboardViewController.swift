//
//  BusinessDashboardViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/22/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel
import ArtUtilities

class BusinessDashboardViewController: UIViewController {
    
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var newCount: AULabel!
    
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var currentCount: AULabel!
    
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var pastCount: AULabel!
    
    var menu: [UIButton] {
        return [
            newButton,
            currentButton,
            pastButton,
        ]
    }
    
    var currentPage: Int = 0 {
        didSet {
            menu[oldValue].isSelected = false
            menu[currentPage].isSelected = true
            pageViewController?.currentIndex = currentPage
        }
    }
    
    var orders: [JKOrder]? {
        didSet {
            controllers[0].orders = []
            controllers[1].orders = []
            controllers[2].orders = []
            
            controllers[0].orders = self.orders!.filter({$0.status.rawValue == 0}).sorted() { $0.pickupDate > $1.pickupDate }
            controllers[1].orders = self.orders!.filter({$0.status.rawValue > 0 && $0.status.rawValue < 4}).sorted() { $0.pickupDate > $1.pickupDate }
            controllers[2].orders = self.orders!.filter({$0.status.rawValue >= 4}).sorted() { $0.pickupDate > $1.pickupDate }
            
            newCount.text = "\(controllers[0].orders.count)"
            currentCount.text = "\(controllers[1].orders.count)"
            pastCount.text = "\(controllers[2].orders.count)"
        }
    }
    
    lazy var controllers: [OrdersTableViewController] = {
        return [
            homeStoryboard.instantiateViewController(withIdentifier: "OrdersTableViewController") as! OrdersTableViewController,
            homeStoryboard.instantiateViewController(withIdentifier: "OrdersTableViewController") as! OrdersTableViewController,
            homeStoryboard.instantiateViewController(withIdentifier: "OrdersTableViewController") as! OrdersTableViewController
        ]
    }()
    
//    var productsOrderTable: ProductsOrderTableViewController?
//    var orderTable: OrdersTableViewController?
    
//    @IBOutlet weak var currentOrderPreview: UIView!
//    @IBOutlet weak var statusActions: UIView!
//    @IBOutlet weak var stateAction: UIView!
//    @IBOutlet weak var orderLabel: UILabel!
//
//    @IBOutlet weak var acceptButton: UIButton!
//    @IBOutlet weak var refuseButton: UIButton!
//
//    @IBOutlet weak var waitingButton: UIButton!
//    @IBOutlet weak var preparingButton: UIButton!
//    @IBOutlet weak var readyButton: UIButton!
//    @IBOutlet weak var deliveredButton: UIButton!
//    @IBOutlet weak var canceledButton: UIButton!
    
//    @IBOutlet weak var currentOrderHeightConstrain: NSLayoutConstraint!
    
//    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
//    var selectedCell: AUTableViewCell? {
//        didSet {
//            oldValue?.cellSelected = false
//        }
//    }
    
//    var currentOrder: JKOrder? {
//        didSet {
//            currentOrderPreview.isHidden = currentOrder == nil
//
//            UIView.animate(withDuration: 0.30) {
//                self.topConstraint.constant = self.currentOrder != nil ? 0 : -67
//            }
//
//            if let order = currentOrder {
//                orderLabel.text = "Commande \(order.id)"
//
//                statusActions.isHidden = order.status != .PENDING
//                stateAction.isHidden = order.status == .PENDING
//
//                acceptButton.isSelected = order.status == .ACCEPTED
//                refuseButton.isSelected = order.status == .REJECTED
//
//                waitingButton.isSelected = order.status == .ACCEPTED
//                preparingButton.isSelected = order.status == .PREPARING
//                readyButton.isSelected = order.status == .READY
//                deliveredButton.isSelected = order.status == .DELIVERED
//                canceledButton.isSelected = (order.status == .CLIENT_CANCELED || order.status == .BUSINESS_CANCELED)
//
//                waitingButton.isEnabled = false
//                preparingButton.isEnabled = order.status == .ACCEPTED
//                readyButton.isEnabled = order.status == .PREPARING
//                deliveredButton.isEnabled = order.status == .READY
//                canceledButton.isEnabled = order.status != .DELIVERED
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currentPage = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: refreshNotification, object: nil)
        loadOrders()
    }
    
    func loadOrders() {
        JKMediator.fetchOrders(businessId: JKSession.shared.businessId, success: { orders in
            self.orders = orders
            
            JKUserCache.shared.loadInCache(ids: orders.map{return $0.userId})
        }, failure: {
            
        })
    }
    
    @objc func refresh() {
        loadOrders()
    }
    
    var pageViewController: AUPageViewController? {
        didSet {
            pageViewController?.pageDelegate = self
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "OrderTableSegue") {
//            orderTable = segue.destination as? OrdersTableViewController
//            orderTable?.delegate = self
//        }
//        if (segue.identifier == "ProductOrderTableSegue") {
//            productsOrderTable = segue.destination as? ProductsOrderTableViewController
//        }
        if segue.identifier == "OrdersControllerSegue" {
            if let pageController = segue.destination as? AUPageViewController {
                self.pageViewController = pageController
                pageViewController?.removeSwipeGesture()
                pageViewController?.pages = controllers
                pageViewController?.currentIndex = 1
            }
        }
    }

    @IBAction func refreshTapped(_ sender: Any) {
        loadOrders()
    }
    
//    @IBAction func acceptTapped(_ sender: Any) {
//        updateOrder(status: JKOrderStatus.ACCEPTED.rawValue)
//    }
//
//    @IBAction func refuseTapped(_ sender: Any) {
//        updateOrder(status: JKOrderStatus.REJECTED.rawValue)
//    }
//
//    @IBAction func waitingTapped(_ sender: Any) {
//        updateOrder(status: JKOrderStatus.ACCEPTED.rawValue)
//    }
//
//    @IBAction func preparingTapped(_ sender: Any) {
//        preparingButton.isEnabled = false
//        readyButton.isEnabled = true
//        updateOrder(status: JKOrderStatus.PREPARING.rawValue)
//    }
//
//    @IBAction func readyTapped(_ sender: Any) {
//        updateOrder(status: JKOrderStatus.READY.rawValue)
//    }
//
//    @IBAction func deliveredTapped(_ sender: Any) {
//        updateOrder(status: JKOrderStatus.DELIVERED.rawValue)
//    }
//
//    @IBAction func canceledTapped(_ sender: Any) {
//        updateOrder(status: JKOrderStatus.BUSINESS_CANCELED.rawValue)
//    }
//
//    func updateOrder(status: Int? = nil) {
//        if let order = currentOrder {
//            JKMediator.updateOrder(orderId: order.id, userId: order.userId, status: status, success: {
//                if let order = self.currentOrder {
//                    self.currentOrder = JKOrderCache.shared.getItem(id: order.id)
//                }
//            }, failure: {})
//        }
//    }
    
    
    
    @objc func pageChangedHandler(notif: Notification) {
        if let page = notif.userInfo?["page"] as? Int {
            currentPage = page
        }
    }
    
    
    @IBAction func newTapped(_ sender: Any) {
        currentPage = 0
    }
    
    @IBAction func currentTapped(_ sender: Any) {
        currentPage = 1
    }
    
    @IBAction func pastTapped(_ sender: Any) {
        currentPage = 2
    }
}

extension BusinessDashboardViewController: AUPageViewControllerDelegate {
    func pageChanged(index: Int) {
    }
}

//extension BusinessDashboardViewController: AUCellSelectedDelegate {
//    func cellSelected(cell: AUTableViewCell) {
//        if let orderCell = cell as? OrderTableCell, let id = orderCell.order?.id {
//            selectedCell = orderCell
//            currentOrder = JKOrderCache.shared.getItem(id: id)
//            productsOrderTable?.productIds = currentOrder?.productIds ?? []
//        }
//    }
//}
