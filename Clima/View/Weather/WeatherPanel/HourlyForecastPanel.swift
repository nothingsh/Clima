//
//  HourlyForecastPanel.swift
//  Clima
//
//  Created by Steven Zhang on 3/15/21.
//

import SwiftUI

struct HourlyForecastPanel: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    var data: [HourlyForecastData]
    
    var body: some View {
        VStack(spacing: 7) {
            HStack {
                Text("Hourly Forecast")
                    .fontWeight(.medium)
                Spacer()
                NavigationLink {
                    HourlyChartView()
                        .environmentObject(viewModel)
                } label: {
                    Image(systemName: "chart.bar")
                }
            }
            .padding([.horizontal, .top], 15)
            Rectangle()
                .frame(height: 1)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(data.indices, id: \.self) { index in
                        HourlyCard(data: data[index])
                            .highPriorityGesture(TapGesture())
                    }
                }
                .padding([.horizontal, .bottom], 15)
            }
        }
        .background(
            AppSetting.shared.colorStyle.hfBackgroundColor
                .opacity(0.6)
                .cornerRadius(15)
        )
        .shadow(color: AppSetting.shared.colorStyle.shadowColor, radius: 6)
        .padding(.horizontal)
    }
}

struct HourlyCard: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var data: HourlyForecastData
    
    private let width: CGFloat = 60
    private let height: CGFloat = 80
    private let fontSize: CGFloat = 15
    private let imageSize: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(data.time ?? "-")
                .font(.system(size: fontSize))
            Image(systemName: data.icon ?? "nosign")
                .resizable()
                .scaledToFit()
                .frame(height: imageSize)
                .foregroundColor(AppSetting.shared.colorStyle.iconColor)
            Text(String(format: "%.1f°", data.temperature ?? "0.0"))
                .font(.system(size: fontSize))
                .fontWeight(.medium)
        }
        .scaleEffect(tapping ? 0.9 : 1)
        .gesture(pressGesture)
    }
    
    // MARK: - Long Press Gesture (Useless)
    
    @State private var tapping = false
    @State var popOver: Bool = false
    
    var pressGesture: some Gesture {
        let longPress = LongPressGesture(minimumDuration: 0.6)
        .onEnded { finished in
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
            
            popOver = finished
            tapping = false
        }
        
        let tapGesture = DragGesture(minimumDistance: 0)
            .onChanged {_ in
                tapping = true
            }
            .onEnded {_ in
                tapping = false
            }
        return tapGesture.simultaneously(with: longPress)
    }
    
}

struct HourlyForecastData: Hashable {
    var time: String?
    var icon: String?
    var temperature: Double?
}

struct HourlyForecastPanel_Previews: PreviewProvider {
    static var previews: some View {
        let data = Array<HourlyForecastData>.init(repeating: HourlyForecastData(), count: 7)
        HourlyForecastPanel(data: data)
    }
}
