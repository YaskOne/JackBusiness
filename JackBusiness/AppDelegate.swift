//
//  AppDelegate.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/5/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import AWSUserPoolsSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate {

    var window: UIWindow?
    
    lazy var userPool: AWSCognitoIdentityUserPool = {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.EUWest2, identityPoolId:"eu-west-2:7f065f41-090f-4481-a50b-43677a8ee716")

        let serviceConfiguration = AWSServiceConfiguration(region:.EUWest2, credentialsProvider: credentialsProvider)
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration.init(clientId: "1fimip5f3vvhf8ugpsjsocorpv", clientSecret: "1f8rjfbdgtfafuf4evi42vuei1gohckndp6ghn53prt2jrpu4vnr", poolId: "eu-west-2_X7xlLTAVW")

        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: "JackUsers")

        let userPool = AWSCognitoIdentityUserPool.init(forKey: "JackUsers")
        userPool.delegate = self

        return userPool
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyC2IT49iFLikS_ZU7-8HHTt8nt1GCisaO0")
        GMSPlacesClient.provideAPIKey("AIzaSyC2IT49iFLikS_ZU7-8HHTt8nt1GCisaO0")
        // Initialiser le fournisseur d'informations d'identification Amazon Cognito
        
        
 
        
        var attrs: [AWSCognitoIdentityUserAttributeType] = []
        
        var phone = AWSCognitoIdentityUserAttributeType()
        
        phone?.name = "phone_number"
        //All phone numbers require +country code as a prefix
        phone?.value = "+15555555555"
        
        var email = AWSCognitoIdentityUserAttributeType()
        email?.name = "email"
        email?.value = "email@mydomain.com"
        
        attrs.append(phone!)
        attrs.append(email!)
        var user = userPool.signUp("email", password: "password", userAttributes: attrs, validationData: nil)
//pool.delegate = self
        // Retrieve your Amazon Cognito ID

//        credentialsProvider.getIdentityId().continueWith { (task: AWSTask!) -> AnyObject? in
//
//            if (task.error != nil) {
//                print("Error: " + (task.error?.localizedDescription)!)
//
//            } else {
//                // the task result will contain the identity id
//                let cognitoId = task.result
//                print("---------------------- AWSSSS")
//                print(cognitoId)
//            }
//            return nil
//        }
        return true
//        return AWSMobileClient.sharedInstance().interceptApplication(
//            application, didFinishLaunchingWithOptions:
//            launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

