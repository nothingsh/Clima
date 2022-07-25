//
//  DailyForecastPanel.swift
//  Clima
//
//  Created by Steven Zhang on 3/15/21.
//

import SwiftUI

struct DailyForecastPanel: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    var dailies: [ForecastDailyWeather]
    
    var body: some View {
        VStack(spacing: 7) {
            HStack {
                Text("7 Days Forecast")
                    .fontWeight(.medium)
                Spacer()
                NavigationLink {
                    DailyChartView()
                } label: {
                    Image(systemName: "chart.bar")
                }
            }
            Rectangle()
                .frame(height: 1)
            VStack(alignment: .center, spacing: 0) {
                ForEach(dailies.indices, id: \.self) { index in
                    DailyCard(
                        daily: dailies[index],
                        emergencies: viewModel.collectEmergencyInfo(at: dailies[index])
                    )
                        .highPriorityGesture(TapGesture())
                        Rectangle()
                            .frame(height: 1)
                            .scaleEffect(x: 0.95, y: 1)
                            .opacity(0.5)
                }
            }
        }
        .padding(15)
        .background(
            AppSetting.shared.colorStyle.dfBackgroundColor
                .cornerRadius(15)
                .shadow(color: AppSetting.shared.colorStyle.shadowColor, radius: 6)
        )
        .padding(.horizontal)
    }
}

struct DailyCard: View {
    var daily: ForecastDailyWeather
    var emergencies: [EmergencyInfo]
    
    var body: some View {
        GeometryReader { geometry in
            let length = geometry.size.width
            let data = daily.data
            
            HStack(spacing: 0) {
                Text(data.weekday ?? "-")
                    .fontWeight(.medium)
                    .frame(width: length*0.2)
                Image(systemName: data.icon ?? "nosign")
                    .font(.title)
                    .frame(width: length*0.15)
                    .foregroundColor(AppSetting.shared.colorStyle.iconColor)
                Text("\(Int(data.percent ?? 0))%")
                    .lineLimit(1)
                    .frame(width: length*0.15)
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: length*0.1, height: length*0.05)
                    .foregroundColor(self.attentionColor())
                Text(String(format: "%.1f", data.temp_max ?? 0.0))
                    .frame(width: length*0.2)
                Text(String(format: "%.1f", data.temp_min ?? 0.0))
                    .frame(width: length*0.2)
            }
            .sheet(isPresented: $popOver, content: {
                DailyAdditionalInfoView(emergencies: emergencies, date: daily.dt, sunrise: daily.sunrise, sunset: daily.sunset, temp: daily.temp)
            })
        }
        .font(.system(size: 18))
        .frame(height: 40)
        .padding(.vertical, 5)
        .gesture(pressGesture)
    }
    
    private func attentionColor() -> Color {
        if emergencies.count == 0 {
            return Color(hex: "00FFDD")
        } else if emergencies.contains(where: { $0.type == .emergency }) {
            return Color.red
        } else {
            return Color.yellow
        }
    }
    
    @State private var tapping = false
    @State var popOver: Bool = false
    
    var pressGesture: some Gesture {
        return LongPressGesture(minimumDuration: 0.3)
        .onEnded { finished in
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
            
            tapping = false
            popOver = finished
        }
    }
}

struct DailyForecastData: Hashable {
    var weekday: String?
    var icon: String?
    var percent: Double?
    var temp_max: Double?
    var temp_min: Double?
    var attention: String?
}

struct DailyForecastPanel_Previews: PreviewProvider {
    static var previews: some View {
        let data = Array.init(repeating: ForecastDailyWeather(dt: 0, pressure: 0, humidity: 0, clouds: 0, uvi: 0, wind_speed: 0, wind_gust: 0, wind_deg: 0, weather: [WeatherAbbr(id: 0, main: "", description: "", icon: "")], sunrise: 0, sunset: 0, temp: ForecastDailyWeather.DailyTemp(day: 0, morn: 0, eve: 0, night: 0, max: 0, min: 0), feels_like: ForecastDailyWeather.DailyFeelsLike(morn: 0, day: 0, eve: 0, night: 0), pop: 0, rain: 0, snow: 0), count: 7)
        
        DailyForecastPanel(dailies: data)
            .environmentObject(RegionWeatherViewModel())
    }
}
