//
//  URLs.swift
//  Clima
//
//  Created by Steven Zhang on 3/9/21.
//
import Foundation
import CoreLocation

class URLs {
    static let shared = URLs()
    
    private let APIKEY = "c38ad195515340076ca73743791a3e40"
    private let CURRENTURL = "https://api.openweathermap.org/data/2.5/onecall?"
    private let AIRPOLLUTION = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?"
    private let MAPURL = "https://tile.openweathermap.org/map/"
    
    // add parameter language
    func currentURL(coordinate: CLLocationCoordinate2D) -> URL {
        return URL(string: CURRENTURL + "lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&appid=\(APIKEY)")!
    }
    
    func mapLayerURL(layer: MapLayer) -> String {
        return MAPURL +  "\(layer.rawValue)/{z}/{x}/{y}.png?appid=\(APIKEY)"
    }
    
    func airPollutionURL(coordinate: CLLocationCoordinate2D) -> URL {
        return URL(string: AIRPOLLUTION + "lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(APIKEY)")!
    }
}
