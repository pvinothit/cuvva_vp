//
//  NavigationController.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 05/10/2020.
//

import Foundation
import UIKit

final class NavigationController: UINavigationController {
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override  var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
