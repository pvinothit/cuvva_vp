//
//  PolicyViewController.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import UIKit

final class PolicyViewController: UIViewController {
    
    private let viewModel: PolicyViewModel
    
    private weak var coordinator: PolicyCoordinatorDelgate?
    
    init(viewModel: PolicyViewModel, coordinator: PolicyCoordinatorDelgate? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var receipt: UIButton = {
        let button = UIButton()
        button.setTitle("Receipt", for: .normal)
        button.backgroundColor = Theme.shared.colour.cta
        button.addTarget(self, action: #selector(receiptTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.shared.colour.background
        title = Display.strings.policyDetail.title
        
        view.addAutoSubView(receipt, contraints: .center)
    }
    
    @objc private func receiptTapped() {
        if let policy = viewModel.vehicle.policies.first {
            coordinator?.showReceipt(for: policy) // Just for test purpose
        }
    }
}
