//
//  BottomSheetProperties.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import UIKit

public struct BottomSheetProperties {
    
    public let alpha: CGFloat
    public let cornerRadius: CGFloat
    public let shouldRoundTopCorners: Bool
    public let showDragIndicator: Bool
    public let dragIndicatorColor: UIColor
    public let size: BottomSheetSize
    
    public init(alpha: CGFloat, cornerRadius: CGFloat, shouldRoundTopCorners: Bool, showDragIndicator: Bool, dragIndicatorColor: UIColor, size: BottomSheetSize) {
        self.alpha = alpha
        self.cornerRadius = cornerRadius
        self.shouldRoundTopCorners = shouldRoundTopCorners
        self.showDragIndicator = showDragIndicator
        self.dragIndicatorColor = dragIndicatorColor
        self.size = size
    }
}
