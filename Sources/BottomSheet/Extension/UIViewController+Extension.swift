//
//  UIViewController+Extension.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import UIKit

@nonobjc
extension UIViewController {

    var topBarHeight: CGFloat {
        var top = (self.navigationController?.navigationBar.frame.height ?? 0.0) / 2
        
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        
        return top
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
