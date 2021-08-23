//
//  ViewController.swift
//  My Weather
//
//  Created by Thomas Wood on 8/12/21.
//

import UIKit

class LocationListViewController: UITableViewController {

    enum Segues {
        static let modallyToLocationMaintenanceAdd = "modallyToLocationMaintenanceAdd"
        static let modallyToLocationMaintenanceModify = "modallyToLocationMaintenanceModify"
        static let showToLocationDetail = "showToLocationDetail"
    }

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.showToLocationDetail,
           let locationDetailViewController = segue.destination as? LocationDetailViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            locationDetailViewController.location = Location.data[index]
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
        
        if let viewController = unwindSegue.source as? LocationMaintenanceViewController, let newLocation = viewController.newLocation {
            
            if let locationIndex = viewController.locationIndex {
                Location.data[locationIndex] = newLocation
            } else {
                Location.data.append(newLocation)
            }
        }

        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Location.data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }
}
