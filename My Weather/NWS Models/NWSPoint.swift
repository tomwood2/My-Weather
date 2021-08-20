//
//  NWSPoint.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import Foundation

struct NWSPoint : Codable
{
    var properties: NWSPointProperties = NWSPointProperties()
}

struct NWSPointProperties : Codable
{
    var gridId: String = ""
    var gridX: Int = 0;
    var gridY: Int = 0;
    var forecast: String? = nil   // url
    var observationStations: String = ""   // url
}

struct NWSPointRequestor {
    typealias OnError = (String) -> ()
    typealias OnPointCompletion = (NWSPoint) -> ()
    
    func getData(latitude: Double, longitude: Double, onCompletion: @escaping OnPointCompletion, onError: @escaping OnError) {

        let url = "https://api.weather.gov/points/\(NWSConversions.doubleToString(latitude, decimalPlaces: 4)),\(NWSConversions.doubleToString(longitude, decimalPlaces: 4))"

        // define callback from HTTPURLRequestor.getData
        let onCompletion : (Data) -> () = { data in
//            print("In NWSPointRequestor.getData.onCompletion")
            do {
                
//                if let data = String(bytes: data, encoding: .utf8) {
//                    print(data)
//                }
                
                let point = try JSONDecoder().decode(NWSPoint.self, from: data)
                onCompletion(point)
            } catch {
                onError("NWSPoint JSON parsing error = \(error)")
            }
        }
        
        HTTPURLRequestor().getData(url: url, onCompletion: onCompletion, onError: onError);
    }
}
