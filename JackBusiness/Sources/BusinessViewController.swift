//
//  BusinessViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/9/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

class BusinessViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(setUp), name: businessChangedNotification, object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: businessChangedNotification, object: nil)
    }
    
    @objc func setUp() {
        profileImageView.imageFromURL(urlString: JKSession.shared.business?.url ?? "")
        
        if let business = JKSession.shared.business {
            nameLabel.text = business.name
            descriptionLabel.text = business.description
            addressLabel.text = business.address
            typeLabel.text = business.type
        }
    }

    @IBAction func logOut(_ sender: Any) {
        JKSession.shared.closeSession()
        
        let vc = authStoryboard.instantiateViewController(withIdentifier: "AuthentificationViewController") as? AuthentificationViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        let alert = UIAlertController(title: AULocalized.string("delete_account_action"), message: AULocalized.string("confirm_delete_account_title"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: AULocalized.string("confirm_action"), style: .default, handler: { action in
//                NotificationCenter.default.post(name: changePageNotification, object: nil, userInfo: ["page": 1])
            JKMediator.deleteBusinessAccount(businessId: JKSession.shared.business!.id, success: {
                self.navigationController?.popViewController(animated: true)
                JKSession.shared.closeSession()
            }, failure: {
                
            })
            }))
        alert.addAction(UIAlertAction(title: AULocalized.string("cancel_action"), style: .default, handler: { action in
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        navigationController?.pushViewController(authStoryboard.instantiateViewController(withIdentifier: "CreateBusinessViewController"), animated: true)
    }
    
    @IBAction func cguTapped(_ sender: Any) {
        navigationController?.pushViewController(homeStoryboard.instantiateViewController(withIdentifier: "CGU"), animated: true)
    }
}
