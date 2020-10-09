//
//  HomeViewModel.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import Foundation
import UIKit

struct Section {
    let key: String
    let title: String
    let contents: [DisplayVehicle]
}

final class HomeViewModel {
    
    private let policyService: PolicyService
    
    private typealias PolicyId = String
    private typealias OriginalPolicyId = String
    private typealias RegistrationNumber = String
    private typealias TransactionsOfPolicy = [PolicyId: [Transaction]]
    private typealias ExtendedPolicies = [OriginalPolicyId: [Policy]]
    
    private (set) var sections: [Section] = []
    private (set) var vehicles: [Vehicle] = []
    
    init(policyService: PolicyService = APIServiceManager()) {
        self.policyService = policyService
    }
    
    func fetchVehicles(completion: @escaping ([Section]) -> ()) {
        policyService.fetchEventStreams { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let eventStreams):
                self.vehicles = self.convertStreamsToVechicles(eventStreams ?? [])
                self.groupVehiclesToSections()
                completion(self.sections)
            case .failure:
                print("Handle error")
            }
        }
    }
    
    func vehicle(of displayVehicle: DisplayVehicle) -> Vehicle? {
        return vehicles.first(where: { $0.regNumber == displayVehicle.id })
    }
    
    
    // MARK: Helpers
    
    private func groupVehiclesToSections() {
        let displayableVehicles = vehicles.map { $0.toDisplay }
        
        var groupedVehicles : [Policy.Status: [DisplayVehicle]] = [:]
        groupedVehicles[.active] = []
        groupedVehicles[.expired] = []
        
        displayableVehicles.forEach { displayVehicle in
            if displayVehicle.isActive {
                groupedVehicles[.active]?.append(displayVehicle)
            } else {
                groupedVehicles[.expired]?.append(displayVehicle)
            }
        }
        
        sections = groupedVehicles.map({ key, items in
            let title = key == .active ? Display.strings.homepage.activeSectionTitle : Display.strings.homepage.historicSectionTitle
            return Section(key: key.rawValue, title: title , contents: items)
        }).sorted { $0.key < $1.key }
    }
    
    private func computeTransactionsAndExtendedPolicies(_ streams: [EventStream]) -> (transactions: TransactionsOfPolicy, extendedPolicies: ExtendedPolicies) {
        var transactions: TransactionsOfPolicy = [:]
        var extendedPolicies: [OriginalPolicyId: [Policy]] = [:]
        
        streams.forEach { eventStream in
            let policyId = eventStream.payload.policyId
            if eventStream.type == .transaction {
                if let pricing = eventStream.payload.pricing {
                    let transaction = Transaction(policyId: policyId, createdAt: eventStream.timestamp.policyDate ?? Date(), insurancePremium: pricing.totalPremium, insurancePremiumTax: pricing.ipt, adminFee: pricing.commission, totalPaid: pricing.totalPayable)
                    transactions[policyId] == nil ? transactions[policyId] = [transaction] : transactions[policyId]?.append(transaction)
                }
            } else if eventStream.type == .created {
                let startTime = eventStream.payload.startDate?.policyDate
                let endTime = eventStream.payload.endDate?.policyDate
                
                if policyId != eventStream.payload.originalPolicyId {
                    if let originalPolicyId = eventStream.payload.originalPolicyId {
                        let extendedPolicy = Policy(id: policyId, originalId: originalPolicyId, startTime: startTime, endTime: endTime, type: eventStream.type, transactions: transactions[policyId] ?? [], extendedPolicies: [])
                        extendedPolicies[originalPolicyId] == nil ? extendedPolicies[originalPolicyId] = [extendedPolicy] : extendedPolicies[originalPolicyId]?.append(extendedPolicy)
                    }
                }
            }
        }
        return (transactions, extendedPolicies)
    }
    
    private func convertStreamsToVechicles(_ streams: [EventStream]) -> [Vehicle] {
        
        var vehicles: [RegistrationNumber : Vehicle] = [:]
        
        let result = computeTransactionsAndExtendedPolicies(streams)
        let transactions = result.transactions
        let extendedPolicies = result.extendedPolicies
        
        streams.forEach { eventStream in
            let startTime = eventStream.payload.startDate?.policyDate
            let endTime = eventStream.payload.endDate?.policyDate
            let policyId = eventStream.payload.policyId
            
            if eventStream.type == .created {
                
                if let rawVehicle = eventStream.payload.vehicle, let originalId = eventStream.payload.originalPolicyId {
                    let extendedPoliciesWithTransactions: [Policy] = (extendedPolicies[originalId] ?? []).map { policy in
                        var updatedPolicy = policy
                        updatedPolicy.transactions = transactions[policy.id] ?? []
                        return updatedPolicy
                    }
                    let policy = Policy(id: eventStream.payload.policyId, originalId: originalId, startTime: startTime, endTime: endTime, type: eventStream.type, transactions: transactions[policyId] ?? [], extendedPolicies: extendedPoliciesWithTransactions)
                    
                    if vehicles[rawVehicle.vrm] == nil {
                        let vehicle = Vehicle(make: rawVehicle.make,
                                              model: rawVehicle.model,
                                              color: rawVehicle.color,
                                              regNumber: rawVehicle.vrm,
                                              prettyReg: rawVehicle.prettyVrm,
                                              policies: [policy])
                        vehicles[rawVehicle.vrm] = vehicle
                    } else {
                        var latestVehicle = vehicles[rawVehicle.vrm]
                        if policy.isExtended == false {
                            latestVehicle?.policies.append(policy)
                        }
                        vehicles[rawVehicle.vrm] = latestVehicle
                    }
                }
            }
        }
        
        return Array(vehicles.values)
    }
}
