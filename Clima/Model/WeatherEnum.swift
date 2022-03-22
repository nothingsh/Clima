//
//  WeatherEnum.swift
//  Clima
//
//  Created by Steven Zhang on 4/3/21.
//

import Foundation

enum AirPollutionLevel {
    case good
    case satisfactory
    case moderate
    case poor
    case very_poor
    case severe
    
    var description: String {
        switch self {
        case .good:
            return "Good"
        case .satisfactory:
            return "Satisfactory"
        case .moderate:
            return "Moderately Polluted"
        case .poor:
            return "Poor"
        case .very_poor:
            return "Very Poor"
        case .severe:
            return "Severe"
        }
    }
    
    var percent: Double {
        switch self {
        case .good:
            return 10
        case .satisfactory:
            return 26
        case .moderate:
            return 42
        case .poor:
            return 58
        case .very_poor:
            return 74
        case .severe:
            return 90
        }
    }
    
    var toast: EmergencyInfo? {
        switch self {
        case .good, .satisfactory:
            return nil
        case .moderate, .poor:
            return EmergencyInfo(type: .warning, icon: "aqi.medium", main: nil, background: nil, value: nil, unit: nil, description: self.description)
        case .very_poor, .severe:
            return EmergencyInfo(type: .emergency, icon: "aqi.high", main: nil, background: nil, value: nil, unit: nil, description: self.description)
        }
    }
    
    // MARK: - Initialization
    init(pm2_5 value: Double) {
        switch value {
        case AirPollutionLevel.good.pm2_5_range:
            self = AirPollutionLevel.good
        case AirPollutionLevel.satisfactory.pm2_5_range:
            self = AirPollutionLevel.satisfactory
        case AirPollutionLevel.moderate.pm2_5_range:
            self = AirPollutionLevel.moderate
        case AirPollutionLevel.poor.pm2_5_range:
            self = AirPollutionLevel.poor
        case AirPollutionLevel.very_poor.pm2_5_range:
            self = AirPollutionLevel.very_poor
        case AirPollutionLevel.severe.pm2_5_range:
            self = AirPollutionLevel.severe
        default:
            fatalError()
        }
    }
    
    init(pm10 value: Double) {
        switch value {
        case AirPollutionLevel.good.pm10_range:
            self = AirPollutionLevel.good
        case AirPollutionLevel.satisfactory.pm10_range:
            self = AirPollutionLevel.satisfactory
        case AirPollutionLevel.moderate.pm10_range:
            self = AirPollutionLevel.moderate
        case AirPollutionLevel.poor.pm10_range:
            self = AirPollutionLevel.poor
        case AirPollutionLevel.very_poor.pm10_range:
            self = AirPollutionLevel.very_poor
        case AirPollutionLevel.severe.pm10_range:
            self = AirPollutionLevel.severe
        default:
            fatalError()
        }
    }
    
    init(so2 value: Double) {
        switch value {
        case AirPollutionLevel.good.so2_range:
            self = AirPollutionLevel.good
        case AirPollutionLevel.satisfactory.so2_range:
            self = AirPollutionLevel.satisfactory
        case AirPollutionLevel.moderate.so2_range:
            self = AirPollutionLevel.moderate
        case AirPollutionLevel.poor.so2_range:
            self = AirPollutionLevel.poor
        case AirPollutionLevel.very_poor.so2_range:
            self = AirPollutionLevel.very_poor
        case AirPollutionLevel.severe.so2_range:
            self = AirPollutionLevel.severe
        default:
            fatalError()
        }
    }
    
    init(nh3 value: Double) {
        switch value {
        case AirPollutionLevel.good.nh3_range:
            self = AirPollutionLevel.good
        case AirPollutionLevel.satisfactory.nh3_range:
            self = AirPollutionLevel.satisfactory
        case AirPollutionLevel.moderate.nh3_range:
            self = AirPollutionLevel.moderate
        case AirPollutionLevel.poor.nh3_range:
            self = AirPollutionLevel.poor
        case AirPollutionLevel.very_poor.nh3_range:
            self = AirPollutionLevel.very_poor
        case AirPollutionLevel.severe.nh3_range:
            self = AirPollutionLevel.severe
        default:
            fatalError()
        }
    }
    
    init(no2 value: Double) {
        switch value {
        case AirPollutionLevel.good.no2_range:
            self = AirPollutionLevel.good
        case AirPollutionLevel.satisfactory.no2_range:
            self = AirPollutionLevel.satisfactory
        case AirPollutionLevel.moderate.no2_range:
            self = AirPollutionLevel.moderate
        case AirPollutionLevel.poor.no2_range:
            self = AirPollutionLevel.poor
        case AirPollutionLevel.very_poor.no2_range:
            self = AirPollutionLevel.very_poor
        case AirPollutionLevel.severe.no2_range:
            self = AirPollutionLevel.severe
        default:
            fatalError()
        }
    }
    
    init(o3 value: Double) {
        switch value {
        case AirPollutionLevel.good.o3_range:
            self = AirPollutionLevel.good
        case AirPollutionLevel.satisfactory.o3_range:
            self = AirPollutionLevel.satisfactory
        case AirPollutionLevel.moderate.o3_range:
            self = AirPollutionLevel.moderate
        case AirPollutionLevel.poor.o3_range:
            self = AirPollutionLevel.poor
        case AirPollutionLevel.very_poor.o3_range:
            self = AirPollutionLevel.very_poor
        case AirPollutionLevel.severe.o3_range:
            self = AirPollutionLevel.severe
        default:
            fatalError()
        }
    }
    
    init(co value: Double) {
        switch value {
        case AirPollutionLevel.good.co_range:
            self = AirPollutionLevel.good
        case AirPollutionLevel.satisfactory.co_range:
            self = AirPollutionLevel.satisfactory
        case AirPollutionLevel.moderate.co_range:
            self = AirPollutionLevel.moderate
        case AirPollutionLevel.poor.co_range:
            self = AirPollutionLevel.poor
        case AirPollutionLevel.very_poor.co_range:
            self = AirPollutionLevel.very_poor
        case AirPollutionLevel.severe.co_range:
            self = AirPollutionLevel.severe
        default:
            fatalError()
        }
    }
    
    // MARK: - Ranges
    var pm2_5_range: Range<Double> {
        switch self {
        case .good:
            return 0..<30
        case .satisfactory:
            return 30..<60
        case .moderate:
            return 60..<90
        case .poor:
            return 90..<120
        case .very_poor:
            return 120..<250
        case .severe:
            return 250..<Double.greatestFiniteMagnitude
        }
    }
    
    var pm10_range: Range<Double> {
        switch self {
        case .good:
            return 0..<50
        case .satisfactory:
            return 50..<100
        case .moderate:
            return 100..<250
        case .poor:
            return 250..<350
        case .very_poor:
            return 350..<430
        case .severe:
            return 430..<Double.greatestFiniteMagnitude
        }
    }
    
    var so2_range: Range<Double> {
        switch self {
        case .good:
            return 0..<40
        case .satisfactory:
            return 40..<80
        case .moderate:
            return 80..<380
        case .poor:
            return 380..<800
        case .very_poor:
            return 800..<1600
        case .severe:
            return 1600..<Double.greatestFiniteMagnitude
        }
    }
    
    var nh3_range: Range<Double> {
        switch self {
        case .good:
            return 0..<200
        case .satisfactory:
            return 200..<400
        case .moderate:
            return 400..<800
        case .poor:
            return 800..<1200
        case .very_poor:
            return 1200..<1800
        case .severe:
            return 1800..<Double.greatestFiniteMagnitude
        }
    }
    
    var no2_range: Range<Double> {
        switch self {
        case .good:
            return 0..<40
        case .satisfactory:
            return 40..<80
        case .moderate:
            return 80..<180
        case .poor:
            return 180..<280
        case .very_poor:
            return 280..<400
        case .severe:
            return 400..<Double.greatestFiniteMagnitude
        }
    }
    
    var o3_range: Range<Double> {
        switch self {
        case .good:
            return 0..<50
        case .satisfactory:
            return 50..<100
        case .moderate:
            return 100..<168
        case .poor:
            return 168..<208
        case .very_poor:
            return 208..<748
        case .severe:
            return 748..<Double.greatestFiniteMagnitude
        }
    }
    
    var co_range: Range<Double> {
        switch self {
        case .good:
            return 0..<1
        case .satisfactory:
            return 1..<2
        case .moderate:
            return 2..<10
        case .poor:
            return 10..<17
        case .very_poor:
            return 17..<34
        case .severe:
            return 34..<Double.greatestFiniteMagnitude
        }
    }
}
