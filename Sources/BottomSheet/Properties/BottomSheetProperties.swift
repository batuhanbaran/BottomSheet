//
//  BottomSheetProperties.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import Foundation

public struct BottomSheetProperties {
    
    public let alpha: CGFloat
    public let sizes: [BottomSheetSize]
    
    public init(alpha: CGFloat, sizes: [BottomSheetSize]) {
        self.alpha = alpha
        self.sizes = sizes
    }
}
