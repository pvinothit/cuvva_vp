//
//  Vehicle.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 09/10/2020.
//

import UIKit

struct Vehicle {
    let make: String
    let model: String
    let color: String
    let regNumber: String
    let prettyReg: String
    var policies: [Policy]
}

extension Vehicle {
    
    var toDisplay: DisplayVehicle {
        let activePolicy = policies.first(where: { $0.isActive == true || ($0.extendedPolicies.filter { $0.isActive == true }.count > 0) })
        let isActive = activePolicy != nil
        
        var endDate: Date? = activePolicy?.endTime
        
        if let activePolicy = activePolicy {
            endDate = activePolicy.extendedPolicies.first(where: { $0.isActive == true })?.endTime
        }
        
        var actionText: String = ""
        if Display.strings != nil {
            actionText = isActive ? Display.strings.homepage.extendCta : Display.strings.homepage.insureCta
        }
        
        return DisplayVehicle(id: regNumber,
                              make: make,
                              model: model,
                              regPlate: prettyReg,
                              totalPolicies: policies.count,
                              isActive: isActive,
                              actionText: actionText,
                              endTime: endDate)
    }
}

class DisplayVehicle {
    private let minute: TimeInterval = 60
    let id: String
    let make: String
    let model: String
    let regPlate: String
    let totalPolicies: Int
    let isActive: Bool
    let actionText: String
    var endTime: Date?
    var logo: UIImage? { UIImage(named: make.lowercased()) }
    private var countDownTimer: Timer?
    
    init(id: String, make: String, model: String, regPlate: String, totalPolicies: Int, isActive: Bool, actionText: String, endTime: Date? = nil) {
        self.id = id
        self.make = make
        self.model = model
        self.regPlate = regPlate
        self.totalPolicies = totalPolicies
        self.isActive = isActive
        self.actionText = actionText
        self.endTime = endTime
    }
    
    func countDown(completion: @escaping (String)->()?) {
        invalidate()
        guard let endTime = endTime else { return }
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: minute, repeats: true, block: { [weak self] _ in
            let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: Date(), to: endTime)
            let timeRemaining = dateComponents.minute ?? 0
            let remainingTimeString = "\(timeRemaining) minutes \(Display.strings.homepage.timeRemainingLabel)"
            if timeRemaining > 0 {
                completion(remainingTimeString)
            } else {
                self?.invalidate()
            }
        })
        
        countDownTimer?.fire()
    }
    
    func invalidate() {
        countDownTimer?.invalidate()
        countDownTimer = nil
    }
}
