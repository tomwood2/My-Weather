//
//  ViewController.swift
//  My Weather
//
//  Created by Thomas Wood on 8/12/21.
//

import UIKit
import Combine

class LocationListViewController: UITableViewController {

    enum Segues {
        static let modallyToLocationMaintenanceAdd = "modallyToLocationMaintenanceAdd"
        static let modallyToLocationMaintenanceModify = "modallyToLocationMaintenanceModify"
        static let showToLocationDetail = "showToLocationDetail"
    }

    let locationData = LocationData()
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet var editButton: UIBarButtonItem!
    @IBAction func editButtonPressed(_ sender: Any) {
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
        }
    }
}
extension LocationListViewController {
    static let locationListCellIdentifier = "LocationListCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        locationData.$locations.sink( receiveValue: { [weak self] in self?.locationsChanged($0)}).store(in: &cancellables)
        locationData.load()
    }
    
    func locationsChanged(_ locations: [Location]) {

        // this func is called before the property has actually
        // been changed so let it finish first
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.locationListCellIdentifier, for: indexPath) as? LocationListCell else {
                fatalError("Unable to dequeue LocationListCell")
            }
        let location = locationData.locations[indexPath.row]
        cell.nameLabel.text = location.name
        return cell
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.showToLocationDetail,
           let locationDetailViewController = segue.destination as? LocationDetailViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            locationDetailViewController.location = locationData.locations[index]
            return
        }
        
        if segue.identifier == Segues.modallyToLocationMaintenanceAdd,
           let locationMaintenaceViewController = segue.destination as? LocationMaintenanceViewController {
            locationMaintenaceViewController.locationIndex = nil
            return
        }

        if segue.identifier == Segues.modallyToLocationMaintenanceModify,
           let locationMaintenaceViewController = segue.destination as? LocationMaintenanceViewController, let index = tableView.indexPathForSelectedRow?.row {
            locationMaintenaceViewController.locationIndex = index
            locationMaintenaceViewController.locationData = locationData.locations[index].data
            return
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.isEditing {
            performSegue(withIdentifier: Segues.modallyToLocationMaintenanceModify, sender: nil)
        } else {
            performSegue(withIdentifier: Segues.showToLocationDetail, sender: nil)
        }
    }
    
    @IBAction func cancelLocationMaintenace(unwindSegue: UIStoryboardSegue) {
        
    }

    @IBAction func doneLocationMaintenance(unwindSegue: UIStoryboardSegue) {
        
        if let viewController = unwindSegue.source as? LocationMaintenanceViewController {
            
            // Modify or add to locationData.locations will trigger a call to locationsChanged()
            // that will call reloadData on the view

            if let locationIndex = viewController.locationIndex {
                locationData.locations[locationIndex].update(from: viewController.locationData)
            } else {
                let newLocation = Location(name: viewController.locationData.name, latitude: viewController.locationData.latitude, longitude: viewController.locationData.longitude)
                locationData.locations.append(newLocation)
            }

            // store changes to file system
            locationData.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // this change will trigger a call to locationsChanged()
            // that will call reloadData on the view
            locationData.locations.remove(at: indexPath.row)

            // store changes to file system
            locationData.save()
        }
    }
}
