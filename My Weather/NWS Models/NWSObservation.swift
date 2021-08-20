//
//  NWSObserver.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import Foundation

struct NWSObservation : Codable
{
    var id: String = ""
    var type: String = ""
    var properties: NWSObservationProperties = NWSObservationProperties()
}

struct NWSObservationProperties : Codable
{
    var station: String = ""
    var timestamp: String = ""
    var textDescription: String = ""
    var temperature: NWSObservationReading = NWSObservationReading()
    var dewpoint: NWSObservationReading = NWSObservationReading()
    var windDirection: NWSObservationReading = NWSObservationReading()
    var windSpeed: NWSObservationReading = NWSObservationReading()
    var relativeHumidity: NWSObservationReading = NWSObservationReading()
}

struct NWSObservationReading : Codable
{
    var value: Double? = 0.0
    var unitCode: String = ""
    var qualityControl: String = ""
}

struct NWSObservationRequestor {
    typealias OnObservationCompletion = (NWSObservation) -> ()
    typealias OnError = (String) -> ()
    func getData(stationId: String, onCompletion: @escaping OnObservationCompletion, onError: @escaping OnError) {

        let url = "https://api.weather.gov/stations/\(stationId)/observations/latest"
        // define callback from HTTPURLRequestor.getData
        let onCompletion : (Data) -> () = { data in
            
            do {
                let observation = try JSONDecoder().decode(NWSObservation.self, from: data)
                onCompletion(observation)
            } catch {
                onError("Observation JSON parsing error = \(error)")
            }
        }
        
        HTTPURLRequestor().getData(url: url, onCompletion: onCompletion, onError: onError);
    }
}

