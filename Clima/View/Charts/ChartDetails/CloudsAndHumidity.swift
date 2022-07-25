//
//  CloudsAndHumidity.swift
//  Clima
//
//  Created by Steven Zhang on 3/22/21.
//

import SwiftUI
import AAInfographics

struct CloudsAndHumidity: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    
    var body: some View {
        CloudsAndHumidityView(clouds: Clouds(), humidity: Humidity(), category: Category())
    }
    
    private func Clouds() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return $0.clouds
        } ?? []
    }
    
    private func Humidity() -> [Double] {
        return viewModel.region.weather?.daily.map {
            return $0.humidity
        } ?? []
    }
    
    private func Category() -> [String] {
        return viewModel.region.weather?.daily.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "MMM dd")
        } ?? []
    }
}

fileprivate struct CloudsAndHumidityView: UIViewRepresentable {
    var clouds: [Double]
    var humidity: [Double]
    var category: [String]
    
    func makeUIView(context: Context) -> some UIView {
        let chartViewWidth  = UIScreen.main.bounds.width
        let chartViewHeight = UIScreen.main.bounds.height
        let chartView = AAChartView()
        chartView.frame = CGRect(x:0,y:0,width: chartViewWidth, height: chartViewHeight)
        
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .chartType(.bar)
            .animationType(.bounce)
            .title("Clouds And Humidity")
            .subtitle("Forecast")
            .dataLabelsEnabled(false)
            .tooltipValueSuffix("%")
            .categories(category)
            .colorsTheme(["#ccffbd", "#f39189"])
            .series([
                AASeriesElement()
                    .name("Clouds")
                    .data(clouds),
                AASeriesElement()
                    .name("Humidity")
                    .data(humidity),
                ])
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isClearBackgroundColor = true
        chartView.isScrollEnabled = false
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct CloudsAndHumidity_Previews: PreviewProvider {
    static var previews: some View {
        CloudsAndHumidity()
            .environmentObject(RegionWeatherViewModel())
    }
}
