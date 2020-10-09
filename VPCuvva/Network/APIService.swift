//
//  APIService.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

struct NetworkConfig {
    let cachePolicy: URLRequest.CachePolicy
    let timeout: TimeInterval
    
    static let basic = NetworkConfig(cachePolicy: .useProtocolCachePolicy, timeout: 15)
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

protocol APIService: AnyObject {
    func request<T: Codable>(_ endPoint: EndPoint, completion: @escaping (Result<T?, NetworkError>) -> ())
    func cancel()
}
