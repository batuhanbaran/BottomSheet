//
//  BottomSheetSize.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import UIKit

public enum BottomSheetSize: Equatable {
    case full
    case half
    case fix(pct: CGFloat)
    
    var value: CGFloat {
        switch self {
        case .full:
            return .screenSize.height
        case .half:
            return .screenSize.height.half
        case .fix(let pct):
            return .screenSize.height * pct
        }
    }
}
