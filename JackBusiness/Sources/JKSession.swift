//
//  JKSession.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/9/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import JackModel

class JKSession {
    
    lazy var userDefaults: UserDefaults = {
        return UserDefaults.standard
    }()
    
    static let shared: JKSession = JKSession()
    
    var business: JKBusiness?
    
    var active: Bool {
        return business != nil
    }
    
    func restore() {
//        business = userDefaults.object(forKey: JKKeys.business) as? JKBusiness
    }
    
    func save() {
//        if let business = business {
//            userDefaults.set(business, forKey: JKKeys.business)
//        }
    }
}
