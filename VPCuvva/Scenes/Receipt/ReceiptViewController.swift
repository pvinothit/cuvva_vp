//
//  ReceiptViewController.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import UIKit

final class ReceiptViewController: UIViewController {
    
    private let viewModel: ReceiptViewModel
    
    init(viewModel: ReceiptViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.shared.colour.background
        title = "Receipt"
    }

}
