//
//  ObservationDetailListViewController.swift
//  My Weather
//
//  Created by Thomas Wood on 8/13/21.
//

import UIKit

class ObservationDetailListViewController: UITableViewController {
    var stationId : String?
    private var observationResult : NWSFormattedResult?
}

extension ObservationDetailListViewController {
    static let observationDetailListCell = "ObservationDetailListCell"
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let stationId = stationId else {
            return;
        }
        
        title = stationId

        NWSObservationRequestor().getData(stationId: stationId, onCompletion: onObservationRequestCompletion, onError: onError)
    }
    
    func onObservationRequestCompletion(observation: NWSObservation) {
        
        guard let stationId = stationId else {
            return;
        }

        observationResult = NWSDataFormatter.buildObservationData(stationId: stationId, nwsObservation: observation)

        self.tableView.reloadData()
    }

    func onError(error: String) {
        
        let alert = UIAlertController(title: "An error occured", message: error, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let observationResult = observationResult {
            return observationResult.values.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.observationDetailListCell, for: indexPath) as? ObservationDetailListCell else {
                fatalError("Unable to dequeue ObservationDetailListCell")
            }

            if let observationResult = observationResult {

                let index = indexPath.row
                cell.label.text = "\(observationResult.values[index].description): \(observationResult.values[index].value)"
            }
            
            return cell
        }
}

