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

        let locationDetailToObservationDetail = "LocationDetailToObservationDetail"
        let editLocationSegue = "EditLocationSegue"

        if segue.identifier == locationDetailToObservationDetail,
           let viewController = segue.destination as? ObservationDetailListViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            
            if let observationStations = observationStations {
            viewController.stationId = observationStations.features[index].properties.stationIdentifier
            }
            return
        }

        if segue.identifier == editLocationSegue,
           let locationMaintenaceViewController = segue.destination as? LocationMaintenanceViewController,
           let location = location {
            locationMaintenaceViewController.location = location
            return
        }
    }
    
    @IBAction func doneEditLocation(unwindSegue: UIStoryboardSegue) {

        // update the appropriate location in our array
        // with the values from the maintenance view
        
//        let newLocation = Location("Location \(Location.data.count)", 32.7546, -117.1497)
//        Location.data.append(newLocation)
        tableView.reloadData()
    }

    @IBAction func cancelEditLocation(unwindSegue: UIStoryboardSegue) {

        // update the appropriate location in our array
        // with the values from the maintenance view
        
//        let newLocation = Location("Location \(Location.data.count)", 32.7546, -117.1497)
//        Location.data.append(newLocation)
//        tableView.reloadData()
    }

}
