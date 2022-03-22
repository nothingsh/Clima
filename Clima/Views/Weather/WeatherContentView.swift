//
//  WeatherContentView.swift
//  Clima
//
//  Created by Steven Zhang on 3/8/21.
//

import SwiftUI

struct WeatherContentView: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    @Binding var searchingBar: Bool
    
    let data = Array.init(repeating: ForecastDailyWeather(dt: 0, pressure: 0, humidity: 0, clouds: 0, uvi: 0, wind_speed: 0, wind_gust: 0, wind_deg: 0, weather: [WeatherAbbr(id: 0, main: "", description: "", icon: "nosign")], sunrise: 0, sunset: 0, temp: ForecastDailyWeather.DailyTemp(day: 0, morn: 0, eve: 0, night: 0, max: 0, min: 0), feels_like: ForecastDailyWeather.DailyFeelsLike(morn: 0, day: 0, eve: 0, night: 0), pop: 0, rain: 0, snow: 0), count: 7)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                HeaderPanel(data: viewModel.region.weather?.main_panel ?? HeaderPanelData())
                HourlyForecastPanel(data: viewModel.region.weather?.hourly.map{ $0.data } ?? Array.init(repeating: HourlyForecastData(), count: 7))
                DailyForecastPanel(dailies: viewModel.region.weather?.daily ?? data)
                    .environmentObject(viewModel)
                AirPollutionPanel(data: AirpollutionComponent())
                IndexPanel(data: viewModel.region.weather?.index_panel ?? IndexData())
            }
        }
    }
    
    private func AirpollutionComponent() -> AirPollution.Componnets {
        if let dt = viewModel.region.weather?.current.dt, let item = viewModel.region.airpollution?.list.first(where: { $0.dt.convertToDate(format: "dd")  == dt.convertToDate(format: "dd") }) {
            return item.components
        } else {
            return AirPollution.Componnets(co: 0, no: 0, no2: 0, o3: 0, so2: 0, pm2_5: 0, pm10: 0, nh3: 0)
        }
    }
}

struct WeatherContentView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        @State var show = false
        
        var body: some View {
            WeatherContentView(searchingBar: $show)
                .environmentObject(RegionWeatherViewModel())
        }
    }
}
