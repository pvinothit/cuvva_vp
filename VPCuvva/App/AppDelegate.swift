//
//  AppDelegate.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    private let appCoordinator: AppCoordinator
   
    override init() {
        appCoordinator = AppCoordinator()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.start()
        return true
    }
    
}

