//
//  RoundCorner.swift
//  Clima
//
//  Created by Steven Zhang on 3/13/21.
//

import SwiftUI

fileprivate struct RoundedCorner: Shape {

    fileprivate var radius: CGFloat = .infinity
    fileprivate var corners: UIRectCorner = .allCorners

    
    fileprivate func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

internal extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner_Previews: PreviewProvider {
    static var previews: some View {
        Rectangle()
            .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}
