//
//  BottomSheetDirection.swift
//  
//
//  Created by Batuhan Baran on 21.03.2023.
//

import Foundation

enum BottomSheetDirection {
    case up
    case down
    
    init(_ velocityY: CGFloat) {
        self = velocityY.isLess(than: .zero) ? .up : .down
    }
}
