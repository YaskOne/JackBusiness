//
//  HomeViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/23/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

let changePageNotification = Notification.Name("changePageNotification")

class HomeViewController: APresenterViewController {
    
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    
    @IBOutlet weak var statusButton: AUButton?
    @IBOutlet weak var countdownView: CountdownView!
    
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
    
    func updateBusiness() {
        if let business = JKSession.shared.business {
            statusButton?.text = business.status.description
            statusButton?.defaultColor = business.status.color
            countdownView.value = Int(business.minutesPreparationDuration)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 1
        updateBusiness()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pageChangedHandler), name: changePageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.businessChanged), name: businessChangedNotification, object: nil)
        countdownView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(preparationTimeTapped)))
    }
    
    var pageViewController: AUPageViewController? {
        didSet {
            pageViewController?.pageDelegate = self
        }
    }
    
    @objc func preparationTimeTapped() {
        
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
    
    @objc func pageChangedHandler(notif: Notification) {
        if let page = notif.userInfo?["page"] as? Int {
            currentPage = page
        }
    }
    
    @objc func businessChanged(notif: Notification) {
        updateBusiness()
    }
    @IBAction func statusTapped(_ sender: Any) {
        guard let controller = homeStoryboard.instantiateViewController(withIdentifier: "StatusViewController") as? StatusViewController else {
            return
        }
        
        controller.modalPresentationStyle = UIModalPresentationStyle.custom
        controller.transitioningDelegate = self
        
        self.present(controller, animated: true, completion: nil)

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
