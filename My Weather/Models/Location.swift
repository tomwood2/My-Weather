//
//  Location.swift
//  My Weather
//
//  Created by Thomas Wood on 8/12/21.
//

import Foundation

struct Location : Identifiable, Codable {
    var id: UUID
	var name: String
    var latitude: Double
    var longitude: Double

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Location {
    static var data = [
        Location(name: "Home", latitude: 32.7336, longitude: -117.1831),
        Location(name: "San Diego, CA", latitude: 32.7546, longitude: -117.1497),
        Location(name: "Seatle, WA", latitude: 47.4447, longitude: -122.3136),
        Location(name: "Denver, CO", latitude: 39.8466, longitude: -104.6562),
        Location(name: "Chicago, IL", latitude: 41.9797, longitude: -87.9044),
        Location(name: "Dallas, TX", latitude: 32.8974, longitude: -97.0220),
        Location(name: "Newark, NJ", latitude: 40.6825, longitude: -74.1694),
        Location(name: "Anchorage, AK", latitude: 61.2174, longitude: -149.8631),
        Location(name: "Honolulu, HI", latitude: 21.3275, longitude: -157.9431)
    ]
    
    struct Data {
        var name: String = ""
        var latitude: Double = 0.0
        var longitude: Double = 0.0
    }

    var data: Data {
        return Data(name: name, latitude: latitude, longitude: longitude)
    }

    mutating func update(from data: Data) {
        name = data.name
        latitude = data.latitude
        longitude = data.longitude
    }
}
