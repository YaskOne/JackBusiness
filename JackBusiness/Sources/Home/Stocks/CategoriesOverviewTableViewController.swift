//
//  CategoriesOverviewTableViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/26/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel
import ArtUtilities

protocol CategorySelectedDelegate {
    func categorySelected(category: JKCategory)
}

class CategoriesOverviewTableViewController: ATableViewController {
    
    var delegate: CategorySelectedDelegate?
    
    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "",
            .section: "",
            .row: "CategoryOverviewTableCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 250,
            .section: 40,
            .row: 40,
        ]
    }
    
    var categories: [JKCategory] = [] {
        didSet {
            source = []
            for item in categories {
                source.append(ATableViewRow.init(type: .row, section: 0, object: item))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp() {
        if let id = JKSession.shared.business?.id {
            JKMediator.fetchCategories(businessId: id, success: { categories in
                self.categories = categories
            }, failure: {})
        }
    }
    
    override func setUpRow(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpRow(item: item, indexPath: indexPath)
        
        if let cell = cell as? CategoryOverviewTableCell, let category = item.object as? JKCategory {
            cell.category = category
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = (itemAtIndex(indexPath).object as? JKCategory) else {
            return
        }
        
        delegate?.categorySelected(category: category)
    }
    
}

class CategoryOverviewTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var category: JKCategory? {
        didSet {
            if let category = category {
                self.titleLabel?.text = category.name.uppercased()
            }
        }
    }
}
