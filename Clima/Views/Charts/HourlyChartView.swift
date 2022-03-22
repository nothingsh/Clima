//
//  HourlyChartView.swift
//  Clima
//
//  Created by Steven Zhang on 2/14/22.
//

import SwiftUI

struct HourlyChartView: View {
    var body: some View {
        TemperatureHourly()
    }
}

struct HourlyChartView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyChartView()
            .environmentObject(RegionWeatherViewModel())
    }
}
