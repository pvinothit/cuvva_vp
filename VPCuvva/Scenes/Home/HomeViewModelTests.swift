//
//  HomeViewModelTests.swift
//  VPCuvvaTests
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import XCTest
@testable import VPCuvva

final class PolicyStreamStub: APIService {
    
    enum Stub: String {
        case vehiclesWithOnePolicy = "VehiclesWithOnePolicyStub"
        case vehiclesWithExtendedPolicy = "VehicleWithExtendedPolicyStub"
        case cancelledPolicy = "CancelledPolicyStub"
        case strings = "DisplayStrings"
    }
    
    private let stub: Stub
    
    init(stub: Stub) {
        self.stub = stub
    }
    
    func request<T>(_ endPoint: EndPoint, completion: @escaping (Result<T?, NetworkError>) -> ()) where T : Decodable, T : Encodable {
        let currentBundle = Bundle(for: type(of: self))
        
        if let file = currentBundle.path(forResource: stub.rawValue, ofType: "json") {
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: file)) {
                var events: T?
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    events = try decoder.decode(T.self, from: data)
                } catch (let error) {
                    completion(.failure(.unableToDecode(error.localizedDescription)))
                }
                completion(.success(events))
            }
            
        }
    }
    
    func cancel() {
        
    }
}

final class HomeViewModelTests: XCTestCase {
    
    func testVehiclesWithOnePolicy() {
        let subject = HomeViewModel(policyService: APIServiceManager(networkService: PolicyStreamStub(stub: .vehiclesWithOnePolicy)))
        
        subject.fetchVehicles { _ in }
        let actualVehicles: [Vehicle] = subject.vehicles
        
        XCTAssertEqual(actualVehicles.count, 3)
        if let vehicle = actualVehicles.first(where: { $0.make == "Volkswagen" }) {
            XCTAssertEqual(vehicle.make, "Volkswagen")
            XCTAssertEqual(vehicle.color, "Silver")
            XCTAssertEqual(vehicle.regNumber, "LB07SEO")
            XCTAssertEqual(vehicle.prettyReg, "LB07 SEO")
            XCTAssertEqual(vehicle.policies.count, 1)
            
            let policy = vehicle.policies.first
            
            XCTAssertEqual(policy?.id, "dev_pol_000000BansDm7Jjbj3k4R1IUJwrEe")
            XCTAssertEqual(policy?.transactions.count, 1)
            XCTAssertNotNil(policy?.startTime)
            XCTAssertEqual(policy?.isActive, true)
            
        } else {
            XCTFail("couldn't find volkswagen")
        }
    }
    
    func testVehicleWithExtendedPolicy() {
        let subject = HomeViewModel(policyService: APIServiceManager(networkService: PolicyStreamStub(stub: .vehiclesWithExtendedPolicy)))
                
        subject.fetchVehicles { _ in }
        let actualVehicles: [Vehicle] = subject.vehicles

        XCTAssertEqual(actualVehicles.count, 1)
        
        if let vehicle = actualVehicles.first {
            XCTAssertEqual(vehicle.make, "MINI")
            XCTAssertEqual(vehicle.color, "Silver")
            XCTAssertEqual(vehicle.regNumber, "EF51ZNM")
            XCTAssertEqual(vehicle.prettyReg, "EF51 ZNM")
            XCTAssertEqual(vehicle.policies.count, 1)
            
            let policy = vehicle.policies.first
            
            XCTAssertEqual(policy?.id, "dev_pol_000000Bay4d9zGUK0RBJglMwaCgqW")
            XCTAssertEqual(policy?.transactions.count, 1)
            XCTAssertNotNil(policy?.startTime)
            XCTAssertEqual(policy?.isActive, false)
            XCTAssertEqual(policy?.extendedPolicies.count, 1)
            XCTAssertEqual(policy?.extendedPolicies.first?.transactions.count, 1)
            
        } else {
            XCTFail("couldn't find vehicle")
        }
    }
    
    func testCancelledPolicyStub() {
        let subject = HomeViewModel(policyService: APIServiceManager(networkService: PolicyStreamStub(stub: .cancelledPolicy)))
        
        
        subject.fetchVehicles { _ in }
        let actualVehicles = subject.vehicles

        
        XCTAssertEqual(actualVehicles.count, 1)
        
        if let vehicle = actualVehicles.first {
            XCTAssertEqual(vehicle.make, "Volkswagen")
            XCTAssertEqual(vehicle.color, "Silver")
            XCTAssertEqual(vehicle.regNumber, "LB07SEO")
            XCTAssertEqual(vehicle.prettyReg, "LB07 SEO")
            XCTAssertEqual(vehicle.policies.count, 1)
            let policy = vehicle.policies.first
            
            XCTAssertEqual(policy?.id, "dev_pol_000000BbUEGaXP0JVYH3ge0HItj8K")
            XCTAssertEqual(policy?.transactions.count, 2)
            XCTAssertNotNil(policy?.startTime)
            XCTAssertEqual(policy?.isActive, false)
            XCTAssertEqual(policy?.extendedPolicies.count, 0)
            
        } else {
            XCTFail("couldn't find vehicle")
        }
    }
}
