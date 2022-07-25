//
//  RainAndSnow.swift
//  Clima
//
//  Created by Steven Zhang on 3/23/21.
//

import SwiftUI
import AAInfographics

struct RainAndSnow: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    
    var body: some View {
        RainAndSnowView(category: Category(), rain: Rain(), snow: Snow())
    }
    
    private func Rain() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return ($0.rain ?? 0)
        } ?? []
    }
    
    private func Snow() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return ($0.snow ?? 0)
        } ?? []
    }
    
    private func Category() -> [String] {
        return viewModel.region.weather?.daily.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "MMM dd")
        } ?? []
    }
}

fileprivate struct RainAndSnowView: UIViewRepresentable {
    var category: [String]
    var rain: [Double]
    var snow: [Double]
    
    func makeUIView(context: Context) -> some UIView {
        let chartView = AAChartView(frame: UIScreen.main.bounds)
        
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .chartType(.column)
            .animationType(.bounce)
            .title("Rain And Snow")
            .dataLabelsEnabled(false)
            .tooltipValueSuffix("mm")
            .categories(category)
            .colorsTheme(["#0c9674","#7dffc0","#d11b5f","#facd32","#ffffa0","#EA007B"])
            .series([
                AASeriesElement()
                    .name("Rain")
                    .data(rain),
                AASeriesElement()
                    .name("Snow")
                    .data(snow)
            ])
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isClearBackgroundColor = true
        chartView.isScrollEnabled  = false
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct RainAndSnow_Previews: PreviewProvider {
    static var previews: some View {
        RainAndSnow()
            .environmentObject(RegionWeatherViewModel())
    }
}
