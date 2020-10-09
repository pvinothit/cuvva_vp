//
//  String+Extensions.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 07/10/2020.
//

import Foundation

extension String {
    var policyDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
}
