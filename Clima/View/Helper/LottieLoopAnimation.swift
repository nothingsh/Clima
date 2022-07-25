//
//  LottieLoopAnimationController.swift
//  MemoryPair
//
//  Created by Steven Zhang on 3/1/21.
//


import Lottie
import SwiftUI

struct LottieLoopAnimation: UIViewRepresentable {
    var animationName: String
    
    func makeUIView(context: Context) -> UIView {
        let animationView = AnimationView(name: animationName, bundle: .main, animationCache: LRUAnimationCache.sharedCache)
        
        animationView.contentMode = .scaleAspectFit
        animationView.clipsToBounds = false
        animationView.backgroundBehavior = .stop
        animationView.shouldRasterizeWhenIdle = true

        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in
                            print(finished ? "Animation Complete" : "Animation Canceled")
                           })
        
        return animationView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

// MARK: - Testing
struct LottieTestView: View {
    let animationName1 = "running-normal"
    let animationName2 = "running-lighter"
    var body: some View {
        VStack {
            LottieLoopAnimation(animationName: animationName1)
            LottieLoopAnimation(animationName: animationName2)
        }
    }
}

struct LottieTestView_Previews: PreviewProvider {
    static var previews: some View {
        LottieTestView()
    }
}

