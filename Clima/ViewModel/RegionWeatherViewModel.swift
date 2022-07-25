//
//  RegionWeatherViewModel.swift
//  Clima
//
//  Created by Steven Zhang on 3/7/21.
//

import MapKit

class RegionWeatherViewModel: ObservableObject {
    let locationManager = CLLocationManager()
    
    @Published var region: Region = Region()
    
    init() {
        setUpLocatonManager()
        locationInitialization()
    }
    
    // MARK: - Initialization and Update
    
    // User selected some region
    func updateRegion(city: String?, coordinate: Coordinate?) {
        print("Tag: \(city ?? "city not fetched"), coordinate: \(coordinate?.description ?? "")")
        
        region = Region(name: city, weather: nil, coordinate: coordinate, airpollution: nil)
        
        // refetch weather data
        WeatherDataService.shared.currentRegionDataFetch(coordinate: region.coordinate?.cllCoordinate, completionHandlerResult: { data in
            self.region.weather = data
            self.region.weather?.timeLocalization()
        })

        // fetch air pollution data
        WeatherDataService.shared.airPollutionDataFetch(by: region.coordinate?.cllCoordinate, completionHandlerResult: { data in
            self.region.airpollution = data
        })
    }
    
    
    // Back to current location
    func backToCurrentLocation() {
        region.coordinate = nil
        
        if let location = locationManager.location?.coordinate {
            print("Tag: get location: \(location.latitude) : \(location.longitude)")
            self.region.coordinate = location.local
        } else {
            print("Tag: can't get location")
        }
        
        if region.coordinate == nil {
            region.coordinate = .zero
        }
        
        self.convertCurrentCoordinateToCityName()
        self.updateRegion(city: self.region.name, coordinate: self.region.coordinate)
    }
    
    
    // App initialized, show alert
    private func locationInitialization() {
        self.backToCurrentLocation()
    }
    
    
    // TODO: Add Notification
    
    // temp: too high, too low, decrease/increase too much
    
    // uvi index too high
    
    // rain, snow, thunderstorm
    
    // air pollution
    
    // visibility too low
    
    // pressure
    
    
    
    // MARK: - Location Service
    private func setUpLocatonManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func convertCurrentCoordinateToCityName() {
        DispatchQueue.global(qos: .userInteractive).async {
            let geoCoder = CLGeocoder()
            let cor = self.region.coordinate ?? .zero
            let location = CLLocation(latitude: cor.latitude, longitude: cor.longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                if error == nil {
                    let place = placemarks?[0]
                    
                    if let country = place?.country {
                        print("Tag: Country: \(country)")
                    }
                    
                    if let cityName = place?.locality {
                        print("Tag: City: \(cityName)")
                    }
                    
                    if let town = place?.subLocality {
                        print("Tag: Town: \(town)")
                    }
                    
                    DispatchQueue.main.async {
                        self.region.name = place?.locality
                        print("Tag: Converted from coordinate, \(self.region.name ?? "Unknow")")
                    }
                    
                }
                else {
                    print("Tag: convert coordinate into address failed")
                    print("Tag: \(error?.localizedDescription ?? "Unknow Error")")
                }
            })
        }
    }
    
    //
    func collectEmergencyInfo(at day: ForecastDailyWeather) -> [EmergencyInfo] {
        region.airpollution?.dailyEmergency(at: day.dt) ?? []
    }
    
}
