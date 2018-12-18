//
//  MapRecentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/14/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class MapRecentViewController: UITableViewController {

    var matchingItems:[String] = []
    let cellId = "cellId"
    var delegate: controlSaveLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        tableView.register(ResultsCell.self, forCellReuseIdentifier: "cellId")
        
        checkRecentSearches()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 10
        } else {
            return 50
        }
    }
    
    func checkRecentSearches() {
        self.matchingItems = []
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let first = firstRecent as! String
            self.matchingItems.append(first)
        } else {
            self.matchingItems.append("nil")
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            let second = secondRecent as! String
            self.matchingItems.append(second)
        } else {
            self.matchingItems.append("nil")
        }
        self.tableView.reloadData()
    }
    
    func closestLocation(locations: [CLLocation], closestToLocation location: CLLocation) -> CLLocation? {
        if let closestLocation = locations.min(by: { location.distance(from: $0) < location.distance(from: $1) }) {
            print("closest location: \(closestLocation), distance: \(location.distance(from: closestLocation))")
            return closestLocation
        } else {
            print("coordinates are empty")
            return nil
        }
    }
    
}


extension MapRecentViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = UITableViewCell()
            cell.backgroundColor = Theme.OFF_WHITE
            cell.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.width, bottom: 0, right: self.view.frame.width)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResultsCell
            if matchingItems.count >= indexPath.row + 1 {
                let selectedItem = matchingItems[indexPath.row]
                if selectedItem == "nil" {
                    cell.nameTextView.text = "Blank"
                } else {
                    cell.nameTextView.text = selectedItem
                }
            } else {
                cell.nameTextView.text = "Blank"
            }
            let image = UIImage(named: "parking_history")
            cell.pinImageView.image = image
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: self.view.frame.width, bottom: 0, right: self.view.frame.width)
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ResultsCell
        guard let address = cell.nameTextView.text else { return }
        self.delegate?.zoomToSearchLocation(address: address)
        self.matchingItems = []
    }
}
