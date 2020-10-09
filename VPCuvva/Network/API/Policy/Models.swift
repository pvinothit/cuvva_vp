//
//  Models.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

enum EventType: String, Codable {
    case created   = "policy_created"
    case transaction = "policy_financial_transaction"
    case cancelled = "policy_cancelled"
}

struct EventStream: Codable {
    let type: EventType
    let timestamp: String
    let uniqueKey: String?
    let payload: Payload
}

struct Payload: Codable {
    let policyId: String
    let userId: String?
    let userRevision: String?
    let originalPolicyId: String?
    let referenceCode: String?
    let startDate: String?
    let endDate: String?
    let incidentPhone: String?
    let vehicle: RawVehicle?
    let pricing: RawPricing?
    var documents: Documents?
}

struct RawVehicle: Codable {
    let vrm: String
    let prettyVrm: String
    let make: String
    let model: String
    let variant: String?
    let color: String
}

struct RawPricing: Codable {
    let underwriterPremium: Int
    let commission: Int
    let totalPremium: Int
    let ipt: Int
    let iptRate: Int
    let extraFees: Int
    let vat: Int
    let deductions: Int
    let totalPayable: Int
}

struct Documents: Codable {
    let certificateUrl: String
    let termsUrl: String
}
