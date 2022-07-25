//
//  DailyChartView.swift
//  Clima
//
//  Created by Steven Zhang on 2/14/22.
//

import SwiftUI

struct DailyChartView: View {
    var body: some View {
        TemperatureDaily()
    }
}

struct DailyChartView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChartView()
            .environmentObject(RegionWeatherViewModel())
    }
}
