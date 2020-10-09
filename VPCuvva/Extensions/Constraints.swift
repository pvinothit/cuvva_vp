//
//  Constraints.swift
//  VPCuvva
//
//  Created by Vinoth Palanisamy on 09/10/2020.
//

import UIKit

enum Constraints {
    case fit(Inset)
    case center
    case belowLeft(UIView,Inset)
    case belowAndFit(UIView, Inset)
    case pinTopLeft(Inset)
    case pinTopLeftWH(Inset, Height)
    case pinRight(Inset)
    case pinRightTo(UIView, Inset)
    case pinRightAndBelow(UIView, belowTo: UIView, Inset)
}

typealias Height = CGFloat
typealias Width = CGFloat

struct Inset {
    let leading: CGFloat
    let trailing: CGFloat
    let top: CGFloat
    let bottom: CGFloat
    
    private static let standardPadding: CGFloat = 10
    static let zero = Inset(leading: 0, trailing: 0, top: 0, bottom: 0)
    static let standard = Inset(leading: standardPadding, trailing: -standardPadding, top: standardPadding, bottom: -standardPadding)
    static func custom(leading: CGFloat = 0, trailing: CGFloat = 0,top: CGFloat = 0, bottom: CGFloat = 0) -> Inset {
        return Inset(leading: leading, trailing: trailing, top: top, bottom: bottom)
    }
}

extension UIView {
    
    func addAutoSubView(_ view: UIView, contraints: Constraints? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        guard let constraints = contraints else { return }
        
        let marginGuide = layoutMarginsGuide
        
        switch constraints {
        case .fit(let inset):
            view.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: inset.top).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.leading).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: inset.trailing).isActive = true
            view.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: inset.bottom).isActive = true
             
        case .center:
          view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
          view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
        case .belowLeft(let topView, let inset):
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: inset.top).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.leading).isActive = true
            
        case .belowAndFit(let topView, let inset):
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: inset.top).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.leading).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: inset.trailing).isActive = true
            
        case .pinTopLeft(let inset):
            view.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.trailing).isActive = true
            
        case .pinTopLeftWH(let inset, let size):
            view.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.leading).isActive = true
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
            view.widthAnchor.constraint(equalToConstant: size).isActive = true
       
        case .pinRight(let inset):
            view.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: inset.leading).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset.bottom).isActive = true
            
        case .pinRightTo(let leftView, let inset):
            view.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
            view.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: inset.leading).isActive = true
            
        case .pinRightAndBelow(let leftView, let topView, let inset):
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: inset.top).isActive = true
            view.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: inset.leading).isActive = true
        }
    }
}

