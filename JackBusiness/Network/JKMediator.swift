//
//  JKMediator.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/6/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import UIKit

class JKMediator {
    
    // Fetch business request
    static func fetchBusiness(ids: Array<Int>, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.ids] = "\(ids)"
        
        JKNetwork.shared.query(path: "business", method: .get, parameters: params, success: { json in
            }, failure: failure)
    }
    
    // Create business request
    static func createBusiness(name: String, address: String, type: String, description: String, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.name] = name
        params[JKKeys.address] = address
        params[JKKeys.type] = type
        params[JKKeys.description] = description
        
        JKNetwork.shared.query(path: "business/create", method: .post, parameters: params, success: { json in
            print("IDDDDDDD   \(json)")
            print("IDDDDDDD   \(json.description)")
            if let id = json.dictionaryObject?["id"] as? Int {
                print("IDDDDDDD   \(id)")
                success(id)
            }
            else {
                failure()
            }
        }, failure: failure)
    }
    
}
