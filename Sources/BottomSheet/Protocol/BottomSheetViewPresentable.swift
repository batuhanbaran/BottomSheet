//
//  BottomSheetViewPresentable.swift
//  
//
//  Created by Batuhan Baran on 21.03.2023.
//

import UIKit

public protocol BottomSheetViewPresentable {
    var alpha: CGFloat { get }
    
    var cornerRadius: CGFloat { get }
    
    var shouldRoundTopCorners: Bool { get }
    
    var shouldCloseIfTouchDimmedArea: Bool { get }
    
    var isUserInteractionEnabled: Bool { get }
    
    var showDragIndicator: Bool { get }
    
    var dragIndicatorColor: UIColor? { get }
    
    var size: BottomSheetSize { get }
}
