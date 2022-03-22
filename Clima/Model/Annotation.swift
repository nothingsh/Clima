//
//  Annotation.swift
//  Clima
//
//  Created by Steven Zhang on 3/17/21.
//

import CoreLocation

struct Annotatin {
    var coordinate: CLLocationCoordinate2D
    
    // Weather
    var main: String
    var icon: String
    var temp: Double
    
    var uvi: Double
    
    // Air Pollution
    var aqi: Int
    var pm2_5: Double
    var pm10: Double
    
    // Wind
    var wind_speed: Double
    var wind_deg: Double
    var wind_gust: Double?
    
    var capital: Capital
}

extension Annotatin {
    var weather: WeatherAnnotation {
        return WeatherAnnotation(coordinate: self.coordinate, main: self.main, icon: self.icon, temp: self.temp, capital: self.capital)
    }
    
    var air_pollution: AirPollutionAnnotation {
        return AirPollutionAnnotation(coordinate: self.coordinate, pm2_5: self.pm2_5, pm10: self.pm10, aqi: self.aqi, capital: self.capital)
    }
    
    var uv_index: UVIAnnotation {
        return UVIAnnotation(coordinate: self.coordinate, uvi: self.uvi, capital: self.capital)
    }
}
