//
//  LocationDetailViewController.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import UIKit

class LocationDetailViewController: UITableViewController {
    var location: Location?
    var point: NWSPoint?
    var observationStations: NWSObservationStations?
}

extension LocationDetailViewController {
    
    enum Segues {
        static let showToObservationDetail = "showToObservationDetail"
    }
    
    static let locationDetailListCell = "LocationDetailListCell"

    override func viewWillAppear(_ animated: Bool) {
        
        guard let location = location else {
            return;
        }
        
        title = location.name
        
        NWSPointRequestor().getData(latitude: location.latitude, longitude: location.longitude, onCompletion: onPointRequestCompletion, onError: onError)
    }
    
    func onPointRequestCompletion(point: NWSPoint) {
        
        self.point = point;

        // we just received the grid information for this location
        // now request the stations for this grid
        
        NWSObservationStationsRequestor().getData(observationStationsUrl: point.properties.observationStations, onCompletion: onObservationStationsRequestCompletion, onError: onError)
    }
    
    func onObservationStationsRequestCompletion(stations: NWSObservationStations) {
        
        self.observationStations = stations

        self.tableView.reloadData()
    }

    func onError(error: String) {
        
        let alert = UIAlertController(title: "An error occured", message: error, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let observationStations = observationStations {
            return observationStations.features.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.locationDetailListCell, for: indexPath) as? LocationDetailListCell else {
                fatalError("Unable to dequeue LocationDetailListCell")
            }

            if let observationStations = observationStations {

                let index = indexPath.row
                cell.label.text = observationStations.features[index].properties.name
            }
            
            return cell
        }
    
    // Segue to Observation detail
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Segues.showToObservationDetail,
           let viewController = segue.destination as? ObservationDetailListViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            
            if let observationStations = observationStations {
            viewController.stationId = observationStations.features[index].properties.stationIdentifier
            }
            return
        }
    }
}
