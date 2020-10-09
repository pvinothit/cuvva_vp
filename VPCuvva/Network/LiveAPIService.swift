//
//  LiveAPIService.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 06/10/2020.
//

import Foundation

final class LiveAPIService: APIService {
    
    private let session: URLSession
    private let configuration: NetworkConfig
    private var task: URLSessionDataTask?
    private let cacheService: CacheService
    
    init(session: URLSession = URLSession.shared, configuration: NetworkConfig = .basic, cacheService: CacheService = CacheService()) {
        self.session = session
        self.cacheService = cacheService
        self.configuration = configuration
    }
    
    func request<T: Codable>(_ endPoint: EndPoint, completion: @escaping (Result<T?, NetworkError>) -> ()) {
        let request = buildRequest(for: endPoint)
        task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data {
                self.cacheService.save(data, for: endPoint)
            }
            let result: Result<T?, NetworkError> = self.handleResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    // MARK: Request Builder
    
    private func buildRequest(for endPoint: EndPoint) -> URLRequest {
        let apiURL = endPoint.baseURL.appendingPathComponent(endPoint.path)
        var urlRequest = URLRequest(url: apiURL, cachePolicy: configuration.cachePolicy, timeoutInterval: configuration.timeout)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        switch endPoint.task {
        case .request:
            urlRequest.setValue("application/json", forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        return urlRequest
    }
    
    // MARK: Helpers
    
    private func handleResponse<T: Codable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T?, NetworkError> {
        guard error == nil else {
            return .failure(.failed(error?.localizedDescription))
        }
        
        guard let response = response as? HTTPURLResponse else {
            return .failure(.failed(nil))
        }
        
        let result = checkStatusCode(response.statusCode)
        
        guard result == .success else { return .failure(.failed(nil)) }
        guard let data = data else { return .success(nil)}
                
        var events: T?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            events = try decoder.decode(T.self, from: data)
        } catch (let error) {
            return .failure(.unableToDecode(error.localizedDescription))
        }
        return .success(events)
    }
    
    private func checkStatusCode(_ statusCode: Int) -> NetworkStatus {
        switch statusCode {
        case 200:
            return .success
        default:
            return .failed
        }
    }
}
