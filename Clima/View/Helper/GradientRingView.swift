//
//  GradientRingView.swift
//  Clima
//
//  Created by Steven Zhang on 3/31/21.
//

import SwiftUI

struct GradientRingView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var tag: String
    var value: Double
    var unit: String
    var description = "Good"
    var percent: Double = 0
    
    var body: some View {
        RingView(tag: tag, value: String(format: "%.2f", value), unit: unit, description: description, percent: percent*0.75)
            .padding(5)
        .background(
            AppSetting.shared.colorStyle.apBackgroundColor
                .cornerRadius(10)
                .opacity(AppSetting.shared.backgroundOpacity)
                .shadow(color: AppSetting.shared.colorStyle.shadowColor, radius: 6)
        )
    }
}

struct RingView: View {
    let ringWidth: CGFloat = 10
    var startAngle: Double = 135
    
    var tag: String
    var value: String
    var unit: String
    var description: String
    var percent: Double
        
    static private let ShadowRadius: CGFloat = 5
    static private let ShadowOffsetMultiplier: CGFloat = ShadowRadius + 2
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Ring(percent: 75, startAngle: 135)
                    .stroke(style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .fill(Color.gray.opacity(0.2))
                Circle()
                    .fill(Color.black)
                    .frame(width: ringWidth, height: ringWidth, alignment: .center)
                    .offset(x: getEndCircleLocation(frame: geo.size).0,
                            y: getEndCircleLocation(frame: geo.size).1)
                    .shadow(color: Color.black.opacity(0.2), radius: RingView.ShadowRadius, x: getEndCircleShadowOffset().0, y: getEndCircleShadowOffset().1)
                Ring(percent: percent, startAngle: startAngle)
                    .stroke(style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .fill(ringGradient)
                VStack {
                    Text(tag)
                        .font(.headline)
                    Text(value)
                        .lineLimit(1)
                        .font(.system(size: min(geo.size.width, geo.size.height)*0.25))
                    Text(description)
                        .font(.caption)
                }
                Text(unit)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .offset(x: 0, y: min(geo.size.width, geo.size.height)*0.4)
            }
        }.padding(ringWidth/2)
    }
    
    private var absolutePercentageAngle: Double {
        Ring.percentToAngle(percent: self.percent, startAngle: 0)
    }
    
    private var relativePercentageAngle: Double {
        absolutePercentageAngle + startAngle
    }
    
    private func getEndCircleLocation(frame: CGSize) -> (CGFloat, CGFloat) {
      // Get angle of the end circle with respect to the start angle
      let angleOfEndInRadians: Double = relativePercentageAngle.toRadians()
      let offsetRadius = min(frame.width, frame.height) / 2
      return (offsetRadius * cos(angleOfEndInRadians).toCGFloat(), offsetRadius * sin(angleOfEndInRadians).toCGFloat())
    }
    
    private func getEndCircleShadowOffset() -> (CGFloat, CGFloat) {
        let angleForOffset = absolutePercentageAngle + (self.startAngle + 90)
        let angleForOffsetInRadians = angleForOffset.toRadians()
        let relativeXOffset = cos(angleForOffsetInRadians)
        let relativeYOffset = sin(angleForOffsetInRadians)
        let xOffset = relativeXOffset.toCGFloat() * RingView.ShadowOffsetMultiplier
        let yOffset = relativeYOffset.toCGFloat() * RingView.ShadowOffsetMultiplier
        return (xOffset, yOffset)
    }
    
    
    // Gradient colors
    private let foregroundColors: [Color] = [Color(hex: "00ffff"), Color.green, Color.yellow, Color.orange, Color.red, Color.purple]
    private var firstGradientColor: Color {
        self.foregroundColors.first ?? .black
    }
    private var lastGradientColor: Color {
        self.foregroundColors.last ?? .black
    }
    // 1. Get the start angle for the gradient
    private var gradientStartAngle: Double {
        self.percent >= 100 ? relativePercentageAngle - 360 : startAngle
    }
    // 2. Compute the gradient
    private var ringGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: Array(self.foregroundColors[0...Int(percent*6/100)])),
            center: .center,
            startAngle: Angle(degrees: self.gradientStartAngle),
            endAngle: Angle(degrees: relativePercentageAngle)
        )
    }
}

struct Ring: Shape {
    static func percentToAngle(percent: Double, startAngle: Double) -> Double {
        return (percent/100 * 360) + startAngle
    }
    
    private var startAngle: Double
    private var percent: Double
    private let drawClockwise: Bool
    
    var animatableData: Double {
        get {
            return percent
        }
        set {
            percent = newValue
        }
    }
    
    init(percent: Double = 100, startAngle: Double = -90, drawClockwise: Bool = false) {
        self.percent = percent
        self.startAngle = startAngle
        self.drawClockwise = drawClockwise
    }
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius = min(width, height)/2
        let center = CGPoint(x: width/2, y: height/2)
        let endAngle = Angle(degrees: Ring.percentToAngle(percent: percent, startAngle: startAngle))
        
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle), endAngle: endAngle, clockwise: drawClockwise)
        }
    }
}

extension Double {
    func toRadians() -> Double {
        return self * Double.pi / 180
    }
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

struct GradientRingView_Previews: PreviewProvider {
    static var previews: some View {
        GradientRingView(tag: "CO", value: 35.6, unit: "ug/m3")
    }
}
