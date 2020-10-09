//
//  Router.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import Foundation
import UIKit

protocol ViewPresentable: AnyObject {
    func toPresentable() -> UIViewController
}

extension UIViewController: ViewPresentable {
    func toPresentable() -> UIViewController {
        return self
    }
}

protocol Routable: ViewPresentable {
    var navigationController: UINavigationController { get }
    func setRootController(_ viewPresentable: ViewPresentable, animated: Bool)
    func push(_ module: ViewPresentable, animated: Bool, onPop: (() -> Void)?)
    func pop(animated: Bool)
}

class Router: NSObject, Routable, UINavigationControllerDelegate {
    
    var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    var navigationController: UINavigationController {
        return rootNavigationController
    }
    
    private let rootNavigationController: NavigationController
    
    init(navigationController: NavigationController = NavigationController()) {
        rootNavigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
    // MARK: Routable
    
    func viewControllerOfType<T>(vcType: T.Type) -> UIViewController? {
        for viewController in navigationController.viewControllers {
            if String(describing: type(of: viewController)) == String(describing: vcType) {
                return viewController
            }
        }
        return nil
    }
    
    func push(_ module: ViewPresentable, animated: Bool = true, onPop: (() -> Void)? = nil) {
        let controller = module.toPresentable()
        
        if let viewController = viewControllerOfType(vcType: type(of: controller)) {
            navigationController.popToViewController(viewController, animated: false)
            return
        }
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func setRootController(_ viewPresentable: ViewPresentable, animated: Bool = false) {
        rootNavigationController.setViewControllers([viewPresentable.toPresentable()], animated: animated)
    }
}

extension Router: ViewPresentable {
    func toPresentable() -> UIViewController {
        return rootNavigationController
    }
}
