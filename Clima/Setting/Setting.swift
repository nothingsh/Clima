//
//  Setting.swift
//  Clima
//
//  Created by Steven Zhang on 3/8/21.
//

import SwiftUI

struct Setting: Codable {
    var temperature_type: TemperatureScale = .fahrenheit
    var units: Units = .metric
    var language: Language = .English
    
    var sound: Bool = true
    var vibration: Bool = true

    var appColorHex: AppColorStyleHex = .defaultColorHex
}

extension Setting {
    var appColorStyle: AppColorStyle {
        self.appColorHex.toColor()
    }
}

enum Language: String, Codable {
    case Chinese
    case English
}

enum Units: String, Codable {
    case metric
    case imperial
    
    var description: String {
        switch self {
        case .imperial:
            return "(miles, ft2)"
        case .metric:
            return "(km ,m2)"
        }
    }
    
    var speed: String {
        switch self {
        case .imperial:
            return "mile/s"
        case .metric:
            return "meter/s"
        }
    }
    
    var length: String {
        switch self {
        case .imperial:
            return "mile"
        case .metric:
            return "meter"
        }
    }
}

enum TemperatureScale: String, Codable {
    case fahrenheit
    case celsius
    
    var description: String {
        switch self {
        case .celsius:
            return "Celsius (°C)"
        case .fahrenheit:
            return "Faherenheit (°F)"
        }
    }
    
    var unit: String {
        switch self {
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        }
    }
}
