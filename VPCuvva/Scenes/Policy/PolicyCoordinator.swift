//
//  PolicyCoordinator.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 08/10/2020.
//

import Foundation

protocol PolicyCoordinatorDelgate: AnyObject {
    func showReceipt(for policy: Policy)
}

final class PolicyCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let routable: Routable
    private let vehicle: Vehicle
    
    init(routable: Routable, vehicle: Vehicle) {
        self.vehicle = vehicle
        self.routable = routable
    }
    
    func start() {
        let policyVC = PolicyViewController(viewModel: PolicyViewModel(vehicle: vehicle), coordinator: self)
        routable.push(policyVC, animated: true, onPop: { [weak self] in
            guard let self = self else { return }
            self.removeChildCoordinator(self)
        })
    }
}

extension PolicyCoordinator: PolicyCoordinatorDelgate {
    func showReceipt(for policy: Policy) {
        let receiptVC = ReceiptViewController(viewModel: ReceiptViewModel(transactions: policy.transactions))
        routable.push(receiptVC, animated: true, onPop: nil)
    }
}
