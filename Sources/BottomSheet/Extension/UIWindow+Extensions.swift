//
//  UIWindow+Extensions.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
