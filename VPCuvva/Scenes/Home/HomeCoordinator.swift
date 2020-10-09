//
//  HomeCoordinator.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import Foundation

protocol HomeCoordinatorDelgate: AnyObject {
    func showPolicyDetail(for vehicle: Vehicle)
}

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let routable: Routable
    
    init(routable: Routable) {
        self.routable = routable
    }
    
    func start() {
        let homeViewController = HomeViewController(viewModel: HomeViewModel(), coordinator: self)
        routable.setRootController(homeViewController, animated: true)
    }
}

extension HomeCoordinator: HomeCoordinatorDelgate {
    func showPolicyDetail(for vehicle: Vehicle) {
        let policyCoordinator = PolicyCoordinator(routable: routable, vehicle: vehicle)
        startChildCoordinator(policyCoordinator)
    }

}
