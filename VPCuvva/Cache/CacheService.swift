//
//  CacheService.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 08/10/2020.
//

import Foundation

extension EndPoint {
    var fullPath: String {
        return baseURL.absoluteString.appending(path)
    }
    
    var cacheKey: String {
        return "cache_\(fullPath.hash)"
    }
}

struct FileStorage {
    private let manager: FileManager
    
    var baseURL: URL? {
        return try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    init(manager: FileManager = FileManager.default) {
        self.manager = manager
    }
    
}

final class CacheService {
    
    private let storage: FileStorage
    
    init(storage: FileStorage = FileStorage()) {
        self.storage = storage
    }
    
    func load<Item: Codable>(_ endpoint: EndPoint) -> Item? {
        guard endpoint.httpMethod == .get else { return nil }
        if let url = storage.baseURL?.appendingPathComponent(endpoint.cacheKey, isDirectory: false),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try? decoder.decode(Item.self, from: data)
        }
        
        return nil
    }
    
    func save(_ data: Data, for endpoint: EndPoint) {
        guard endpoint.httpMethod == .get else { return }
        if let url = storage.baseURL?.appendingPathComponent(endpoint.cacheKey) {
            _ = try? data.write(to: url)
        }
    }
    
}
