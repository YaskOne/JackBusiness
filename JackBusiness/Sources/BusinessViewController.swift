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
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        
        profileImageView.imageFromURL(urlString: JKSession.shared.business?.url ?? "")
        
        nameLabel.text = "name: \(JKSession.shared.business?.name)"
        descriptionLabel.text = "description: \(JKSession.shared.business?.description)"
        addressLabel.text = "address: \(JKSession.shared.business?.address)"
        typeLabel.text = "type: \(JKSession.shared.business?.type)"
        idLabel.text = "description: \(JKSession.shared.business?.id.description)"
    }

}
