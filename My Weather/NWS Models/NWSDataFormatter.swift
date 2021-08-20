//
//  NWSDataFormatter.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import Foundation

struct NWSFormattedValue : Hashable
{
    init(_ description: String, _ value: String) {
        self.description = description
        self.value = value
    }
    let description: String
    let value: String
}

struct NWSFormattedResult {
    var values: [NWSFormattedValue] = [NWSFormattedValue]()
    mutating func addValue(_ description: String, _ value: String) {
        values.append(NWSFormattedValue(description, value))
    }
    mutating func addValue(_ description: String, _ value: Double?, decimalPlaces: Int) {
        addValue(description, NWSConversions.doubleToString(value, decimalPlaces: decimalPlaces))
    }
}

struct NWSDataFormatter
{
    static func buildObservationData(stationId : String, nwsObservation: NWSObservation) -> NWSFormattedResult {
        var nwsFormattedResult = NWSFormattedResult()
 //       nwsFormattedResult.addValue("Station ID", stationId)
        
        let result = NWSDataFormatter.getFormattedDateTime(nwsObservation.properties.timestamp)
        if let date = result.0 {
            nwsFormattedResult.addValue("Date", date)
        }
        if let time = result.1 {
            nwsFormattedResult.addValue("Time", time)
        }

        nwsFormattedResult.addValue("TMP", NWSConversions.cToF(nwsObservation.properties.temperature.value), decimalPlaces: 0)
        nwsFormattedResult.addValue("DP", NWSConversions.cToF(nwsObservation.properties.dewpoint.value), decimalPlaces: 0)
        nwsFormattedResult.addValue("RH", NWSConversions.doubleToString(nwsObservation.properties.relativeHumidity.value, decimalPlaces: 0) + "%")
        
        var wind = NWSConversions.degreesToCardinal(nwsObservation.properties.windDirection.value)
        if let windspeed = nwsObservation.properties.windSpeed.value {
            wind = wind + NWSConversions.doubleToString(windspeed, decimalPlaces: 0)
        }
        nwsFormattedResult.addValue("WIND", wind)

        nwsFormattedResult.addValue("WX", nwsObservation.properties.textDescription)
        return nwsFormattedResult
    }

    static func getFormattedDateTime(_ timestamp: String) -> (String?, String?, String?) {
        
        var formattedTime : String?
        var formattedDate : String?
        var formattedDataTime: String?
        
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = .withInternetDateTime
        
        let timestampDate = isoDateFormatter.date(from: timestamp);
        
        if let timestampDate = timestampDate {
            
            //print(isoDateFormatter.string(from: timeStampDate))
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("hhmm  a  z")

            // get formatted time
            formattedTime = dateFormatter.string(from: timestampDate)

            // get formatted date and remove commas
            dateFormatter.setLocalizedDateFormatFromTemplate("EEE  MMM  dd  yyyy")
            formattedDate = dateFormatter.string(from: timestampDate).replacingOccurrences(of: ",", with: "").uppercased()

            // looks like 8:00 PM PDT TUE JUL 27 2021
            formattedDataTime = formattedTime! + " " + formattedDate!;
        }
        return (formattedDate, formattedTime, formattedDataTime)
    }
    
}
