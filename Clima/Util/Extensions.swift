//
//  Extensions.swift
//  Clima
//
//  Created by Steven Zhang on 3/13/21.
//

import SwiftUI
import UIKit
import MapKit

internal extension Color {
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
}

internal extension CLLocationCoordinate2D {
    static let zero = CLLocationCoordinate2D(latitude: 22.2772243, longitude: 114.1711205)
    
    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        Int(lhs.latitude * 1_000) == Int(rhs.latitude * 1_000) &&
            Int(lhs.longitude * 1_000) == Int(rhs.longitude * 1_000)
    }
}

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
    
}

extension UIColor {
    var dynamic: UIColor {
        guard #available(iOS 13.0, *) else {
            return self
        }

        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let darkThemeColor = UIColor(hue: hue, saturation: saturation * 0.9, brightness: brightness * 1.3, alpha: alpha)
        return UIColor(dynamicProvider: { ($0.userInterfaceStyle == .dark ? darkThemeColor : self) })
    }
}

extension UIImage {
    func filled(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension MKMapView {
    public static let maxZoom: CGFloat = 14
    public var zoomLevel: CGFloat {
        let zoomScale = self.visibleMapRect.size.width / Double(self.frame.size.width)
        let zoomExponent = log2(zoomScale)
        return Self.maxZoom - CGFloat(zoomExponent)
    }
}

extension Double {
    public var kmFormatted: String {
        if self >= 1_000, self < 1_000_000 {
            return NumberFormatter.groupingFormatter.string(from: NSNumber(value: self / 1_000))! + "k"
        }

        if self >= 1_000_000 {
            return NumberFormatter.groupingFormatter.string(from: NSNumber(value: self / 1_000_000))! + "m"
        }

        return NumberFormatter.groupingFormatter.string(from: NSNumber(value: self))!
    }

    public var percentFormatted: String {
        NumberFormatter.percentFormatter.string(from: NSNumber(value: self))!
    }

    public var radians: Double { self * Double.pi / 180 }
}

extension Int {
    public var kmFormatted: String {
        Double(self).kmFormatted
    }

    public var groupingFormatted: String {
        NumberFormatter.groupingFormatter.string(from: NSNumber(value: self))!
    }

    public var radians: Double { Double(self).radians }

    public static func random() -> Int { random(in: 1..<max) }
}

extension NumberFormatter {
    public static let groupingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    public static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        return formatter
    }()
}

extension Date {
    var todayDescription: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: self)
    }
}

// MARK: - Data Parseing
extension ForecastHourlyWeather {
    var data: HourlyForecastData {
        return HourlyForecastData(time: self.dt.convertToDate(format: "HH:mm"),
                                  icon: self.weather[0].localIcon,
                                  temperature: self.temp
        )
    }
}


extension CurrentRegionWeather {
    var main_panel: HeaderPanelData {
        let dt = self.current.dt
        if let index = self.daily.firstIndex(where: { $0.dt.convertToDate(format: "dd") == dt.convertToDate(format: "dd") }) {
            return HeaderPanelData(main: self.current.weather[0].main,
                                 description: self.current.weather[0].description,
                                 icon: ClimaUtils.iconToSystemIcon(icon: self.current.weather[0].icon),
                                 temperature: self.current.temp,
                                 temp_min: self.daily[index].temp.min,
                                 temp_max: self.daily[index].temp.max,
                                 feels_like: self.current.feels_like
            )
        } else {
            return HeaderPanelData()
        }
    }
    
    var index_panel: IndexData {
        let dt = self.current.dt
        if let index = self.daily.firstIndex(where: { $0.dt.convertToDate(format: "dd") == dt.convertToDate(format: "dd")  }) {
            return IndexData(clouds: self.daily[index].clouds,
                             pressure: self.daily[index].pressure,
                             humidity: self.daily[index].humidity,
                             uvi_index: self.daily[index].uvi,
                             visibility: self.current.visibility,
                             precipitation: self.daily[index].rain,
                             wind_speed: self.current.wind_speed,
                             wind_deg: self.current.wind_deg
            )
        } else {
            return IndexData()
        }
    }
}
