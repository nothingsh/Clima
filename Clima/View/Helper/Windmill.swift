//
//  Windmill.swift
//  Clima
//
//  Created by Steven Zhang on 4/4/21.
//

import SwiftUI

struct Windmill: View {
    var body: some View {
        GeometryReader { geo in
            let length = min(geo.size.width, geo.size.height*0.7)
            
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: length/20, height: geo.size.height-length/2)
                    .offset(x: 0, y: length*0.5)
                WindmillHeader()
                    .frame(height: geo.size.height*0.7)
            }
        }
        .aspectRatio(0.8, contentMode: .fit)
    }
}

struct WindmillHeader: View {
    @State var rotation: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            let length = min(geo.size.width, geo.size.height)
            
            ZStack {
                WindmillLeaf()
                    .fill(Color.orange)
                    .frame(width: length/6, height: length/2, alignment: .center)
                    .offset(x: 0, y: -length*0.25)
                WindmillLeaf()
                    .fill(Color.blue)
                    .frame(width: length/6, height: length/2, alignment: .center)
                    .offset(x: 0, y: -length*0.25)
                    .rotationEffect(Angle(degrees: 120))
                WindmillLeaf()
                    .fill(Color.purple)
                    .frame(width: length/6, height: length/2, alignment: .center)
                    .offset(x: 0, y: -length*0.25)
                    .rotationEffect(Angle(degrees: 240))
                Circle()
                    .fill(Color.red)
                    .frame(width: length/15, height: length/15, alignment: .center)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
            }.rotationEffect(rotation ? Angle(degrees: 360) : .zero)
        }.onAppear() {
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.rotation = true
                }
            }
        }
    }
}

struct WindmillLeaf: Shape {
    func path(in rect: CGRect) -> Path {
//        let ratio: CGFloat = 0.05
        
        return Path { path in
//            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
//            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY*ratio))
//            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.minY-16))
//            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY*(1-ratio)), control: CGPoint(x: rect.midX, y: rect.maxY+16))
//            path.closeSubpath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.midY))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
    
    
}

struct Windmill_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Windmill()
            WindmillLeaf()
        }
    }
}
