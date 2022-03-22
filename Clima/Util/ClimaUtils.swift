//
//  UtilStruct.swift
//  Clima
//
//  Created by Steven Zhang on 3/16/21.
//

import Foundation
import UIKit

final class ClimaUtils {
    
    // Convert Unxi timestamp into formated date
    static func UTCToDateHour(date: Int64, format: String) -> String {
        let dFormat = DateFormatter()
        dFormat.dateFormat = format
        dFormat.timeZone = TimeZone(identifier: "GMT")
        
        let temp_date = Date(timeIntervalSince1970: TimeInterval(date))
        
        return dFormat.string(from: temp_date)
    }
    
    static func UTCToDateHour(date: Int64) -> Int {
        let temp_date = Date(timeIntervalSince1970: TimeInterval(date))
        
        return Calendar.current.component(.hour, from: temp_date)
    }
    
    static func iconToSystemIcon(icon: String) -> String {
        return dict[icon] ?? ""
    }
    
    private static let dict: [String : String] = ["01d": "sun.max", "02d": "cloud.sun", "03d": "cloud", "04d": "cloud", "09d": "cloud.heavyrain", "10d": "cloud.rain", "11d": "cloud.bolt.rain", "13d": "snow", "50d": "wind",
                                                  "01n": "sun.max", "02n": "cloud.sun", "03n": "cloud", "04n": "cloud", "09n": "cloud.heavyrain", "10n": "cloud.rain", "11n": "cloud.bolt.rain", "13n": "snow", "50n": "wind"]
    
}
