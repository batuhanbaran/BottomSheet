//
//  BottomSheetViewPresentable.swift
//  
//
//  Created by Batuhan Baran on 21.03.2023.
//

import UIKit

public protocol BottomSheetViewPresentable {
   
    var cornerRadius: CGFloat { get }
    
    var shouldRoundTopCorners: Bool { get }
    
    var shouldCloseIfTouchDimmedArea: Bool { get }
    
    var isUserInteractionEnabled: Bool { get }
    
    var showDragIndicator: Bool { get }
    
    var dragIndicatorColor: UIColor? { get }
    
    var size: BottomSheetSize { get }
    
}

extension BottomSheetViewPresentable {
    
    var alpha: CGFloat {
        switch size {
        case .half:
            return 0.5
        case .full:
            return 0.75
        case .fix(pct: let pct):
            return pct
        }
    }
}
