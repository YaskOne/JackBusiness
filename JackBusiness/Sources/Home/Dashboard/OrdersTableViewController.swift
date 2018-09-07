//
//  OrdersTableTableViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/22/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

protocol OrderSelectDelegate {
    func orderSelected(order: JKOrder)
}

class OrdersTableViewController: ATableViewController {
    
    var delegate: OrderSelectDelegate?

    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "",
            .section: "",
            .row: "OrderTableCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 0,
            .section: 0,
            .row: 70,
        ]
    }
    
    var orders: [JKOrder] = [] {
        didSet {
            source = []
            for item in orders {
                source.append(ATableViewRow.init(type: .row, section: 0, object: item))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp() {
        self.orders = []
        JKMediator.fetchOrders(businessId: JKSession.shared.businessId, success: { orders in
            self.orders = orders

            JKUserCache.shared.loadInCache(ids: orders.map{return $0.userId})
        }, failure: {
            
        })
    }

    override func setUpRow(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpRow(item: item, indexPath: indexPath)
        
//        cell.selectionStyle = .none
        
        if let cell = cell as? OrderTableCell, let order = item.object as? JKOrder {
            cell.order = order
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let order = (itemAtIndex(indexPath).object as? JKOrder) else {
            return
        }
        
        delegate?.orderSelected(order: order)
    }
    
}

class OrderTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var retrieveDate: CountdownView!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var order: JKOrder? {
        didSet {
            NotificationCenter.default.removeObserver(self, name: userChangedNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(userUpdated), name: userChangedNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: orderChangedNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(orderChanged), name: orderChangedNotification, object: nil)
            setUpOrder()
        }
    }

    func setUpOrder() {
        if let order = order {
            nameLabel.text = "\(String(describing: JKUserCache.shared.getItem(id: order.userId)?.name ?? "-")) (\(order.id))"
            countLabel.text = "x\(String(order.productIds.count)) produits, \(order.price)€"
            statusLabel.text = "\(order.status.rawValue.uppercased()),\(order.state.rawValue.uppercased())"
            
            retrieveDate.value = order.pickupDate.minutesSinceNow()
            retrieveDate.textColor = UIColor.darkGray
        }
    }
    
    @objc func userUpdated(notif: Notification) {
        if let id = notif.userInfo?["id"] as? UInt, id == order?.userId, let order = order {
            nameLabel.text = "\(String(describing: JKUserCache.shared.getItem(id: order.userId)?.name ?? "-")) (\(order.id))"
        }
    }
    
    @objc func orderChanged(notif: Notification) {
        if let id = notif.userInfo?["id"] as? UInt, id == order?.id {
            order = JKOrderCache.shared.getItem(id: id)
        }
    }

}
