//
//  UltravioletIndex.swift
//  Clima
//
//  Created by Steven Zhang on 3/23/21.
//

import SwiftUI
import AAInfographics

struct UltravioletIndex: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    
    var body: some View {
        UltravioletIndexView(index: UVI(), category: Category())
    }
    
    private func UVI() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return $0.uvi
        } ?? []
    }
    
    private func Category() -> [String] {
        return viewModel.region.weather?.daily.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "MMM dd")
        } ?? []
    }
}

fileprivate struct UltravioletIndexView: UIViewRepresentable {
    var index: [Double]
    var category: [String]
    
    func makeUIView(context: Context) -> some UIView {
        let chartView = AAChartView(frame: UIScreen.main.bounds)
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .title("ULtraviolet Index")
            .chartType(.area)
            .animationType(.bounce)
            .dataLabelsEnabled(false)
            .categories(category)
            .colorsTheme(["#d11b5f","#facd32","#ffffa0","#EA007B"])
            .series([
                AASeriesElement()
                    .name("ULtraviolet Index")
                    .data(index)
                    .step(true)
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isScrollEnabled = false
        chartView.isClearBackgroundColor = true
        
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct UltravioletIndex_Previews: PreviewProvider {
    static var previews: some View {
        UltravioletIndex()
            .environmentObject(RegionWeatherViewModel())
    }
}
