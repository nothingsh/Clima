//
//  TemperatureDaily.swift
//  Clima
//
//  Created by Steven Zhang on 3/22/21.
//

import SwiftUI
import AAInfographics

struct TemperatureDaily: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    var body: some View {
//        VStack {
//            MaxAndMin(category: Category(), temp: TempRange())
//                .frame(height: geoemtry.size.height/2)
            TemperatureDailyView(category: Category(), temp_morn: TempDaily(type: .morn), temp_day: TempDaily(type: .day), temp_eve: TempDaily(type: .eve), temp_night: TempDaily(type: .night), feels_morn: FeelsDaily(type: .morn), feels_day: FeelsDaily(type: .day), feels_eve: FeelsDaily(type: .eve), feels_night: FeelsDaily(type: .night))
//        }
    }
    
    private func TempDaily(type: TempType) -> [Double] {
        return viewModel.region.weather?.daily.map {
            switch type {
            case .morn:
                return $0.temp.morn
            case .day:
                return $0.temp.day
            case .eve:
                return $0.temp.eve
            case .night:
                return $0.temp.night
            }
            
        } ?? []
    }
    
    private func FeelsDaily(type: TempType) -> [Double] {
        return viewModel.region.weather?.daily.map {
            switch type {
            case .morn:
                return $0.feels_like.morn
            case .day:
                return $0.feels_like.day
            case .eve:
                return $0.feels_like.eve
            case .night:
                return $0.feels_like.night
            }
            
        } ?? []
    }
    
    private func Category() -> [String] {
        return viewModel.region.weather?.daily.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "MMM dd")
        } ?? []
    }
    
    private func TempRange() -> [[Double]] {
        return viewModel.region.weather?.daily.map {
            var pair: [Double] = []
            pair.append($0.temp.min)
            pair.append($0.temp.max)
            return pair
        } ?? [[]]
    }
    
    enum TempType {
        case morn
        case day
        case eve
        case night
    }
}

fileprivate struct TemperatureDailyView: UIViewRepresentable {
    var category: [String]
    var temp_morn: [Double]
    var temp_day: [Double]
    var temp_eve: [Double]
    var temp_night: [Double]
    var feels_morn: [Double]
    var feels_day: [Double]
    var feels_eve: [Double]
    var feels_night: [Double]
    
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
            .subtitle("Temperature (Daily)")
            .dataLabelsEnabled(false)
            .tooltipValueSuffix(AppSetting.shared.content.temperature_type.unit)
            .categories(category)
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([
//                AASeriesElement()
//                    .name("Temperature (Morn)")
//                    .data(temp_morn),
                AASeriesElement()
                    .name("Temperature (Day)")
                    .data(temp_day),
//                AASeriesElement()
//                    .name("Temperature (Eve)")
//                    .data(temp_eve),
                AASeriesElement()
                    .name("Temperature (Night)")
                    .data(temp_night),
//                AASeriesElement()
//                    .name("Feels Like (Morn)")
//                    .data(feels_morn),
                AASeriesElement()
                    .name("Feels Like (Day)")
                    .data(feels_day),
//                AASeriesElement()
//                    .name("Feels Like (Eve)")
//                    .data(feels_eve),
                AASeriesElement()
                    .name("Feels Like (Night)")
                    .data(feels_night),
                ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isClearBackgroundColor = true
        chartView.isScrollEnabled = false
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

fileprivate struct MaxAndMin: UIViewRepresentable {
    var category: [String]
    var temp: [[Double]]
    
    func makeUIView(context: Context) -> some UIView {
        let chartViewWidth  = UIScreen.main.bounds.width
        let chartViewHeight = UIScreen.main.bounds.height
        let chartView = AAChartView()
        chartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .chartType(.columnrange)
            .inverted(true)
            .animationType(.bounce)
            .title("Temperature")
            .subtitle("Temperature Range")
            .dataLabelsEnabled(false)
            .tooltipValueSuffix("°F")
            .categories(category)
            .colorsTheme(["#fe117c"])
            .series([
                AASeriesElement()
                    .name("Temperature")
                    .data(temp),
                ])
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isClearBackgroundColor = true
        chartView.isScrollEnabled = false
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct TemperatureDaily_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureDaily()
            .environmentObject(RegionWeatherViewModel())
    }
}
