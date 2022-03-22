//
//  DailyAdditionalInfoView.swift
//  Clima
//
//  Created by Steven Zhang on 3/26/21.
//

import SwiftUI

struct DailyAdditionalInfoView: View {
    var emergencies: [EmergencyInfo]
    var date: Int64
    var sunrise: Int64
    var sunset: Int64
    var temp: ForecastDailyWeather.DailyTemp
    
    let dateFormat = "EE. YYY DD. MM"
    let timeFormat = "HH:MM"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(date.convertToDate(format: dateFormat))
                    .font(.title)
                VStack {
                    HStack {
                        Sunriseset(isRise: true, time: sunrise.convertToDate(format: timeFormat))
                        Sunriseset(isRise: false, time: sunset.convertToDate(format: timeFormat))
                    }
                    HStack {
                        TempRect(time: "morn", value: temp.morn, unit: "°C", color: Color(hex: "f5c0c0"))
                        TempRect(time: "day", value: temp.day, unit: "°C", color:Color(hex: "ffaec0"))
                    }
                    HStack {
                        TempRect(time: "eve", value: temp.eve, unit: "°C", color: Color(hex: "b4aee8"))
                        TempRect(time: "night", value: temp.night, unit: "°C", color: Color(hex: "9fd8df"))
                    }
                }
                ForEach(emergencies.indices, id: \.self) { index in
                    ToastItemView(toast: emergencies[index])
                }
            }
            .padding()
        }
    }
}

struct ToastItemView: View {
    var toast: EmergencyInfo
    
    let default_back: Gradient = Gradient(colors: [Color.purple, Color.pink])
    
    var body: some View{
        HStack {
            ZStack {
                Circle()
                    .fill(Color.white)
                Image(systemName: toast.icon)
                    .resizable()
                    .foregroundColor(toast.type.color)
                    .padding(10)
            }
            .scaledToFit()
            VStack(alignment: .leading) {
                Text(toast.main ?? "")
                    .font(.title3)
                    .bold()
                Text(toast.description ?? "")
                    .font(.subheadline)
                    .lineLimit(2)
            }
            Spacer()
            HStack(alignment: .lastTextBaseline) {
                Text(String(format: "%.1f", toast.value ?? 0))
                    .font(.title2)
                Text(toast.unit ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: toast.background ?? default_back, startPoint: .leading, endPoint: .trailing)
        )
        .frame(height: 80)
        .cornerRadius(15)
    }
}

fileprivate struct Sunriseset: View {
    var isRise: Bool
    var time: String
    
    let sunriseFore = Color(hex: "f39189")
    let sunsetFore = Color(hex: "ff5e78")
    
    let sunriseBack = Color(hex: "4a47a3")
    let sunsetBack = Color(hex: "413c69")
    
    let sunriseImage = "sunrise.fill"
    let sunsetImage = "sunset.fill"
    
    var body: some View {
        HStack {
            Image(systemName: (isRise ? sunriseImage : sunsetImage))
                .foregroundColor(isRise ? sunriseFore : sunsetFore)
            Spacer()
            Text(time)
                
                .foregroundColor(.white)
            Spacer()
        }
        .font(.title2)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isRise ? sunriseBack : sunsetBack)
        )
    }
}

fileprivate struct TempRect: View {
    var time: String
    var value: Double
    var unit: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(time)
                .font(.headline)
            HStack(alignment: .lastTextBaseline) {
                Text(String(format: "%.1f", value))
                    .font(.title)
                Text(unit)
                    .font(.footnote)
                Spacer()
            }
        }
        .padding(10)
        .background(
            color
                .cornerRadius(10)
        )
    }
}

// MARK: - Test
struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        let toasts = [EmergencyInfo(type: .warning, icon: "aqi.medium", main: "PM 2.5", background: nil, value: 23.5, unit: "ug/m3", description: "Moderate"), EmergencyInfo(type: .emergency, icon: "aqi.high", main: "PM 10", background: nil, value: 234.2, unit: "ug/m3", description: "Severe")]
        Group {
            DailyAdditionalInfoView(emergencies: toasts, date: 0, sunrise: 13727, sunset: 137291, temp: ForecastDailyWeather.DailyTemp(day: 0, morn: 0, eve: 0, night: 0, max: 0, min: 0))
            //TempRect(time: "morn", value: 25.3, unit: "°C", color: Color(hex: "7b113a"))
        }
    }
}
