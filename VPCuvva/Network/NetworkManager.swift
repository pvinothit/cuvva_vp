//
//  APIManager.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

enum NetworkError: String, Error {
    case failed  = "Network request failed"
    case unableToDecode = "unable to decode data"
}

typealias PolicyEventsCompletion = ([Policy], NetworkError?) -> ()

protocol NetworkManagerService {
    func policyEvents(completion: PolicyEventsCompletion)
}

struct APIManager {
    private let apiService = APIService<PolicyApi>()
    
    // Not handled other error codes for test purposes
    func handleResponse(_ response: HTTPURLResponse) -> Result<Any?, NetworkError> {
        switch response.statusCode {
        case 201:
            return .success(nil)
        default:
            return .failure(.failed)
        }
    }
}

extension APIManager: NetworkManagerService {
    func policyEvents(completion: PolicyEventsCompletion) {
        apiService.request(.policyEvents) { data, response, error in
            if let error = error {
                completion(data)
                return
            }
        }
    }
}


