//
//  LocationModel.swift
//  Clima
//
//  Created by Steven Zhang on 3/14/21.
//

import MapKit

class LocationModel: ObservableObject {
    @Published var inputAddress: String {
        didSet {
            // convertCityNameToPlacemark()
            updateSearchingResult()
        }
    }
    @Published var cities: [CLPlacemark] = []
    
    @Published var favoriatePlacemark: [FavoritePlacemark] {
        didSet {
            do {
                let data = try JSONEncoder().encode(favoriatePlacemark)
                UserDefaults.standard.setValue(data, forKey: "favoriatePlacemark")
            } catch {
                print("Tag: \(error)")
            }
        }
    }
    
    init() {
        inputAddress = ""
        let data = UserDefaults.standard.object(forKey: "favoriatePlacemark") as? Data
        if let data = data {
            do {
                self.favoriatePlacemark = try JSONDecoder().decode([FavoritePlacemark].self, from: data)
            } catch {
                self.favoriatePlacemark = []
                print("Tag: \(error)")
            }
        } else {
            self.favoriatePlacemark = []
        }
    }
    
    func updateSearchingResult() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.inputAddress
        request.region = .init()
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            
            self.cities = response.mapItems.map { return $0.placemark }
        }
    }
    
    func removeFromFavorite(item: FavoritePlacemark) {
        favoriatePlacemark = favoriatePlacemark.filter{ $0.name != item.name }
    }
    
    func addItemToFavorite(item: FavoritePlacemark) {
        favoriatePlacemark = favoriatePlacemark.filter{ $0.name != item.name }
        favoriatePlacemark.append(item)
    }
    
    func checkItemInFovorite(item: FavoritePlacemark) -> Bool {
        return favoriatePlacemark.contains(item)
    }
    
    func convertCityNameToPlacemark() {
        CLGeocoder().geocodeAddressString(self.inputAddress) { (placemarks, error) in
            if error == nil, let list = placemarks  {
                DispatchQueue.main.async {
                    self.cities = list
                }
            } else {
                print("Tag: \(String(describing: error))")
            }
        }
    }
}

extension CLPlacemark {
    var placeName: String {
        let country = (self.country == nil) ? "" : "\(self.country ?? "") "
        let city = (self.locality == nil) ? "" : "\(self.locality ?? "") "
        let state = (self.administrativeArea == nil) ? "" : "\(self.administrativeArea ?? "") "
        let town = self.subLocality ?? ""
        
        return country + state + city + town
    }
    
    var regionName: String {
//        let city = (self.locality == nil) ? "" : "\(self.locality ?? "") "
//        let town = self.subLocality ?? ""
//
//        return city+town
        return self.name ?? "World"
    }
}
