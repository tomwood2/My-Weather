//
//  NWSObservationStation.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import Foundation

struct NWSObservationStations : Codable
{
    var features: [NWSObservationStation] = [NWSObservationStation]()
}

struct NWSObservationStation : Codable, Hashable {
    var properties: NWSObservationStationProperties = NWSObservationStationProperties()
}

struct NWSObservationStationProperties : Codable, Hashable {
    var stationIdentifier: String = ""
    var name: String = ""
    var timeZone: String = ""
    var forecast: String? = nil   // url to description of forcast zone json
}

struct NWSObservationStationsRequestor {
    typealias OnError = (String) -> ()
    typealias OnObservationStationsCompletion = (NWSObservationStations) -> ()

    func getData(observationStationsUrl: String, onCompletion: @escaping OnObservationStationsCompletion, onError: @escaping OnError) {

        let url = observationStationsUrl

        // define callback from HTTPURLRequestor.getData
        let onCompletion : (Data) -> () = { data in
            do {
                
//                if let data = String(bytes: data, encoding: .utf8) {
//                    print(data)
//                }
                
                let stations = try JSONDecoder().decode(NWSObservationStations.self, from: data)
                onCompletion(stations)
            } catch {
                onError("NWSStations JSON parsing error = \(error)")
            }
        }
        
        HTTPURLRequestor().getData(url: url, onCompletion: onCompletion, onError: onError);
    }
}
