//
//  NWSConversions.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import Foundation

struct NWSConversions
{
    static func doubleToString(_ double: Double?, decimalPlaces: Int) -> String {
        if let double = double {
            return String(format: "%.\(decimalPlaces)f", double)
        } else {
            return ""
        }
    }
    static func cToF(_ celsius: Double?) -> Double? {
        if let celsius = celsius {
            return celsius * 1.8 + 32
        } else {
            return nil
        }
    }
    static func kphToMph(_ kilometers: Double?) -> Double? {
        if let kilometers = kilometers {
            return kilometers / 1.609
        } else {
            return nil
        }
    }
    static func degreesToCardinal(_ degrees: Double?) -> String {
        if let degrees = degrees {
            switch degrees {
            case 0..<22.5:
                return "N"
                
            case 22.5..<67.5:
                return "NE"
                
            case 67.5..<112.5:
                return "E"
                
            case 112.5..<157.5:
                return "SE"
                
            case 157.5..<202.5:
                return "S"
                
            case 202.5..<247.5:
                return "SW"
                
            case 247.5..<292.5:
                return "N"
                
            case 292.5..<337.5:
                return "N"
                
            case 337.5...360:
                return "N"
                
            default:
                return ""
            }
        } else {
            return ""
        }
    }
}
