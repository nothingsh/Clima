//
//  SheetLayout.swift
//  Clima
//
//  Created by Steven Zhang on 3/14/21.
//

import SwiftUI

enum LayoutMode {
    case portrait
    // iPad only have landscape mode
    case landscape
}

enum OffsetRatio: CGFloat, CaseIterable {
    case top = 0.975, middle = 0.4, bottom = 0.125, hidden = 0
    
    func properSize(mode: LayoutMode) -> CGFloat {
        if mode == .portrait {
            return self.rawValue
        } else {
            switch self {
            case .top:
                return 0.525
            case .middle:
                return 0.025
            default:
                return 0
            }
        }
    }
}
