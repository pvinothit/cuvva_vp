//
//  CacheAPIService.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 08/10/2020.
//

import Foundation

final class CacheService {
    
    private let cache: Cache
    
    init(cache: Cache) {
        self.cache = cache
    }
    
    func load<T: Codable>(endpoint: EndPoint, type: T.Type, completion: @escaping NetworkCompletion<T?>) {
        
    }
}
