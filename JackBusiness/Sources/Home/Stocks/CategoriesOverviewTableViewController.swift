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

class CategoriesTableViewController: CategoriesOverviewTableViewController {
    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "",
            .section: "",
            .row: "CategoryTableCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 250,
            .section: 40,
            .row: 46,
        ]
    }
}

class CategoriesOverviewTableViewController: ATableViewController {
    
    var delegate: AUCellSelectedDelegate?
    
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
            .row: 81,
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
            cell.delegate = delegate
        }
        return cell
    }
    
}

class CategoryOverviewTableCell: AUTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var background: AShadowView!
    
    var category: JKCategory? {
        didSet {
            if let category = category {
                self.titleLabel?.text = category.name.uppercased()
                setUp()
            }
        }
    }
    
    @IBAction func actionsTapped(_ sender: Any) {
        guard let category = category else {
            return
        }
        AUAlertController.shared.complexAlertController(UIApplication.topViewController()!, title: "Que voulez vous faire?", message: "", actions: [
            AlertAction.init(title: "Modifier") {
                let vc = homeStoryboard.instantiateViewController(withIdentifier: "CreateCategoryViewController") as! CreateCategoryViewController
                
                vc.category = self.category
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            },
            AlertAction.init(title: "Supprimer", style: .destructive) {
                JKMediator.deleteItem(productId: category.id, success: {}, failure: {})
            },
            AlertAction.init(title: "Annuler", style: .cancel) {
                
            },
            ], preferredStyle: .actionSheet)
    }
    
    open override func updateCellSelection() {
        UIView.animate(withDuration: 0.35) {
            self.background.backgroundColor = self.cellSelected ? JKColors.deepBlue.uiColor.withAlphaComponent(0.6) : UIColor.white
            self.titleLabel.textColor = !self.cellSelected ? JKColors.darkGray.uiColor : UIColor.white
        }
    }
}
