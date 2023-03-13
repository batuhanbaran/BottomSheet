//
//  BottomSheetViewModel.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import Foundation

struct BottomSheetViewModel {

    private let properties: BottomSheetProperties
    
    init(properties: BottomSheetProperties) {
        self.properties = properties
    }
    
    var alpha: CGFloat {
        properties.alpha
    }
    
}
