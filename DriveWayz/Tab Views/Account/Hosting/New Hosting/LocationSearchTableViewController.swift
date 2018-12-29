//
//  LocationSearchTableViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class LocationSearchTableViewController: UITableViewController {

    var matchingItems:[GMSAutocompletePrediction] = []
    let cellId = "cellId"
    var delegate: handleChangingAddress?
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
                
                let filter = GMSAutocompleteFilter()
                filter.type = .noFilter
                placesClient?.autocompleteQuery(searchBarText, bounds: nil, filter: filter, callback: { (results, error) in
                    if let error = error {
                        print("Autocomplete error \(error)")
                        return
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


extension LocationSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchingItems.count > 4 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.alpha = 1
                })
            }
            return 4
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
        self.matchingItems = []
        let splitAddress = address.split(separator: ",")
        if splitAddress.count == 4 {
            if let street = splitAddress.first {
                self.delegate?.handleStreetAddress(text: String(street))
            }
            if let city = splitAddress.dropFirst().first {
                self.delegate?.handleCityAddress(text: String(city.dropFirst()))
            }
            guard let extraAddress = splitAddress.dropFirst().dropFirst().first else {
                if let state = splitAddress.dropFirst().dropFirst().first {
                    self.delegate?.handleStateAddress(text: String(state))
                }
                if let zip = splitAddress.dropFirst().dropFirst().dropFirst().first {
                    self.delegate?.handleZipAddress(text: String(zip))
                }
                return
            }
            let extraSplit = extraAddress.split(separator: " ")
            if extraSplit.count == 2 {
                if let state = extraSplit.first {
                    self.delegate?.handleStateAddress(text: String(state))
                }
                if let zip = extraSplit.dropFirst().first {
                    self.delegate?.handleZipAddress(text: String(zip))
                }
            } else {
                if let state = splitAddress.dropFirst().dropFirst().first {
                    self.delegate?.handleStateAddress(text: String(state))
                }
                if let zip = splitAddress.dropFirst().dropFirst().dropFirst().first {
                    self.delegate?.handleZipAddress(text: String(zip))
                }
            }
            if let country = splitAddress.dropFirst().dropFirst().dropFirst().first {
                self.delegate?.handleCountryAddress(text: String(country.dropFirst()))
            }
        } else {
            self.delegate?.handleStreetAddress(text: address)
        }
        self.delegate?.dismissKeyboard()
    }
}