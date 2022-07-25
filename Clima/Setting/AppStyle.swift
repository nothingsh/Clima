//
//  AppColorStyle.swift
//  Clima
//
//  Created by Steven Zhang on 3/20/22.
//

import SwiftUI

enum AppStyle: String, Codable {
    case rain
    case snow
    case clear
    
}

struct AppColorStyle {
    let textColor: Color
    let iconColor: Color
    let backgroundColor: Color
    let shadowColor: Color
    
    let hfBackgroundColor: Color
    let dfBackgroundColor: Color
    let apBackgroundColor: Color
    let idxBackgroundColor: Color
}

struct AppColorStyleHex: Codable {
    let textHex: String
    let iconHex: String
    let backgroundHex: String
    let shadowHex: String
    
    let hfBackgroundHex: String
    let dfBackgroundHex: String
    let apBackgroundHex: String
    let idxBackgroundHex: String
    
    func toColor() -> AppColorStyle {
        return AppColorStyle(
            textColor: Color(hex: textHex),
            iconColor: Color(hex: iconHex),
            backgroundColor: Color(hex: backgroundHex),
            shadowColor: Color(hex: shadowHex),
            hfBackgroundColor: Color(hex: hfBackgroundHex),
            dfBackgroundColor: Color(hex: dfBackgroundHex),
            apBackgroundColor: Color(hex: apBackgroundHex),
            idxBackgroundColor: Color(hex: idxBackgroundHex)
        )
    }
    
    static var defaultColorHex: AppColorStyleHex = {
        return AppColorStyleHex(
            textHex: "FFFFFF",
            iconHex: "0096FF",
            backgroundHex: "9ADCFF",
            shadowHex: "42C2FF",
            hfBackgroundHex: "42C2FF",
            dfBackgroundHex: "42C2FF",
            apBackgroundHex: "42C2FF",
            idxBackgroundHex: "42C2FF"
        )
    }()
}
