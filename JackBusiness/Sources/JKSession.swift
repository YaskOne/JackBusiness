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
    
    let defaults: UserDefaults = {
        return UserDefaults.standard
    }()
    
    lazy var userDefaults: UserDefaults = {
        return UserDefaults.standard
    }()
    
    static let shared: JKSession = JKSession()
    
    var businessId: UInt = 0
    var business: JKBusiness? {
        get {
            return JKBusinessCache.shared.getItem(id: businessId)
        }
        set {
            if let newValue = newValue {
                businessId = newValue.id
                JKBusinessCache.shared.addObject(id: newValue.id, object: newValue)
            }
        }
    }
    
    func startSession() {
        if let id = defaults.object(forKey: JKKeys.businessId) as? UInt, id != 0 {
            businessId = id
            loadBusiness()
        }
    }
    
    func saveSession() {
        defaults.set(businessId, forKey: JKKeys.businessId)
    }
    
    func closeSession() {
        JKBusinessCache.shared.removeObject(id: businessId)
        defaults.set(0, forKey: JKKeys.businessId)
        businessId = 0
    }
    
    func loadBusiness() {
        JKBusinessCache.shared.loadInCache(ids: [businessId])
    }
}
