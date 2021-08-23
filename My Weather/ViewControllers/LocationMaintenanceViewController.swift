//
//  LocationMaintenanceViewController.swift
//  My Weather
//
//  Created by Thomas Wood on 8/15/21.
//

import UIKit

class LocationMaintenanceViewController : UIViewController {
    var location: Location?
    var newLocation: Location?
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBOutlet var rightNavigationBarButton: UIBarButtonItem!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var errorMessageLabel: UILabel!
//    @IBAction func doneButtonClicked(_ sender: Any) {
//        if location == nil {
//            self.performSegue(withIdentifier: "AddLocationMaintenanceDone", sender: self)
//        } else {
//            self.performSegue(withIdentifier: "EditLocationMaintenanceDone", sender: self)
//        }
//    }
//    @IBAction func cancelButtonClicked(_ sender: Any) {
//        if location == nil {
//            self.performSegue(withIdentifier: "AddLocationMaintenanceCancel", sender: self)
//        } else {
//            
//            if updateNewLocation() {
//            
//            self.performSegue(withIdentifier: "EditLocationMaintenanceCancel", sender: self)
//            }
//        }
//    }
}

extension LocationMaintenanceViewController {

    func updateNewLocation() -> Bool {
        guard let name = nameTextField.text else {
            return false
        }
        
        guard let longitude = Double(longitudeTextField.text!) else {
            return false
        }
        
        guard let latitude = Double(latitudeTextField.text!) else {
            return false
        }

        newLocation = Location(name, longitude, latitude)
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // just setting the title doesn't do anything
        // guessing because the view is displayed using
        // a modal segue instead of a Show segue that the
        // navigation controller controls
        
        // TODO: add navigation bar button in Location detail view
        // for Edit.  In its prepare for seque set the location
        // from the selected item
        
        if let location = location {
            navigationBarTitle.title = location.name
            rightNavigationBarButton.title = "Done"
            
            self.nameTextField.text = location.name
            self.longitudeTextField.text = String(location.longitude)
            self.latitudeTextField.text = String(location.latitude)
            
        } else {
            navigationBarTitle.title = "Add Location"
            rightNavigationBarButton.title = "Add"
        }
    }
}
