//
//  RemoteStrings.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 08/10/2020.
//

import Foundation

struct Display {
    private(set) static var strings: Strings!
    
    static func setStrings(_ display: RemoteStrings) {
        self.strings = display.strings
    }
}
