//
//  MapSearchViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class MapSearchViewController: UITableViewController {
    
    var matchingItems:[GMSAutocompletePrediction] = []
    let cellId = "cellId"
    var delegate: controlSaveLocation?
    var placesClient: GMSPlacesClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placesClient = GMSPlacesClient()
        
        tableView.register(ResultsCell.self, forCellReuseIdentifier: "cellId")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTextChange(_:)),
                                               name: NSNotification.Name(rawValue: handleTextChangeNotification),
                                               object: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func handleTextChange(_ myNot: Notification) {
        if let use = myNot.userInfo {
            if let searchBarText = use["text"] as? String {
                if searchBarText == "" {
                    UIView.animate(withDuration: animationOut) {
                        self.matchingItems = []
                        self.view.alpha = 0
                        return
                    }
                }
                let filter = GMSAutocompleteFilter()
                filter.type = .noFilter
                placesClient?.autocompleteQuery(searchBarText, bounds: nil, filter: filter, callback: { (results, error) in
                    if error != nil {
                        UIView.animate(withDuration: animationOut) {
                            self.matchingItems = []
                            self.view.alpha = 0
                            return
                        }
                    }
                    if let results = results {
                        self.matchingItems = results
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
}


extension MapSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchingItems.count > 6 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.alpha = 1
                })
            }
            return 6
        } else if matchingItems.count == 0 {
            UIView.animate(withDuration: animationOut, animations: {
                self.view.alpha = 0
            })
            return 0
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.alpha = 1
                })
            }
            return matchingItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResultsCell
        let selectedItem = matchingItems[indexPath.row]
        cell.nameTextView.text = selectedItem.attributedFullText.string
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ResultsCell
        guard let address = cell.nameTextView.text else { return }
        self.delegate?.zoomToSearchLocation(address: address)
        self.matchingItems = []
    }
}
