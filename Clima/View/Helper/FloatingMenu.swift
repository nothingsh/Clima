//
//  FloatingMenu.swift
//  Clima
//
//  Created by Steven Zhang on 3/24/21.
//

import SwiftUI

struct FloatingMenu: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var activiteMap = false
    @State var activiteSetting = false
    @State var activiteChart = false
    
    @State var show = false
    var raduis: CGFloat = 50
    var length: CGFloat = 30
    
    var body: some View {
        ZStack {
//            VisualEffectBlur(blurStyle: .systemMaterial).edgesIgnoringSafeArea(.all)
//                .opacity(show ? 1 : 0)
//                .animation(.spring())
//                .onTapGesture {
//                    self.show = false
//                }
            // Tool Buttons
            NavigationLink(
                destination: MapViewPage().environmentObject(viewModel),
                isActive: $activiteMap,
                label: {
                    EmptyView()
                })
            NavigationLink(
                destination: DailyChartView().environmentObject(viewModel),
                isActive: $activiteChart,
                label: {
                    EmptyView()
                })
            NavigationLink(
                destination: SettingView().environmentObject(viewModel),
                isActive: $activiteSetting,
                label: {
                    EmptyView()
                })
            ZStack {
                ButtonItem(length: length*0.9, radius: raduis, delay: 0.1, angle: 180, color: "e84393", systemName: "map", activite: $activiteMap, show: $show)
                ButtonItem(length: length*0.9, radius: raduis, delay: 0.2, angle: 135, color: "0984e3", systemName: "chart.bar", activite: $activiteChart, show: $show)
                ButtonItem(length: length*0.9, radius: raduis, delay: 0.3, angle: 90, color: "00b894", systemName: "gearshape", activite: $activiteSetting, show: $show)
                
                // Main Button
                Button(action: {
                    show.toggle()
                }, label: {
                    ZStack {
//                        Color.white
//                            .opacity(0.3)
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: length*0.85)
                            .foregroundColor(.accentColor)
                    }
                    .frame(width: length, height: length)
                    .cornerRadius(length*0.5)
                    //.shadow(color: Color.gray, radius: 8)
                })
            }
        }
    }
}

fileprivate struct ButtonItem: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var length: CGFloat
    var radius: CGFloat
    var delay: Double
    var angle: CGFloat
    var color: String
    var systemName: String
    
    @Binding var activite: Bool
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            activite = true
            show = false
        }, label: {
            ZStack {
                Color.init(hex: color)
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: length*0.7)
                    .foregroundColor(.white)
            }
            .frame(width: length, height: length)
            .cornerRadius(length*0.5)
        })
        .opacity(show ? 1 : 0)
        .offset(x: show ? radius*cos(angle*CGFloat.pi/180) : 0,
                y: show ? radius*sin(angle*CGFloat.pi/180) : 0)
        .animation(Animation.spring().delay(delay))
    }
}

struct FloatingMenu_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenu()
            .environmentObject(RegionWeatherViewModel())
    }
}
