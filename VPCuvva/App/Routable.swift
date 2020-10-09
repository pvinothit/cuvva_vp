//
//  Router.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import Foundation
import UIKit

protocol Router: ViewPresentable {
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    
    func push(_ module: ViewPresentable, animated: Bool, onPop: (() -> Void)?)
}


protocol PushPresentable: AnyObject {
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
}

extension UIViewController: PushPresentable {
    func push(_ viewController: UIViewController, animated: Bool) {
        let navigationController = (self as? UINavigationController) ?? self.navigationController
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        let navigationController = (self as? UINavigationController) ?? self.navigationController
        navigationController?.popViewController(animated: animated)
    }
}

protocol ViewPresentable: AnyObject {
    func toPresentable() -> UIViewController
}

extension UIViewController: ViewPresentable {
    func toPresentable() -> UIViewController {
        return self
    }
}
