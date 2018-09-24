//
//  StatusViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 9/20/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel
import ArtUtilities

class StatusViewController: APresentableViewController {
    
    override open var direction: APresentationDirection {
        return .top
    }
    
    override var sizePt: CGFloat {
        return 255
    }
    
    var preparationValue: Int {
        return JKSession.shared.business?.minutesPreparationDuration ?? 10
    }
    
    @IBOutlet weak var availableButton: AULabeledButton!
    @IBOutlet weak var unavailableButton: AULabeledButton!
    @IBOutlet weak var temporaryUnavailableButton: AULabeledButton!
    
    @IBOutlet weak var firstButton: AULabeledButton!
    @IBOutlet weak var secondButton: AULabeledButton!
    @IBOutlet weak var thirdButton: AULabeledButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(self.businessChanged), name: businessChangedNotification, object: nil)
    }
    
    @objc func businessChanged(notif: Notification) {
        setUp()
    }

    @objc func setUp() {
        firstButton.isEnabled = preparationValue > 5
        firstButton.setTitle("\(preparationValue - 5) min", for: .normal)
        secondButton.setTitle("\(preparationValue) min", for: .normal)
        thirdButton.setTitle("\(preparationValue + 5) min", for: .normal)
        
        guard let business = JKSession.shared.business else {
            return
        }

        availableButton.isSelected = business.status == JKBusinessStatus.AVAILABLE
        unavailableButton.isSelected = business.status == JKBusinessStatus.UNAVAILABLE
        temporaryUnavailableButton.isSelected = business.status == JKBusinessStatus.TEMPORARILY_UNAVAILABLE
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func availableTapped(_ sender: Any) {
        if let id = JKSession.shared.business?.id {
            JKMediator.updateBusiness(id: id, status: JKBusinessStatus.AVAILABLE.rawValue, success: {}, failure: {})
        }
    }
    
    @IBAction func unavailableTapped(_ sender: Any) {
        if let id = JKSession.shared.business?.id {
            JKMediator.updateBusiness(id: id, status: JKBusinessStatus.UNAVAILABLE.rawValue, success: {}, failure: {})
        }
    }
    
    @IBAction func temporarilyUnavailableTapped(_ sender: Any) {
        if let id = JKSession.shared.business?.id {
            JKMediator.updateBusiness(id: id, status: JKBusinessStatus.TEMPORARILY_UNAVAILABLE.rawValue, success: {}, failure: {})
        }
    }
    
    @IBAction func firstTimeTapped(_ sender: Any) {
        if let business = JKSession.shared.business {
            business.minutesPreparationDuration = preparationValue - 5
            JKMediator.updateBusiness(id: business.id, defaultPreparationDuration: business.defaultPreparationDuration, success: {}, failure: {})
        }
    }
    @IBAction func secondTimeTapped(_ sender: Any) {
        if let business = JKSession.shared.business {
            business.minutesPreparationDuration = preparationValue
            JKMediator.updateBusiness(id: business.id, defaultPreparationDuration: business.defaultPreparationDuration, success: {}, failure: {})
        }
    }
    @IBAction func thirdTimeTapped(_ sender: Any) {
        if let business = JKSession.shared.business {
            business.minutesPreparationDuration = preparationValue + 5
            JKMediator.updateBusiness(id: business.id, defaultPreparationDuration: business.defaultPreparationDuration, success: {}, failure: {})
        }
    }
    
}
