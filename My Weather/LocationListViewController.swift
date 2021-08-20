//
//  ViewController.swift
//  My Weather
//
//  Created by Thomas Wood on 8/12/21.
//

import UIKit

class LocationListViewController: UITableViewController {

    @IBAction func addButtonPressed(_ sender: Any) {
        
        let newLocation = Location("Location \(Location.data.count)", 32.7546, -117.1497)
        
        Location.data.append(newLocation)
        tableView.reloadData()
    }
}

extension LocationListViewController {
    static let locationListCellIdentifier = "LocationListCell"

    // DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Location.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.locationListCellIdentifier, for: indexPath) as? LocationListCell else {
                fatalError("Unable to dequeue LocationListCell")
            }
        let location = Location.data[indexPath.row]
        cell.nameLabel.text = location.name
        return cell
        }

    // Segue to Location detail
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let locationListToLocationDetailIdentifier = "LocationListToLocationDetail"
        let addLocationSegue = "AddLocationSegue"

        if segue.identifier == locationListToLocationDetailIdentifier,
           let locationDetailViewController = segue.destination as? LocationDetailViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            locationDetailViewController.location = Location.data[index]
            return
        }
        
        if segue.identifier == addLocationSegue,
           let locationMaintenaceViewController = segue.destination as? LocationMaintenanceViewController {
            locationMaintenaceViewController.location = nil
            return
        }

    }

    @IBAction func cancelCreateEditLocation(unwindSegue: UIStoryboardSegue) {
        
    }

    @IBAction func doneCreateEditLocation(unwindSegue: UIStoryboardSegue) {
        
        let newLocation = Location("Location \(Location.data.count)", 32.7546, -117.1497)
        Location.data.append(newLocation)
        tableView.reloadData()
    }
}
