//
//  UIViewController+Extension.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import UIKit

@nonobjc extension UIViewController {

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
