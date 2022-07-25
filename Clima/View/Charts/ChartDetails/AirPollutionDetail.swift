//
//  AirPollutionDetail.swift
//  Clima
//
//  Created by Steven Zhang on 3/23/21.
//

import SwiftUI
import AAInfographics

struct AirPollutionDetail: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    
    var body: some View {
        AirPollutionView(category: Categroy(), datas: Components())
    }
    
    private func Components() -> [AirPollution.Componnets] {
        return viewModel.region.airpollution?.list.map {
            $0.components
        } ?? []
    }
    
    private func Categroy() -> [String] {
        return viewModel.region.airpollution?.list.map {
            return ClimaUtils.UTCToDateHour(date: $0.dt, format: "MMM dd")
        } ?? []
    }
}

fileprivate struct AirPollutionView: UIViewRepresentable {
    var category: [String]
    var datas: [AirPollution.Componnets]
    
    func makeUIView(context: Context) -> some UIView {
        let chartView = AAChartView(frame: UIScreen.main.bounds)
        let chartModel = AAChartModel()
            .backgroundColor(AAColor.clear)
            .title("Air Pollution")
            .chartType(.areaspline)
            .animationType(.bounce)
            .dataLabelsEnabled(false)
            .categories(category)
            .tooltipValueSuffix("μg/m3")
            .colorsTheme(["#d11b5f","#facd32","#440a67","#cc561e", "#f39189", "#3a6351"])
            .series([
                AASeriesElement()
                    .name("Carbon Monoxide")
                    .data(datas.map{ return $0.co }),
                AASeriesElement()
                    .name("Nitrogen Dioxide")
                    .data(datas.map{ return $0.no2 }),
                AASeriesElement()
                    .name("Ammonia")
                    .data(datas.map{ return $0.nh3 }),
                AASeriesElement()
                    .name("Ozone")
                    .data(datas.map{ return $0.o3 }),
                AASeriesElement()
                    .name("Coarse Particulate Matter")
                    .data(datas.map{ return $0.pm10 }),
                AASeriesElement()
                    .name("Fine Particulate Matter")
                    .data(datas.map{ return $0.pm2_5 })
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        chartView.isScrollEnabled = false
        chartView.isClearBackgroundColor = true
        
        return chartView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct AirPollutionDetail_Previews: PreviewProvider {
    static var previews: some View {
        AirPollutionDetail()
            .environmentObject(RegionWeatherViewModel())
    }
}
