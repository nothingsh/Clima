//
//  AnnotationModel.swift
//  Clima
//
//  Created by Steven Zhang on 3/17/21.
//

import MapKit

class WeatherAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var main: String
    var icon: String
    var temp: Double
    var title: String?
    var subtitle: String?
    var capital: Capital
    
    init(coordinate: CLLocationCoordinate2D, main: String, icon: String, temp: Double, capital: Capital) {
        self.coordinate = coordinate
        self.main = main
        self.icon = icon
        self.temp = temp
        self.capital = capital
        self.title = main
        self.subtitle = "Temperature: \(String(format: "%.1f", temp))"
        
        super.init()
    }
}

class AirPollutionAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pm2_5: Double
    var pm10: Double
    var aqi: Int
    var title: String?
    var subtitle: String?
    var capital: Capital
    
    init(coordinate: CLLocationCoordinate2D, pm2_5: Double, pm10: Double, aqi: Int, capital: Capital) {
        self.coordinate = coordinate
        self.pm10 = pm10
        self.pm2_5 = pm2_5
        self.aqi = aqi
        self.capital = capital
        self.title = "\(AQI(rawValue: aqi)!.description)"
        self.subtitle = "PM2.5: \(String(format: "%.1f", pm2_5))\nPM10: \(String(format: "%.1f", pm10))"
        
        super.init()
    }
}

class UVIAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var uvi: Double
    var title: String?
    var subtitle: String?
    var capital: Capital
    
    init(coordinate: CLLocationCoordinate2D, uvi: Double, capital: Capital) {
        self.coordinate = coordinate
        self.uvi = uvi
        self.title = "uvi: \(String(format: "%.0f", uvi))"
        self.subtitle = "Ultraviolet \(UVI(uvi: Int(uvi)).description)"
        self.capital = capital
        
        super.init()
    }
}

enum UVI {
    case low
    case moderate
    case high
    case very_high
    case extrem_high
    
    var range: Range<Int> {
        switch self {
        case .low:
            return 0..<3
        case .moderate:
            return 3..<6
        case .high:
            return 6..<8
        case .very_high:
            return 8..<11
        case .extrem_high:
            return 11..<Int.max
        }
    }
    
    init(uvi: Int) {
        switch uvi {
        case UVI.low.range:
            self = UVI.low
        case UVI.moderate.range:
            self = UVI.moderate
        case UVI.high.range:
            self = UVI.high
        case UVI.very_high.range:
            self = UVI.very_high
        case UVI.extrem_high.range:
            self = UVI.extrem_high
        default:
            fatalError()
        }
    }
    
    var color: UIColor {
        switch self {
        case .low:
            return .green
        case .moderate:
            return .yellow
        case .high:
            return .orange
        case .very_high:
            return .red
        case .extrem_high:
            return .purple
        }
    }
    
    var ratio: CGFloat {
        switch self {
        case .low:
            return 1
        case .moderate:
            return 1.2
        case .high:
            return 1.4
        case .very_high:
            return 1.6
        case .extrem_high:
            return 1.7
        }
    }
    
    var description: String {
        switch self {
        case .low:
            return "Low"
        case .moderate:
            return "Moderate"
        case .high:
            return "High"
        case .very_high:
            return "Very High"
        case .extrem_high:
            return "Extrem High"
        }
    }
    
    var level: Int {
        switch self {
        case .low:
            return 1
        case .moderate:
            return 2
        case .high:
            return 3
        case .very_high:
            return 4
        case .extrem_high:
            return 5
        }
    }
    
}

enum Capital: String, Codable {
    case primary
    case admin
    case minor
    case none = ""
}

enum AQI: Int {
    case good = 1
    case fair
    case moderate
    case poor
    case very_poor
    case extrem_poor
    
    var description: String {
        switch self {
        case .good:
            return "Good"
        case .fair:
            return "Moderate"
        case .moderate:
            return "Unhealthy for sensitive groups"
        case .poor:
            return "Unhealthy"
        case .very_poor:
            return "Very unhealthy"
        case .extrem_poor:
            return "Hazardous"
        }
    }
    
    var color: UIColor {
        switch self {
        case .good:
            return .green
        case .fair:
            return .yellow
        case .moderate:
            return .orange
        case .poor:
            return .red
        case .very_poor:
            return .purple
        case .extrem_poor:
            return .brown
        }
    }
    
    var image: String {
        switch self {
        case .good, .fair:
            return "aqi.low"
        case .moderate, .poor:
            return "aqi.medium"
        case .very_poor, .extrem_poor:
            return "aqi.high"
        }
    }
    
    var ratio: CGFloat {
        switch self {
        case .good:
            return 1
        case .fair:
            return 1.2
        case .moderate:
            return 1.4
        case .poor:
            return 1.6
        case .very_poor:
            return 1.7
        case .extrem_poor:
            return 1.8
        }
    }
}

enum WEATHER {
    case Thunderstorm
    case Drizzle
    case Rain
    case Snow
    case Clouds
    case Clear
    case Atmosphere     // Bad Atmosphere
    
    init(main: String) {
        if main == "Thunderstorm" {
            self = .Thunderstorm
        } else if main == "Drizzle" {
            self = .Drizzle
        } else if main == "Rain" {
            self = .Rain
        } else if main == "Snow" {
            self = .Snow
        } else if main == "Clouds" {
            self = .Clouds
        } else if main == "Clear" {
            self = .Clear
        } else {
            self = .Atmosphere
        }
    }
    
    var color: UIColor {
        switch self {
        case .Drizzle, .Clouds, .Rain, .Clear:
            return .blue
        case .Atmosphere:
            return .red
        case .Snow, .Thunderstorm:
            return .orange
        }
    }
}
