//
//  AirPollutionPanel.swift
//  Clima
//
//  Created by Steven Zhang on 3/15/21.
//

import SwiftUI

struct AirPollutionPanel: View {
    var data: AirPollution.Componnets
    
    private let spacing: CGFloat = 12
    private let commonHeight: CGFloat = 70
    private let units: String = "μg/m3"
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(spacing: spacing) {
                let co_level = AirPollutionLevel(co: data.co/1000)
                let o3_level = AirPollutionLevel(o3: data.o3)
                AirPollutionCell(tag: "CO", value: String(format: "%.2f", data.co/1000), unit: "mg/m3", description: co_level.description)
                AirPollutionCell(tag: "O3", value: String(format: "%.2f", data.o3), unit: units, description: o3_level.description)
            }
            .frame(height: commonHeight)
            HStack(spacing: spacing) {
                let no2_level = AirPollutionLevel(no2: data.no2)
                AirPollutionCell(tag: "NO", value: String(format: "%.2f", data.no), unit: units)
                AirPollutionCell(tag: "NO2", value: String(format: "%.2f", data.no2), unit: units, description: no2_level.description)
            }
            .frame(height: commonHeight)
            HStack(spacing: spacing) {
                let so2_level = AirPollutionLevel(so2: data.so2)
                let nh3_level = AirPollutionLevel(nh3: data.nh3)
                AirPollutionCell(tag: "SO2", value: String(format: "%.2f", data.so2), unit: units, description: so2_level.description)
                AirPollutionCell(tag: "NH3", value: String(format: "%.2f", data.nh3), unit: units, description: nh3_level.description)
            }
            .frame(height: commonHeight)
            HStack(spacing: spacing) {
                let pm2_5_level = AirPollutionLevel(pm2_5: data.pm2_5)
                let pm10_level = AirPollutionLevel(pm10: data.pm10)
                GradientRingView(tag: "PM2.5", value:  data.pm2_5, unit: units, description: pm2_5_level.description, percent: pm2_5_level.percent)
                GradientRingView(tag: "PM10", value: data.pm10, unit: units, description: pm10_level.description, percent: pm10_level.percent)
            }
            .frame(height: commonHeight*2.5)
        }
        .padding(.horizontal)
    }
}

struct AirPollutionCell: View {
    var tag: String
    var value: String
    var unit: String
    var description = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(tag)
                        .font(.subheadline)
                    Text(unit).font(.caption2)
                        .foregroundColor(.secondary)
                }
                Text(description)
                    .font(.caption)
            }
            Spacer()
            Text(value)
                .font(.headline)
        }
        .padding()
        .background(
            AppSetting.shared.colorStyle.apBackgroundColor
                .cornerRadius(10)
                .opacity(AppSetting.shared.backgroundOpacity)
                .shadow(color: AppSetting.shared.colorStyle.shadowColor, radius: 6)
        )
    }
}

struct AirPollutionPanel_Previews: PreviewProvider {
    static var previews: some View {
        let data = AirPollution.Componnets(co: 201.940, no: 0.0187, no2: 0.771, o3: 68.664, so2: 0.641, pm2_5: 45.6, pm10: 0.540, nh3: 0.124)
        AirPollutionPanel(data: data)
    }
}
