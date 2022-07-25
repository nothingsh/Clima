//
//  WeatherAnnotationView.swift
//  Clima
//
//  Created by Steven Zhang on 3/17/21.
//

import MapKit
import SwiftUI
import Lottie

class WeatherAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(animationView)
        animationView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        let diameter = CGFloat(15)
        self.frame.size = CGSize(width: diameter, height: diameter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.clipsToBounds = false
        animationView.backgroundBehavior = .pauseAndRestore

        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in
                            print(finished ? "Animation Complete" : "Animation Canceled")
                           })
        
        return animationView
    }()
    
    override func prepareForDisplay() {
        if let annoattion = annotation as? WeatherAnnotation {
            
            let animation = Animation.named(annoattion.icon)
            animationView.animation = animation
        }
        
        setNeedsLayout()
    }
}
