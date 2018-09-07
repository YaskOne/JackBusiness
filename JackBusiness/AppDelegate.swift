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

        JKNetwork.shared.server = "http://127.0.0.1:3000"
        JKNetwork.shared.server = "https://imb1l2wde1.execute-api.eu-west-2.amazonaws.com/Prod"
        
        JKSession.shared.startSession()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        JKSession.shared.saveSession()
    }


}

