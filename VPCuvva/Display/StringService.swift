//
//  StringService.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 08/10/2020.
//

import Foundation

protocol StringsService {
    func syncStrings(completion: @escaping (Result<RemoteStrings?, NetworkError>) -> ())
}

struct StringsManager {
    private let stringsService: StringsService
    
    init(stringsService: StringsService = APIServiceManager()) {
        self.stringsService = stringsService
    }
    
    func sync() {
        if Display.strings == nil {
            loadLocal()
        }
        stringsService.syncStrings { result in
            switch result {
            case .success(let strings):
                if let strings = strings {
                    Display.setStrings(strings)
                }
            case .failure(let error):
                print("failed \(error.localizedDescription)")
            }
        }
    }
    
    private func loadLocal() {
        if let file = Bundle.main.path(forResource: "Local", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: file)) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let strings = try? decoder.decode(RemoteStrings.self, from: data) {
                    Display.setStrings(strings)
                }
            }
        }
    }
}
