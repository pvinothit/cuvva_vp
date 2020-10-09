//
//  StringsAPI.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 08/10/2020.
//

import Foundation

struct StringsEndPoint: EndPoint {
    let baseURL: URL = URL(string: "http://www.mocky.io")!
    let path: String = "/v2/5c699176370000a90a07fd6f"
    let httpMethod: HTTPMethod = .get
    let task: HTTPTask = .request
    let headers: HTTPHeaders = [:]
}
