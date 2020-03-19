//
//  SearchTableView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import CoreLocation
import GooglePlaces

extension MainSearchController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count != 0 {
            if section == 0 {
                return 3
            } else {
                return 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 72
            } else {
                return 80
            }
        } else {
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && count != 0 {
            return 64
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add a frequent destination"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.sizeToFit()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchDestinationCell
            cell.selectionStyle = .none
            
            if let text = toTextView.text, text.count > 0 {
                handleCell(cell: cell, text: text, indexPath: indexPath)
            } else if fromTextView.isFirstResponder, let text = fromTextView.text, text.count > 0 {
                handleCell(cell: cell, text: text, indexPath: indexPath)
            } else {
                if indexPath.row == 2 {
                    cell.line.alpha = 0
                } else {
                    cell.line.alpha = 1
                }
                if indexPath.row == 0 {
                    cell.showCurrent()
                } else {
                    cell.recent()
                    cell.hideCurrent()
                    if let firstSelected = recentItems.first, let firstId = recentId.first {
                        if indexPath.row == 1 {
                            cell.mainLabel.text = firstSelected
                            cell.placeID = firstId
                        }
                        if indexPath.row == 2 {
                            if let secondSelected = recentItems.last, let secondId = recentId.last, firstId != secondId {
                                cell.mainLabel.text = secondSelected
                                cell.placeID = secondId
                            }
                        } else {
                            // NEED TO SHOW 1 RECOMMENDED
                        }
                    } else {
                        // NEED TO SHOW 2 RECOMMENDED
                    }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! FrequentCell
            cell.selectionStyle = .none
            
            if indexPath.row == 1 {
                cell.line.alpha = 0
                let image = UIImage(named: "home_filled")?.withRenderingMode(.alwaysTemplate)
                cell.mainButton.setImage(image, for: .normal)
                cell.mainLabel.text = "Add a favorite"
            } else {
                cell.line.alpha = 1
                let image = UIImage(named: "work_filled")?.withRenderingMode(.alwaysTemplate)
                cell.mainButton.setImage(image, for: .normal)
                cell.mainLabel.text = "Add work"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchDestinationCell
        
        matchingItems = []
        
        if indexPath.row == 0 && cell.mainLabel.alpha == 0 {
            if fromTextView.isFirstResponder, let text = fromTextView.text, text.count == 0 {
                fromTextView.text = "Current location"
                toTextView.becomeFirstResponder()
            } else if toTextView.isFirstResponder, let text = toTextView.text, text.count == 0 {
                toTextView.text = "Current location"
                view.endEditing(true)
                if let currentLocation = locationManager.location {
                    lookUpLocation(location: currentLocation) { (placemark) in
                        self.searchPlacemark = placemark
                        self.mainButtonPressed()
                    }
                }
            }
        } else {
            if let placeId = cell.placeID {
                if fromTextView.isFirstResponder {
                    fromTextView.text = cell.mainLabel.text
                    toTextView.becomeFirstResponder()
                } else {
                    toTextView.text = cell.mainLabel.text
                    view.endEditing(true)
                    retrievePlacemark(placeID: placeId) { (placemark) in
                        self.searchPlacemark = placemark
                        self.mainButtonPressed()
                    }
                    saveNewTerms(placeId: placeId)
                }
            }
        }
    }
    
    func retrievePlacemark(placeID: String, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!

        placesClient?.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: { (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                self.lookUpLocation(location: location) { (placemark) in
                    completionHandler(placemark)
                }
            }
        })
    }
    
    func handleCell(cell: SearchDestinationCell, text: String, indexPath: IndexPath) {
        cell.autofill()
        cell.hideCurrent()
        if matchingItems.count > indexPath.row {
            let selectedItem = matchingItems[indexPath.row]
            cell.mainLabel.text = selectedItem.attributedPrimaryText.string
            cell.subLabel.text = selectedItem.attributedSecondaryText?.string
            cell.specificAddress = selectedItem.attributedFullText.string
            cell.placeID = selectedItem.placeID
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: view).y
        let percentage = translation/120
        if percentage >= 0 {
            searchViewPanned(sender: scrollView.panGestureRecognizer)
            scrollView.contentOffset = .zero
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if containerHeightAnchor.constant <= 300 {
            showMap()
        } else {
            hideMap(edit: false)
        }
        canPanSearchView = true
        tableView.isScrollEnabled = true
    }
    
    @objc func searchViewPanned(sender: UIPanGestureRecognizer) {
        if canPanSearchView {
            let translation = sender.translation(in: view).y/1.5
            let percent = translation/120
            let velocity = sender.velocity(in: view).y
            if sender.state == .changed {
                if velocity >= 800 {
                    showMap()
                } else if translation > 0 && translation < 120 {
                    containerHeightAnchor.constant = phoneHeight - 120 * percent
                    changeAlphaSearch(percent: percent)
                    view.layoutIfNeeded()
                } else if translation >= 120 {
                    showMap()
                }
            } else {
                if translation >= 160 || velocity >= 1000 {
                    showMap()
                } else {
                    hideMap(edit: tableView.alpha == 0)
                }
                canPanSearchView = true
                tableView.isScrollEnabled = true
            }
        }
    }
    
}
