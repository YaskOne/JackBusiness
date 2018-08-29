//
//  HomeViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/23/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

class HomeViewController: UIViewController {
    
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var menu: [UIButton] {
        return [
            statsButton,
            dashboardButton,
            shopButton,
        ]
    }
    var currentPage: Int = 0 {
        didSet {
            menu[oldValue].isSelected = false
            menu[currentPage].isSelected = true
            pageViewController?.currentIndex = currentPage
        }
    }
    
    var pageViewController: AUPageViewController? {
        didSet {
            pageViewController?.pageDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topConstraint.constant = UIApplication.shared.statusBarFrame.height
        currentPage = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "HomePageViewController" {
            if let pageController = segue.destination as? AUPageViewController {
                self.pageViewController = pageController
                pageViewController?.removeSwipeGesture()
                pageViewController?.pages = [
                    homeStoryboard.instantiateViewController(withIdentifier: "StocksOverviewViewController"),
                    homeStoryboard.instantiateViewController(withIdentifier: "BusinessDashboardViewController"),
                    homeStoryboard.instantiateViewController(withIdentifier: "BusinessViewController")
                ]
                pageViewController?.currentIndex = 1
            }
        }
    }
    
    @IBAction func statsTapped(_ sender: Any) {
        currentPage = 0
    }
    
    @IBAction func dashboardTapped(_ sender: Any) {
        currentPage = 1
    }
    
    @IBAction func shopTapped(_ sender: Any) {
        currentPage = 2
    }
    
}

extension HomeViewController: AUPageViewControllerDelegate {
    func pageChanged(index: Int) {
    }
}
