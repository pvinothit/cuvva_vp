//
//  HomeViewController.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private var coordinator: HomeCoordinatorDelgate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    init(viewModel: HomeViewModel, coordinator: HomeCoordinatorDelgate?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        viewModel.fetchVehicles { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func setUpViews() {
        view.backgroundColor = Theme.shared.colour.background
        view.addAutoSubView(tableView, contraints: .fit(.standard))
        tableView.register(VehiclePolicyTableViewCell.self, forCellReuseIdentifier: VehiclePolicyTableViewCell.identifier)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VehiclePolicyTableViewCell.identifier) as? VehiclePolicyTableViewCell {
            cell.update(display: viewModel.sections[indexPath.section].contents[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].contents.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vehicle = viewModel.vehicle(of: viewModel.sections[indexPath.section].contents[indexPath.row]) {
            coordinator?.showPolicyDetail(for: vehicle)
        }
    }
}
