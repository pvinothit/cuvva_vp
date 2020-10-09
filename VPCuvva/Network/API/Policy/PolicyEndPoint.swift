//
//  PolicyEndPoint.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

enum PolicyEndPoint {
    case eventStreams
}

extension PolicyEndPoint: EndPoint {
    var baseURL: URL {
        guard let url = URL(string: "https://cuvva.herokuapp.com") else {
            fatalError("Ooops!!! base url isn't configured")
        }
        return url
    }
    
    var path: String {
        return ""
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .eventStreams:
            return .get
        }
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
}
