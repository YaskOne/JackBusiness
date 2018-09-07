//
//  ProductsOverviewTableViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/26/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

class ProductsOverviewTableViewController: ATableViewController {
    
    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "",
            .section: "",
            .row: "ProductOverviewTableCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 250,
            .section: 40,
            .row: 50,
        ]
    }
    
    var categoryId: UInt = 0 {
        didSet {
            products = []
            source = []

            JKMediator.fetchProducts(categoryId: categoryId, success: { products in
                    self.products = products
                }, failure: {
                    
                })
        }
    }
    
    var products: [JKProduct] = [] {
        didSet {
            source = []
            for item in products {
                source.append(ATableViewRow.init(type: .row, section: 0, object: item))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        setUp()
    }
    
    func setUp() {
        //        JKMediator.fetchBusinessOrders(id: JKSession.shared.business!.id, success: {orders in
        //            self.orders = orders
        //        }, failure: {
        //
        //        })
    }
    
    override func setUpRow(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpRow(item: item, indexPath: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? ProductOverviewTableCell, let product = item.object as? JKProduct {
            cell.product = product
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

class ProductOverviewTableCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: AUImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var priceView: PriceLabel?
    
    var product: JKProduct? {
        didSet {
            clearFields()
            if let product = product {
                nameLabel?.text = product.name
                priceView?.price = product.price
                if product.url != "" {
                    JKImageLoader.loadImage(imageView: productImageView, url: product.url) {}
                }
                else {
                    productImageView?.image = nil
                }
            }
        }
    }
    
    
    func clearFields() {
        productImageView?.image = nil
        nameLabel?.text = nil
        priceView?.text = nil
    }
}
