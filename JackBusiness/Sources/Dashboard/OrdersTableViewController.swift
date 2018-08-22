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
            .header: "PlaceHeaderCell",
            .section: "CategoryCell",
            .row: "OrderTableCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 250,
            .section: 40,
            .row: 70,
        ]
    }
    
    var orders: [JKOrder] = [] {
        didSet {
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
        JKMediator.fetchBusinessOrders(id: JKSession.shared.business!.id, success: {orders in
            self.orders = orders
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
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var order: JKOrder? {
        didSet {
            if let order = order {
                idLabel.text = String(order.id)
                dateLabel.text = order.pickupDate.description
                countLabel.text = String(order.productIds.count)
            }
        }
    }
}
