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
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    onError("DataTask error: " + error.localizedDescription)
                }
            } else {
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
//                    print("response.allHeaderFields: \(response.allHeaderFields)")
//
//                    if let body = String(data: data, encoding: .utf8) {
//                        print("body: \(body)")
//                    }

                    DispatchQueue.main.async {
                        onCompletion(data)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
