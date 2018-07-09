//
//  JKMediator.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/6/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import UIKit
import JackModel
import SwiftyJSON

class JKMediator {
    
    // Fetch business request
    static func fetchBusiness(ids: Array<Int>, success: @escaping (Array<JKBusiness>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.ids] = "\(ids)"
        
        JKNetwork.shared.query(path: "business", method: .get, parameters: params, success: { json in
            do {
                var businesses: Array<JKBusiness> = Array<JKBusiness>()
                
                let businessDict = json.dictionaryObject![JKKeys.businesses]
                let array = (businessDict as! Array<[String: Any]>)
                if array.count == 0 {
                    failure()
                    return
                }
                let json = array[0]
                businesses.append(try JKBusiness.init(args: json))
                success(businesses)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Create business request
    static func createBusiness(name: String, address: String, type: String, url: String, description: String, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.name] = name
        params[JKKeys.address] = address
        params[JKKeys.type] = type
        params[JKKeys.description] = description
        params[JKKeys.url] = url
        
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
