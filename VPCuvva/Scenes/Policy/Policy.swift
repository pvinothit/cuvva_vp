//
//  VehicleModels.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 09/10/2020.
//

import Foundation

struct Policy {
    
    enum Status: String {
        case active
        case expired
    }
    
    let id: String
    let originalId: String?
    let startTime: Date?
    let endTime: Date?
    let type: EventType
    var transactions: [Transaction]
    var extendedPolicies: [Policy]
    
    var isActive: Bool {
        guard let endTime = endTime, let startTime = startTime else { return false }
        return endTime > Date() && startTime < Date()
    }
    
    var isExtended: Bool {
        return id != originalId
    }
}

struct Transaction {
    let policyId: String
    let createdAt: Date
    let insurancePremium: Int
    let insurancePremiumTax: Int
    let adminFee: Int
    let totalPaid: Int
}
