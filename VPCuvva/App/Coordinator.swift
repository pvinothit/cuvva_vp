//
//  Coordinator.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
    var childCoordinators: [Coordinator] { get set }
    func removeChildCoordinator(_ coordinator: Coordinator)
}

protocol ChildCoordinator: Coordinator {
    var parent: Coordinator? { get set }
    var router: Routable { get }
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func removeChildCoordinator<T>(ofType type: T.Type) where T: Coordinator {
        childCoordinators = childCoordinators.compactMap {
            guard !($0 is T) else { return nil }
            return $0
        }
    }
    
    func startChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators.removeAll()
        addChildCoordinator(childCoordinator)
        
        if let childCoordinator = childCoordinator as? ChildCoordinator {
            childCoordinator.parent = self
        }
        
        childCoordinator.start()
    }
}
