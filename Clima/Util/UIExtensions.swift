//
//  UIExtensions.swift
//  Clima
//
//  Created by Steven Zhang on 3/21/21.
//

import MapKit
import SwiftUI

extension AnyTransition {
    static var leftInOut: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var rightIn: AnyTransition {
        let insertion = AnyTransition.opacity
        let removal = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
