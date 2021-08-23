//
//  HTTPURLRequestor.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import Foundation

struct HTTPURLRequestor {
    func getData(url: String, onCompletion: @escaping (Data) -> (), onError: @escaping (String) -> ()) {
        guard let url = URL(string: url) else {
            onError("Invalid url...")
            return
        }
        let session : URLSession = URLSession(configuration: .ephemeral)
        session.configuration.waitsForConnectivity = true
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    onError("DataTask error: " + error.localizedDescription)
                }
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                
//                    print("response.allHeaderFields: \(response.allHeaderFields)")
//
//                    if let body = String(data: data, encoding: .utf8) {
//                        print("body: \(body)")
//                    }

                    if response.statusCode == 200 {
                        DispatchQueue.main.async {
                            onCompletion(data)
                        }
                    } else {
                        DispatchQueue.main.async {
                            var error = ""
                            
                            if let body = String(data: data, encoding: .utf8) {
                                error = body    // usually json that looks like this:
/*                                body: {
                                    "correlationId": "1e3303e3",
                                    "title": "Not Found",
                                    "type": "https://api.weather.gov/problems/NotFound",
                                    "status": 404,
                                    "detail": "Not Found",
                                    "instance": "https://api.weather.gov/requests/1e3303e3"
                                } */
                            } else {
                                error = "response code = \(response.statusCode)"
                            }
                            onError(error)
                        }
                    }
                    
                }
            }
        }
        dataTask.resume()
    }
}
