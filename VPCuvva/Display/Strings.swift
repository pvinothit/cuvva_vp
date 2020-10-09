//
//  DisplayString.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 08/10/2020.
//

import Foundation

struct RemoteStrings: Codable {
    let strings: Strings
}

struct Strings: Codable {
    let global: Global
    let homepage: Homepage
    let policyDetail: PolicyDetail
    let motor: Motor
}

struct Global: Codable {
    let pricing: Pricing
}

struct Pricing: Codable {
    let commissionExpl: String?
    var extraFees, ipt, title, totalPayable: String
    let totalPremium: String
}

struct Homepage: Codable {
    let activeSectionTitle, historicSectionTitle, insureCta, extendCta: String
    let vrmLabel, policyCountLabel, timeRemainingLabel: String
}

struct Motor: Codable {
    let policyExpiry, policyExpiryWarning: String
    let pricing: Pricing
}

struct PolicyDetail: Codable {
    let title, policyCountLabel, insureCta, extendCta: String
    let activeSectionTitle, historicSectionTitle: String
}
