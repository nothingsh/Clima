//
//  HeaderPanel.swift
//  Clima
//
//  Created by Steven Zhang on 3/15/21.
//

import SwiftUI

struct HeaderPanel: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var data: HeaderPanelData
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            LottieLoopAnimation(animationName: "nightmist")
                .frame(width: Constants.anim, height: Constants.anim)
            Text(data.description ?? "")
                .fontWeight(.medium)
            Text("\(String(format: "%.1f°", data.temperature ?? 0.0))")
                .font(.largeTitle)
                .padding(.top, 5)
            Text(Date().todayDescription)
                .font(.caption)
            HStack {
                Spacer()
                HStack {
                    Text("Feels Like: \(String(format: "%.1f°", data.feels_like ?? 0.0))")
                }
                Spacer()
                HStack {
                    Text("H: \(String(format: "%.1f°", data.temp_max ?? 0.0)) ")
                    Text(" L: \(String(format: "%.1f°", data.temp_min ?? 0.0))")
                }
                .font(.subheadline)
                Spacer()
            }
        }
    }
    
    private struct Constants {
        static let anim: CGFloat = 250
        static let temp: CGFloat = 0.12
    }
}

struct HeaderPanelData {
    var main: String?
    var description: String?
    var icon: String?
    var temperature: Double?
    var temp_min: Double?
    var temp_max: Double?
    var feels_like: Double?
}

struct HeaderPanel_Previews: PreviewProvider {
    static var previews: some View {
        let data = HeaderPanelData(main: "Cloud", description: "overcast clouds", icon: "sun.max.fill", temperature: 23, temp_min: 13, temp_max: 26, feels_like: 21)
        HeaderPanel(data: data)
    }
}
