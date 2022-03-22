//
//  FavoritePlacemark.swift
//  Clima
//
//  Created by Steven Zhang on 3/29/21.
//

import CoreLocation

struct FavoritePlacemark: Codable, Hashable {
    let coordinate: Coordinate
    let name: String
    
    init(name: String, coordinate: Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
}
