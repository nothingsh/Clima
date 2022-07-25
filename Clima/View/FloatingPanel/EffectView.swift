//
//  EffectView.swift
//  Clima
//
//  Created by Steven Zhang on 3/13/21.
//

import SwiftUI

internal struct EffectView: UIViewRepresentable {

    internal var effect: UIVisualEffect
    
    
    internal func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: self.effect)
        
        return effectView
    }
    
    internal func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(effect: UIBlurEffect(style: .regular))
    }
}
