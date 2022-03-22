//
//  Region.swift
//  Clima
//
//  Created by Steven Zhang on 3/7/21.
//

import CoreLocation

struct Region: Codable {
    var name: String?
    var weather: CurrentRegionWeather?
    var coordinate: Coordinate? = .zero
    var airpollution: AirPollution?
}

struct GlobalRegion {
    
}

struct CurrentRegionWeather: Codable {
    let lat: Double
    let lon: Double
    let timezone_offset: Int64
    
    var current: CurrentWeather
    var hourly: [ForecastHourlyWeather]
    var daily: [ForecastDailyWeather]
    
    func output() {
        print("latitude: \(lat) , longitude: \(lon)")
        print("current: ")
        current.weather[0].output()
        print("hourly: ")
        hourly[0].weather[0].output()
        print("daily: ")
        daily[0].weather[0].output()
    }
    
    mutating func timeLocalization() {
        current.dt += timezone_offset
        
        for index in 0..<hourly.count {
            hourly[index].dt += timezone_offset
        }
        for index in 0..<daily.count {
            daily[index].dt += timezone_offset
        }
    }
    
    mutating func tempCelsius() {
        current.tempCelsiusFormal()
        for index in 0..<hourly.count {
            hourly[index].tempCelsiusFormal()
        }
        for index in 0..<daily.count {
            daily[index].tempCelsiusFormal()
        }
        
        print("Tag: Change Temp to celsius")
    }
    
    mutating func tempFaherenheit() {
        current.tempFaherenheitFormal()
        for index in 0..<hourly.count {
            hourly[index].tempFaherenheitFormal()
        }
        for index in 0..<daily.count {
            daily[index].tempFaherenheitFormal()
        }
    }
    
    mutating func unitMetre() {
        current.unitMetreFormal()
        for index in 0..<hourly.count {
            hourly[index].unitMetreFormal()
        }
        for index in 0..<daily.count {
            daily[index].unitMetreFormal()
        }
    }
    
    mutating func unitMile() {
        current.unitMileFormal()
        for index in 0..<hourly.count {
            hourly[index].unitMileFormal()
        }
        for index in 0..<daily.count {
            daily[index].unitMileFormal()
        }
    }
}

struct DecoderTest: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int64
    
    let current: CurrentWeather
    let hourly: [ForecastHourlyWeather]
    let daily: [ForecastDailyWeather]
}

struct WorldWeatherAbbr: Codable {
    let lat: Double
    let lon: Double
    
    let weather: WeatherAbbr
}
