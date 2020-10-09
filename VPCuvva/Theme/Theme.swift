//
//  Theme.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 09/10/2020.
//

import UIKit

extension UIColor {
    convenience init(r: UInt8, g: UInt8, b: UInt8, a: CGFloat = 1) {
        self.init(red: (CGFloat(r) / 255.0), green: (CGFloat(g) / 255.0), blue: (CGFloat(b) / 255.0), alpha: a)
    }
}

struct Theme {
    static let shared = Theme(colour: Colour(), font: Font())
    let colour: Colour
    let font: Font
}

struct Colour {
    let background: UIColor = UIColor(r: 239, g: 237, b: 255)
    let primary: UIColor = UIColor(r: 64, g: 71, b: 189)
    let cta: UIColor = UIColor(r: 97, g: 194, b: 146)
}

struct Font {
    let normal = UIFont.systemFont(ofSize: 13)
    let title = UIFont.boldSystemFont(ofSize: 16)
}
