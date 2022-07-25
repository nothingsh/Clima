//
//  WindDetail.swift
//  Clima
//
//  Created by Steven Zhang on 3/23/21.
//

import SwiftUI
import AAInfographics

struct WindDetail: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    
    var body: some View {
        WindDetailView(wind_speed: WindSpeed(), wind_gust: WindGust(), wind_deg: WindDeg(), category: Category())
    }
    
    private func WindSpeed() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return $0.wind_speed
        } ?? []
    }
    
    private func WindGust() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return $0.wind_gust ?? 0
        } ?? []
    }
    
    private func WindDeg() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return $0.wind_deg
        } ?? []
    }
    
    private func Category() -> [String] {
        return viewModel.region.weather?.daily.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "MMM dd")
        } ?? []
    }
}

fileprivate struct WindDetailView: UIViewRepresentable {
    var wind_speed: [Double]
    var wind_gust: [Double]
    var wind_deg: [Double]
    var category: [String]
    
    func makeUIView(context: Context) -> some UIView {
        let chartView = AAChartView(frame: UIScreen.main.bounds)
        
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .chartType(.line)
            .animationType(.bounce)
            .title("Wind")
            .dataLabelsEnabled(false)
            .tooltipValueSuffix(AppSetting.shared.content.units.length)
            .categories(category)
            .colorsTheme(["#ffffa0","#EA007B"])
            .series([
                AASeriesElement()
                    .name("Wind Speed")
                    .data(wind_speed),
                AASeriesElement()
                    .name("Wind Gust")
                    .data(wind_gust)
            ])
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isClearBackgroundColor = true
        chartView.isScrollEnabled  = false
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct WindDetail_Previews: PreviewProvider {
    static var previews: some View {
        WindDetail()
            .environmentObject(RegionWeatherViewModel())
    }
}
