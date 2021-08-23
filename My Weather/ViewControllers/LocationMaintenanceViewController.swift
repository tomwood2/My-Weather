//
//  LocationMaintenanceViewController.swift
//  My Weather
//
//  Created by Thomas Wood on 8/15/21.
//

import UIKit

class LocationMaintenanceViewController : UIViewController {
    var locationIndex: Int?
    var newLocation: Location?
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBOutlet var rightNavigationBarButton: UIBarButtonItem!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var errorMessageLabel: UILabel!
}

extension LocationMaintenanceViewController {
    
    enum ErrorMessages {
        static let nameMissing = "Name must be specified"
        static let longitudeMissing = "Longitude must be specified"
        static let latitudeMissing = "Latitude must be specified"

        static let longitudeNotANumber = "Longitude must be a number"
        static let latitudeNotANumber = "Latitude must be a number"

        static let longitudeOutOfRange = "Longitude must be between -180 and 180"
        static let latitudeOutOfRange = "Latitude must be  between -90 and 90"
    }
    

    func updateNewLocation() -> Bool {

        // Name

        guard let name = nameTextField.text else {
            self.errorMessageLabel.text = ErrorMessages.nameMissing
            return false
        }
        
        if name.count < 1 {
            self.errorMessageLabel.text = ErrorMessages.nameMissing
            return false
        }

        // Longitude
        
        guard let longitude = longitudeTextField.text else {
            self.errorMessageLabel.text = ErrorMessages.longitudeMissing
            return false
        }
        
        guard let longitudeDouble = Double(longitude) else {
            self.errorMessageLabel.text = ErrorMessages.longitudeNotANumber
            return false
        }

        if longitudeDouble < -180.0 || longitudeDouble > 180.0 {
            self.errorMessageLabel.text = ErrorMessages.longitudeOutOfRange
            return false
        }
        
        // Latiitude

        guard let latitude = latitudeTextField.text else {
            self.errorMessageLabel.text = ErrorMessages.latitudeMissing
            return false
        }
        
        guard let latitudeDouble = Double(latitude) else {
            self.errorMessageLabel.text = ErrorMessages.latitudeNotANumber
            return false
        }

        if latitudeDouble < -90.0 || latitudeDouble > 90.0 {
            self.errorMessageLabel.text = ErrorMessages.longitudeOutOfRange
            return false
        }
        
        newLocation = Location(name, latitudeDouble, longitudeDouble)
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
        
        if let locationIndex = locationIndex {

            let location = Location.data[locationIndex]
            
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

    enum Segues {
        static let cancelLocationMaintenace = "cancelLocationMaintenace"
        static let doneLocationMaintenance = "doneLocationMaintenance"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        if let identifier = identifier {
            if identifier == Segues.doneLocationMaintenance {
                if !updateNewLocation() {
                    return false
                }
            }
        }
        
        return true
    }
}
