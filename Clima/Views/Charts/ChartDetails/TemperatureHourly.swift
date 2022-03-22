//
//  TemperatureHourly.swift
//  Clima
//
//  Created by Steven Zhang on 3/22/21.
//

import SwiftUI
import AAInfographics

struct TemperatureHourly: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    
    var body: some View {
        TemperatureHourlyView(category: Category(), temp: Temp(), feels: Feels())
    }
    
    private func Temp() -> [Double] {
        return viewModel.region.weather?.hourly.map {
            return $0.temp
        } ?? []
    }
    
    private func Feels() -> [Double] {
        return viewModel.region.weather?.hourly.map {
            return $0.feels_like
        } ?? []
    }
    
    private func Category() -> [String] {
        return viewModel.region.weather?.hourly.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "hh:mm")
        } ?? []
    }
}

fileprivate struct TemperatureHourlyView: UIViewRepresentable {
    var category: [String]
    var temp: [Double]
    var feels: [Double]
    
    func makeUIView(context: Context) -> AAChartView {
        let chartViewWidth  = UIScreen.main.bounds.width
        let chartViewHeight = UIScreen.main.bounds.height
        let chartView = AAChartView()
        chartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .chartType(.spline)
            .animationType(.bounce)
            .title("Temperature")
            .subtitle("Temperature in hour")
            .dataLabelsEnabled(false)
            .tooltipValueSuffix(AppSetting.shared.content.temperature_type.unit)
            .categories(category)
            .colorsTheme(["#fe117c","#06caf4"])
            .series([
                AASeriesElement()
                    .name("Temperature")
                    .data(temp),
                AASeriesElement()
                    .name("Feels Like")
                    .data(feels),
                ])
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isClearBackgroundColor = true
        chartView.scrollEnabled = false
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct TemperatureHourly_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureHourly()
            .environmentObject(RegionWeatherViewModel())
    }
}
