//
//  Pressure.swift
//  Clima
//
//  Created by Steven Zhang on 3/23/21.
//

import SwiftUI
import AAInfographics

struct Pressure: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    
    var body: some View {
        PressureView(pressure: Pressures(), category: Category())
    }
    
    private func Pressures() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return $0.pressure
        } ?? []
    }
    
    private func Category() -> [String] {
        return viewModel.region.weather?.daily.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "MMM dd")
        } ?? []
    }
}

fileprivate struct PressureView: UIViewRepresentable {
    var pressure: [Double]
    var category: [String]
    
    func makeUIView(context: Context) -> some UIView {
        let chartView = AAChartView(frame: UIScreen.main.bounds)
        
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .chartType(.column)
            .animationType(.bounce)
            .title("Pressure")
            .dataLabelsEnabled(false)
            .tooltipValueSuffix("hPa")
            .categories(category)
            .colorsTheme(["#ffffa0","#EA007B"])
            .series([
                AASeriesElement()
                    .name("Pressure")
                    .data(pressure),
            ])
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isClearBackgroundColor = true
        chartView.isScrollEnabled  = false
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct Pressure_Previews: PreviewProvider {
    static var previews: some View {
        Pressure()
            .environmentObject(RegionWeatherViewModel())
    }
}
