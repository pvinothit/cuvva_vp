//
//  AppCoordinator.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow?
    
    private let routable: Routable
    private let stringsManager: StringsManager

    init(router: Routable = Router(), stringsManager: StringsManager = StringsManager(), window: UIWindow? = nil) {
        self.routable = router
        self.stringsManager = stringsManager
    }
    
    func start() {
        stringsManager.sync()
        
        let homeCoordinator = HomeCoordinator(routable: routable)
        startChildCoordinator(homeCoordinator)
        homeCoordinator.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = routable.navigationController
        window?.makeKeyAndVisible()
    }
    
}
