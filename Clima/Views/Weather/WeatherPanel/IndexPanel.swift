//
//  IndexPanel.swift
//  Clima
//
//  Created by Steven Zhang on 3/16/21.
//

import SwiftUI

struct IndexPanel: View {
    var data: IndexData
    let commonHeight: CGFloat = 70
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 10) {
                PercentageDetailedView(main: "Clouds", icon: "cloud.fill", percentage: data.clouds ?? 0)
                WindsDetailView(speed: data.wind_speed ?? 0, direction: data.wind_deg ?? 360)
                PercentageDetailedView(main: "Humidity", icon: "drop.fill", percentage: data.humidity ?? 0)
            }
            .frame(height: commonHeight*3.5)
            HStack {
                IndexCell(icon: "slash.circle.fill", tag: "Pressure", value: String(format: "%.1f", data.pressure ?? 0.0), unit: "hPa")
                IndexCell(icon: "sun.min.fill", tag: "Ultraviolet index", value: "\(Int(data.uvi_index ?? 0))", unit: "")
            }
            .frame(height: commonHeight)
            HStack {
                IndexCell(icon: "eye.fill", tag: "Visibility", value: "\(Int(data.visibility ?? 0))", unit: AppSetting.shared.content.units.length)
                IndexCell(icon: "cloud.rain.fill", tag: "Precipitation", value: String(format: "%.1f", data.precipitation ?? 0.0), unit: "mm")
            }
            .frame(height: commonHeight)
        }
        .padding(.horizontal)
    }
}

struct IndexData {
    var clouds: Double?
    var pressure: Double?
    var humidity: Double?
    var uvi_index: Double?
    var visibility: Double?
    var precipitation: Double?
    var wind_speed: Double?
    var wind_deg: Double?
}

struct IndexCell: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var icon: String
    var tag: String
    var value: String
    var unit: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(AppSetting.shared.colorStyle.iconColor)
                    Text(value)
                        .font(.title3)
                    Text(unit)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Text(tag)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .padding()
        }
        .background(
            AppSetting.shared.colorStyle.idxBackgroundColor
                .cornerRadius(10)
                .opacity(AppSetting.shared.backgroundOpacity)
                .shadow(color: AppSetting.shared.colorStyle.shadowColor, radius: 6)
            
        )
    }
}

struct IndexPanel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IndexPanel(data: IndexData())
            // PercentageDetailedView(main: "Clouds", icon: "drop.fill", percentage: 72.1)
            WindsDetailView(speed: 5.8, direction: 127)
        }
    }
}

// MARK: - Detailed View
struct PercentageDetailedView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var main: String
    var icon: String
    var percentage: Double
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Text("\(main)")
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .padding(.top, 10)
                WavingView(percent: percentage, main: main, icon: icon)
                    .padding([.bottom, .leading, .trailing], 10)
            }
        }
        .background(
            AppSetting.shared.colorStyle.idxBackgroundColor
                .cornerRadius(10)
                .opacity(AppSetting.shared.backgroundOpacity)
                .shadow(color: AppSetting.shared.colorStyle.shadowColor, radius: 6)
        )
    }
}

struct WindsDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var speed: Double
    var direction: Double
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("Wind")
                    .font(.headline)
                Text("meter/s")
                    .font(.footnote)
                Windmill()
                    .opacity(0.8)
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 15) {
                        Image(systemName: "wind")
                            .foregroundColor(AppSetting.shared.colorStyle.iconColor)
                        Text(String(format: "%.1f", speed))
                            .font(.caption)
                    }
                    HStack(spacing: 15) {
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(AppSetting.shared.colorStyle.iconColor)
                        Text("\(String(format: "%.0f", direction))°")
                            .font(.caption)
                    }
                }
            }
            .padding(10)
        }
        .background(
            AppSetting.shared.colorStyle.idxBackgroundColor
                .cornerRadius(10)
                .opacity(AppSetting.shared.backgroundOpacity)
                .shadow(color: AppSetting.shared.colorStyle.shadowColor, radius: 6)
        )
    }
}


extension Double {
    var uvi_description: String {
        if self <= 2 {
            return "No Protection Required"
        } else if self <= 7 {
            return "Protection Required"
        } else {
            return "Extra Protection Required"
        }
    }
}
