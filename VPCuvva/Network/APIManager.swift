//
//  APIManager.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

enum NetworkStatus: String {
    case success
    case failed  = "Network request failed"
}

enum NetworkError: Error {
    case failed
    case unableToDecode
}

typealias NetworkCompletion<T> = (T, NetworkError?) -> ()

protocol PolicyService {
    func eventStreams(completion: @escaping NetworkCompletion<[EventStream]>)
}

struct APIServiceManager {
    private let policyService = APIService<PolicyApi>()
    
    // Not handled other error codes for test purposes
    private func checkStatusCode(_ statusCode: Int) -> NetworkStatus {
        switch statusCode {
        case 201:
            return .success
        default:
            return .failed
        }
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
           completion([], .failed)
           return
       }
       
       if let response = response as? HTTPURLResponse {
           let result = checkStatusCode(response.statusCode)
           guard result == .success else {
               completion([], .failed) // Send Reason
               return
           }
           
           guard let data = data else {
               completion([], .failed) // Send Reason
               return
           }
           
           var events: [EventStream] = []
           do {
               events = try JSONDecoder().decode([EventStream].self, from: data) // Make it generic
           } catch {
               completion([], .unableToDecode)
               return
           }
           completion(events, nil)
       }
    }
    
}

extension APIServiceManager: PolicyService {
    
    func eventStreams(completion: @escaping NetworkCompletion<[EventStream]>) {
        policyService.request(.eventStreams) { data, response, error in
            
        }
    }
}


