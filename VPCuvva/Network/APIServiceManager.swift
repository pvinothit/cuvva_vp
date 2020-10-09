//
//  APIServiceManager.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

enum NetworkStatus {
    case success
    case failed
}

enum NetworkError: Error {
    case failed(String?)
    case noData
    case unableToDecode(String)
}

protocol PolicyService {
    func fetchEventStreams(completion: @escaping (Result<[EventStream]?, NetworkError>) -> ())
}

struct APIServiceManager {
    private let liveAPIService: APIService
    private var cacheService: CacheService?
    
    init(networkService: APIService = LiveAPIService(), cacheService: CacheService = CacheService()) {
        self.liveAPIService = networkService
        self.cacheService = cacheService
    }
    
    private func load<T: Codable>(endpoint: EndPoint, completion: @escaping (Result<T?, NetworkError>) -> ()) {
        
        if let cachedData: T = cacheService?.load(endpoint) {
            completion(.success(cachedData))
        }
        
        liveAPIService.request(endpoint, completion: completion)
    }
}

extension APIServiceManager: PolicyService {
    func fetchEventStreams(completion: @escaping (Result<[EventStream]?, NetworkError>) -> ()) {
        load(endpoint: PolicyEndPoint.eventStreams, completion: completion)
    }
}

extension APIServiceManager: StringsService {
    func syncStrings(completion: @escaping (Result<RemoteStrings?, NetworkError>) -> ()) {
        load(endpoint: StringsEndPoint(), completion: completion)
    }
}
