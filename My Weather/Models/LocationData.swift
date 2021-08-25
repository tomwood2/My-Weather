//
//  LocationData.swift
//  My Weather
//
//  Created by Thomas Wood on 8/23/21.
//

import Foundation

class LocationData: ObservableObject {
    private static var documentsFolder: URL {
        do {
            
        return try FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("location.data")
    }
    
    @Published var locations: [Location] = []
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.locations = Location.data
                }
                #endif
                return
            }
            guard let locations = try? JSONDecoder().decode([Location].self, from: data) else {
                fatalError("Can't decode saved scrum data.")
            }
            DispatchQueue.main.async {
                self?.locations = locations
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let locations = self?.locations else {
                fatalError("Self out of scope")
            }
            guard let data = try? JSONEncoder().encode(locations) else {
                fatalError("Error encoding data")
            }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}
