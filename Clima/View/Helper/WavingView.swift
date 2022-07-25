//
//  WavingView.swift
//  Clima
//
//  Created by Steven Zhang on 3/30/21.
//

import SwiftUI

struct WavingView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var waveOffset = Angle(degrees: 0)
    let percent: Double
    let main: String
    let icon: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.3)
                    .overlay(
                        Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: percent/100)
                            .fill(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10).scale(0.96))
                    )
                    .foregroundColor(Color.blue.opacity(0.65))
                VStack {
                    HStack {
                        Text("\(String(format: "%.1f", percent))")
                        Text("%").foregroundColor(.secondary)
                    }.font(.footnote)
                    Spacer()
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 0.1*min(geo.size.width, geo.size.height))
                        .padding(.bottom, 0.1*min(geo.size.width, geo.size.height))
                        .foregroundColor(AppSetting.shared.colorStyle.iconColor)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    self.waveOffset = Angle(degrees: 360)
                }
            }
        }
    }
}

struct Wave: Shape {
    var offset: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()

        // empirically determined values for wave to be seen
        // at 0 and 100 percent
        let lowfudge = 0.02
        let highfudge = 0.98
        
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = 0.015 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }

}

struct WavingView_Previews: PreviewProvider {
    static var previews: some View {
        WavingView(percent: 60, main: "Clouds", icon: "drop.fill")
    }
}
