//
//  Coordinate.swift
//  Clima
//
//  Created by Steven Zhang on 3/22/22.
//

import CoreLocation

struct Coordinate: Codable, Equatable, Hashable {
    let latitude: Double
    let longitude: Double
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        Int(lhs.latitude * 1_000) == Int(rhs.latitude * 1_000) && Int(lhs.longitude * 1_000) == Int(rhs.longitude * 1_000)
    }
    
    static let zero = Coordinate(latitude: 0, longitude: 0)
}

extension Coordinate: CustomStringConvertible {
    var cllCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var description: String {
        "Coordinate (lat: \(latitude), lon: \(longitude))"
    }
}

extension CLLocationCoordinate2D {
    var local: Coordinate {
        Coordinate(latitude: longitude, longitude: longitude)
    }
}
