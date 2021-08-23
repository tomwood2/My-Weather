//
//  Location.swift
//  My Weather
//
//  Created by Thomas Wood on 8/12/21.
//

import Foundation

struct Location : Codable {
    var name: String
    var latitude: Double
    var longitude: Double

    init(_ name: String, _ latitude: Double, _ longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Location {
    static var data = [
        Location("Home", 32.7336, -117.1831),
                       Location("San Diego, CA", 32.7546, -117.1497),
                       Location("Seatle, WA", 47.4447, -122.3136),
                       Location("Denver, CO", 39.8466, -104.6562),
                       Location("Chicago, IL", 41.9797, -87.9044),
                       Location("Dallas, TX", 32.8974, -97.0220),
                       Location("Newark, NJ", 40.6825, -74.1694),
                       Location("Anchorage, AK", 61.2174, -149.8631),
                       Location("Honolulu, HI", 21.3275, -157.9431)
    ]
}
