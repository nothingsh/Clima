//
//  Weather.swift
//  Clima
//
//  Created by Steven Zhang on 3/8/21.
//

import Foundation

// MARK: - Current Weather
struct CurrentWeather: Codable {
    var dt: Int64
    let pressure: Double
    let humidity: Double
    let clouds: Double
    let uvi: Double
    var visibility: Double
    var wind_speed: Double
    var wind_gust: Double?
    let wind_deg: Double
    let weather: [WeatherAbbr]
    
    let sunrise: Int64
    let sunset: Int64
    var temp: Double
    var feels_like: Double
    
    mutating func tempCelsiusFormal() {
        self.temp = temp.temp_celsius
        self.feels_like = feels_like.temp_celsius
    }
    
    mutating func tempFaherenheitFormal() {
        self.temp = temp.temp_faherenheit
        self.feels_like = feels_like.temp_faherenheit
    }
    
    mutating func unitMetreFormal() {
        self.visibility = visibility.length_metre
        self.wind_speed = wind_speed.length_metre
        self.wind_gust = wind_gust?.length_metre
    }
    
    mutating func unitMileFormal() {
        self.visibility = visibility.length_mile
        self.wind_speed = wind_speed.length_mile
        self.wind_gust = wind_gust?.length_mile
    }
}

// MARK: - Hourly
struct ForecastHourlyWeather: Codable {
    var dt: Int64
    let pressure: Double
    let humidity: Double
    let clouds: Double
    let uvi: Double
    var visibility: Double
    var wind_speed: Double
    var wind_gust: Double?
    let wind_deg: Double
    let weather: [WeatherAbbr]
    
    var temp: Double
    var feels_like: Double
    let pop: Double
    
    mutating func tempCelsiusFormal() {
        self.temp = temp.temp_celsius
        self.feels_like = feels_like.temp_celsius
    }
    
    mutating func tempFaherenheitFormal() {
        self.temp = temp.temp_faherenheit
        self.feels_like = feels_like.temp_faherenheit
    }
    
    mutating func unitMetreFormal() {
        self.visibility = visibility.length_metre
        self.wind_speed = wind_speed.length_metre
        self.wind_gust = wind_gust?.length_metre
    }
    
    mutating func unitMileFormal() {
        self.visibility = visibility.length_mile
        self.wind_speed = wind_speed.length_mile
        self.wind_gust = wind_gust?.length_mile
    }
}

// MARK: - Daily
struct ForecastDailyWeather: Codable {
    var dt: Int64
    let pressure: Double
    let humidity: Double
    let clouds: Double
    let uvi: Double
    var wind_speed: Double
    var wind_gust: Double?
    let wind_deg: Double
    let weather: [WeatherAbbr]

    let sunrise: Int64
    let sunset: Int64
    var temp: DailyTemp
    var feels_like: DailyFeelsLike
    let pop: Double
    let rain: Double?
    let snow: Double?
    
    mutating func tempCelsiusFormal() {
        self.temp.dailyTempCelsius()
        self.feels_like.dailyFeelsCelsius()
    }
    
    mutating func tempFaherenheitFormal() {
        self.temp.dailyTempFaherenheit()
        self.feels_like.dailyFeelsFaherenheit()
    }
    
    mutating func unitMetreFormal() {
        self.wind_speed = wind_speed.length_metre
        self.wind_gust = wind_gust?.length_metre
    }
    
    mutating func unitMileFormal() {
        self.wind_speed = wind_speed.length_mile
        self.wind_gust = wind_gust?.length_mile
    }
    
    struct DailyTemp: Codable {
        var day: Double
        var morn: Double
        var eve: Double
        var night: Double
        var max: Double
        var min: Double
        
        mutating func dailyTempCelsius() {
            day = day.temp_celsius
            morn = morn.temp_celsius
            eve = eve.temp_celsius
            night = night.temp_celsius
            max = max.temp_celsius
            min = min.temp_celsius
        }
        
        mutating func dailyTempFaherenheit() {
            day = day.temp_faherenheit
            morn = morn.temp_faherenheit
            eve = eve.temp_faherenheit
            night = night.temp_faherenheit
            max = max.temp_faherenheit
            min = min.temp_faherenheit
        }
    }
    
    struct DailyFeelsLike: Codable {
        var morn: Double
        var day: Double
        var eve: Double
        var night: Double
        
        mutating func dailyFeelsCelsius() {
            day = day.temp_celsius
            morn = morn.temp_celsius
            eve = eve.temp_celsius
            night = night.temp_celsius
        }
        
        mutating func dailyFeelsFaherenheit() {
            day = day.temp_faherenheit
            morn = morn.temp_faherenheit
            eve = eve.temp_faherenheit
            night = night.temp_faherenheit
        }
    }
}


// MARK: - Air Pollution
struct AirPollution: Codable {
    let coord: Coord
    let list: [List]
    
    struct Coord: Codable {
        let lat: Double
        let lon: Double
    }
    
    struct List: Codable {
        var dt: Int64
        let main: MainAirPollution
        let components: Componnets
    }
    
    struct MainAirPollution: Codable {
        let aqi: AirQualityIndex
    }
    
    enum AirQualityIndex: Int, Codable {
        case good = 1, fair, moderate, poor, verypoor
    }
    
    struct Componnets: Codable {
        let co: Double
        let no: Double
        let no2: Double
        let o3: Double
        let so2: Double
        let pm2_5: Double
        let pm10: Double
        let nh3: Double
    }
}

struct Alert: Codable {
    let sender_name: String
    let event: String
    let start: Int64
    let end: Int64
    let description: String
}

struct WeatherAbbr: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    func output() {
        print("id: \(id), main: \(main), icon: \(icon)")
        print(description)
    }
}

extension WeatherAbbr {
    var localIcon: String {
        let type = WeatherMain(rawValue: self.main)
        let time = icon.last
        let rainthuner = [200, 201, 202, 230, 231, 232]
        let heavyrain = [502, 503, 504, 521, 522]
        
        switch type {
        case .Thunderstorm:
            if time == "d" {
                if rainthuner.contains(id) {
                    return "cloud.bolt.rain.fill"
                } else {
                    return "cloud.bolt.fill"
                }
            } else {
                return "cloud.moon.bolt.fill"
            }
        case .Drizzle:
            return "cloud.drizzle.fill"
        case .Rain:
            if time == "d" {
                if heavyrain.contains(id) {
                    return "cloud.heavyrain.fill"
                } else if id == 511 {
                    return "cloud.hail.fill"
                } else {
                    return "cloud.rain.fill"
                }
            } else {
                return "cloud.moon.rain.fill"
            }
        case .Snow:
            if id == 611 {
                return "cloud.sleet.fill"
            }
            else {
                return "cloud.snow.fill"
            }
        case .Clouds:
            if id == 803 || id == 804 {
                return "smoke.fill"
            } else if time == "n" {
                return "cloud.moon.fill"
            } else {
                return "cloud.fill"
            }
        case .Clear:
            if time == "n" {
                return "moon.stars.fill"
            } else {
                return "sun.min.fill"
            }
            
        case .Mist, .Fog:
            return "cloud.fog.fill"
        case .Tornado:
            return "tornado"
        case .Haze:
            if time == "d" {
                return "sun.haze.fill"
            } else {
                return "aqi.high"
            }
        case .Ash, .Dust, .Sand:
            if time == "d" {
                return "sun.dust.fill"
            } else {
                return "aqi.high"
            }
        case .Smoke:
            return "smoke.fill"
        case .Squall:
            return "hurricane"
        case .none:
            return ""
        }
    }
}

extension Double {
    var temp_celsius: Double {
        return (self-32) * 5/9
    }
    
    var temp_faherenheit: Double {
        return self*9/5 + 32
    }
    
    var length_mile: Double {
        return self*0.000621371
    }
    
    var length_metre: Double {
        return self/0.000621371
    }
}

extension Int64 {
    /// Turn dt into user friendly string
    func convertToDate(format: String) -> String {
        let dFormat = DateFormatter()
        dFormat.dateFormat = format
        dFormat.timeZone = TimeZone(identifier: "GMT")
        
        // you can use a fixed language locale
        // dFormat.locale = Locale(identifier: "zh")
        // or use the current locale
        // dFormat.locale = .current
        
        let temp_date = Date(timeIntervalSince1970: TimeInterval(self))
        
        return dFormat.string(from: temp_date)
    }
}


extension ForecastDailyWeather {
    func parseingToast() -> [Emergency] {
        
        return []
    }
    
    var data: DailyForecastData {
        return DailyForecastData(weekday: self.dt.convertToDate(format: "EE"),
                                 icon: self.weather[0].localIcon,
                                 percent: self.pop,
                                 temp_max: self.temp.max,
                                 temp_min: self.temp.max,
                                 attention: ""
        )
    }
}

extension AirPollution {
    func dailyEmergency(at dt: Int64) -> [EmergencyInfo] {
        var emergencies: [EmergencyInfo] = []
        
        if let index = self.list.firstIndex(where: { dt.convertToDate(format: "dd") == $0.dt.convertToDate(format: "dd") }) {
            let component = list[index].components
            if var nh3 = AirPollutionLevel(nh3: component.nh3).toast {
                nh3.main = "NH3"
                nh3.unit = "ug/m3"
                nh3.value = component.nh3
                emergencies.append(nh3)
            }
            
            if var co = AirPollutionLevel(co: component.co/1000).toast {
                co.main = "CO"
                co.unit = "mg/m3"
                co.value = component.co/1000
                emergencies.append(co)
            }
            
            if var no2 = AirPollutionLevel(no2: component.no2).toast {
                no2.main = "NO2"
                no2.unit = "ug/m3"
                no2.value = component.no2
                emergencies.append(no2)
            }
            
            if var o3 = AirPollutionLevel(o3: component.o3).toast {
                o3.main = "O3"
                o3.unit = "ug/m3"
                o3.value = component.o3
                emergencies.append(o3)
            }
            
            if var pm10 = AirPollutionLevel(pm10: component.pm10).toast {
                pm10.main = "PM 10"
                pm10.unit = "ug/m3"
                pm10.value = component.pm10
                emergencies.append(pm10)
            }
            
            if var pm2_5 = AirPollutionLevel(pm2_5: component.pm2_5).toast {
                pm2_5.main = "PM 2.5"
                pm2_5.unit = "ug/m3"
                pm2_5.value = component.pm2_5
                emergencies.append(pm2_5)
            }
            
            if var so2 = AirPollutionLevel(so2: component.so2).toast {
                so2.main = "SO2"
                so2.unit = "ug/m3"
                so2.value = component.so2
                emergencies.append(so2)
            }
        }
        return emergencies
    }
}
