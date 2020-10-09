//
//  VehiclePolicyTableViewCell.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 09/10/2020.
//

import UIKit

final class VehiclePolicyTableViewCell: UITableViewCell {
    
    static var identifier: String = String(describing: VehiclePolicyTableViewCell.self)
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let vehicleLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let makeLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.shared.font.title
        return label
    }()
    
    private let modelLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.shared.font.normal
        return label
    }()
    
    private let regPlateTitle: UILabel = {
        let label = UILabel()
        label.font = Theme.shared.font.normal
        label.text = Display.strings.homepage.vrmLabel
        return label
    }()
        
    private let regPlate: UILabel = {
        let label = UILabel()
        label.font = Theme.shared.font.normal
        return label
    }()
    
    private let totalPolicyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.shared.font.normal
        label.text = Display.strings.homepage.policyCountLabel
        return label
    }()
        
    private let totalPolicyLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.shared.font.normal
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17.5
        button.titleLabel?.font = Theme.shared.font.title
        return button
    }()
    
    private let timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.shared.font.normal
        label.textColor = Theme.shared.colour.primary
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var display: DisplayVehicle?
    
    private func setupViews() {
        backgroundColor = .clear
        addAutoSubView(containerView, contraints: .fit(.standard))
        containerView.addAutoSubView(vehicleLogoImageView, contraints: .pinTopLeftWH(.zero, 50))
        containerView.addAutoSubView(makeLabel, contraints: .pinRightTo(vehicleLogoImageView, .custom(leading: 10)))
        containerView.addAutoSubView(modelLabel, contraints: .pinRightAndBelow(vehicleLogoImageView, belowTo: makeLabel, .custom(leading: 10)))
        containerView.addAutoSubView(actionButton, contraints: .pinTopLeft(.custom(trailing: 25, top: 10)))
        actionButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        containerView.addAutoSubView(regPlateTitle, contraints: .belowLeft(vehicleLogoImageView, .standard))
        containerView.addAutoSubView(regPlate, contraints: .belowLeft(regPlateTitle, .custom(leading: 10, top: 5)))
        
        containerView.addAutoSubView(totalPolicyTitleLabel, contraints: .pinRightAndBelow(regPlateTitle, belowTo: vehicleLogoImageView, .custom(leading: 50, top: 10)))
        containerView.addAutoSubView(totalPolicyLabel, contraints: .pinRightAndBelow(regPlateTitle, belowTo: totalPolicyTitleLabel, .custom(leading: 50, top: 5)))
        
        containerView.addAutoSubView(timeRemainingLabel, contraints: .belowAndFit(regPlate, .standard))
        timeRemainingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        containerView.bottomAnchor.constraint(equalTo: timeRemainingLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    func update(display: DisplayVehicle) {
        self.display = display
        vehicleLogoImageView.image = display.logo
        makeLabel.text = display.make
        modelLabel.text = display.model
        regPlate.text = display.regPlate
        actionButton.backgroundColor = display.isActive ? Theme.shared.colour.cta : Theme.shared.colour.background
        actionButton.setTitleColor(.black, for: .normal)
        totalPolicyLabel.text = "\(display.totalPolicies)"
        actionButton.setTitle(display.actionText, for: .normal)
        self.display?.countDown { [weak self] remainingTime in
            self?.timeRemainingLabel.text = remainingTime
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        display?.invalidate()
    }
}
