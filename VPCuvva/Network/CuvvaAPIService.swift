//
//  APIService.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

final class APIService<EndPointType: EndPoint>: NetworkService {
    
    private let session: URLSession
    private let configuration: NetworkConfig
    private var task: URLSessionDataTask?
    
    init(session: URLSession = URLSession.shared, configuration: NetworkConfig = .basic) {
        self.session = session
        self.configuration = configuration
    }
    
    func request(_ endPoint: EndPointType, completion: @escaping Response) {
        let request = buildRequest(for: endPoint)
        task = session.dataTask(with: request)
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    // MARK: Request Builder
    
    private func buildRequest(for endPoint: EndPointType) -> URLRequest {
        let apiURL = endPoint.baseURL.appendingPathComponent(endPoint.path)
        var urlRequest = URLRequest(url: apiURL, cachePolicy: configuration.cachePolicy, timeoutInterval: configuration.timeout)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        switch endPoint.task {
        case .request:
            urlRequest.setValue("application/json", forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        return urlRequest
    }
}
