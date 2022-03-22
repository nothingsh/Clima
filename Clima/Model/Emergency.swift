//
//  Emergency.swift
//  Clima
//
//  Created by Steven Zhang on 3/26/21.
//

import SwiftUI

// Warning - Yellow
// - Air pollution, uvi, bad weather, low visibility

// Emergency - Red
// - Extreme air pollution, extreme high uvi, extreme bad weather(hariccan)

// Alert - Blue
// - Rain, Lighting Rain, visibility may influence airplane

enum EmergencyLevel {
    case warning
    case emergency
    case alert
    
    var color: Color {
        switch self {
        case .alert:
            return .blue
        case .warning:
            return .yellow
        case .emergency:
            return .red
        }
    }
}

struct Emergency {
    var type: EmergencyLevel
    var icon: String
    var main: String
    var description: String
    var remainder: String
    var background: Gradient
}

// Temp too high/low, pressure/uvi/wind gust
// Air pollution
struct EmergencyInfo {
    var type: EmergencyLevel
    var icon: String
    var main: String?
    var background: Gradient?
    
    var value: Double?
    var unit: String?
    var description: String?
}
