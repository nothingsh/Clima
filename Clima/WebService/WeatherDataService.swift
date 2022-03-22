//
//  WeatherDataService.swift
//  Clima
//
//  Created by Steven Zhang on 3/7/21.
//
import Foundation
import CoreLocation

public class WeatherDataService {
    static let shared = WeatherDataService()
    
    private let LANGUAGE = "zh_cn"
    private let APIKEY = "c38ad195515340076ca73743791a3e40"
    private let WEATHER = "https://api.openweathermap.org/data/2.5/onecall?"
    private let AIRPOLLUTION = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?"
    private let MAPURL = "https://tile.openweathermap.org/map/{layer}/{z}/{x}/{y}.png?appid={API key}"
    
    
    // Fetch weather data with coordinates from openweather
    func currentRegionDataFetch(coordinate: CLLocationCoordinate2D?, completionHandlerResult: @escaping (CurrentRegionWeather) -> Void) {
        let location = (coordinate == nil) ? .zero : coordinate!
        let url = URLs.shared.currentURL(coordinate: location)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let current = try? JSONDecoder().decode(CurrentRegionWeather.self, from: data) {
                    DispatchQueue.main.async {
                        completionHandlerResult(current)
                    }
                } else {
                    print("Tag: Decoding Failed")
                }
            } else {
                print("Tag: Access openweather.com failed")
            }
        }.resume()
    }
    
    
    // Download air pollution data
    func airPollutionDataFetch(by coordinate: CLLocationCoordinate2D?, completionHandlerResult: @escaping (AirPollution) -> Void) {
        let location = (coordinate == nil) ? .zero : coordinate!
        
        let url = URLs.shared.airPollutionURL(coordinate: location)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let output = String(data: data, encoding: String.Encoding.utf8) {
                    print(output)
                } else {
                    print("Tag: output failed")
                }
                if let current = try? JSONDecoder().decode(AirPollution.self, from: data) {
                    DispatchQueue.main.async {
                        completionHandlerResult(current)
                        print("Tag: current location: \(current.coord.lat) : \(current.coord.lon)")
                    }
                } else {
                    print("Tag: Decoding Failed")
                }
            } else {
                print("Tag: Access data from OpenWeather failed")
                print("Tag: ERROR: \(error?.localizedDescription ?? "Unknow Error")")
            }
        }.resume()
    }
    
    
    /// Download weather  data for map
    func weatherMapDataFetch(completionHandlerResult: @escaping () -> Void) {
        let url = URL(string: "https://tile.openweathermap.org/map/precipitation_new/1/10/10.png?appid=8aaf754b216a290ccf7e0dd357181480")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                print("Tag: Data Fetched, Data count: \(data.count)")
            } else {
                print("Tag: Access data from OpenWeather failed")
                print("Tag: ERROR: \(error?.localizedDescription ?? "Unknow Error")")
            }
        }.resume()
    }
    
    // TODO: Download annnotation info (include basic weather data and airpollution data)
    func globalDataFetch() {
        
    }
    
}
