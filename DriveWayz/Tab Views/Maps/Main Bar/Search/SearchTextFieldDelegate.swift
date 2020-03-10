//
//  SearchTextField.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import Foundation
import GooglePlaces

extension MainSearchController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underline.alpha = 0
        if textField.text == "" {
            matchingItems = []
            tableView.reloadData()
        }
        
        if textField == toTextView {
            underlineBottomAnchor.constant = 0
        } else if textField == fromTextView {
            underlineBottomAnchor.constant = -48
        }
        view.layoutIfNeeded()
        UIView.animateOut(withDuration: animationOut, animations: {
            self.underline.alpha = 1
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageKeyboardAnchor.isActive = false
        messageBottomAnchor.isActive = true
        UIView.animateOut(withDuration: animationIn, animations: {
            self.underline.alpha = 0
            self.messageView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text": textField.text!])
    }
    
    @objc func handleTextChange(_ myNot: Notification) {
        if let use = myNot.userInfo {
            if let searchBarText = use["text"] as? String {
                if searchBarText == "" {
                    matchingItems = []
                    tableView.reloadData()
                    return
                }
                let filter = GMSAutocompleteFilter()
                filter.type = .noFilter
                placesClient?.autocompleteQuery(searchBarText, bounds: nil, filter: filter, callback: { (results, error) in
                    if error != nil {
                        self.matchingItems = []
                        print(error?.localizedDescription as Any)
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
    
    func saveNewTerms(placeId: String) {
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let first = firstRecent as! String
            if first != placeId {
                if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
                    let second = secondRecent as! String
                    if second == placeId {
                        userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
                        userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                    } else {
                        userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
                        userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                    }
                } else {
                    userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
                    userDefaults.setValue(first, forKey: "secondSavedRecentTerm")
                }
            }
        } else {
            userDefaults.setValue(placeId, forKey: "firstSavedRecentTerm")
        }
        userDefaults.synchronize()
    }
    
    func checkRecentSearches() {
        recentItems = []
        recentId = []
        let userDefaults = UserDefaults.standard
        if let firstRecent = userDefaults.value(forKey: "firstSavedRecentTerm") {
            let saved = firstRecent as! String
            
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(saved) { (place, error) in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                guard let place = place else {
                    print("No place details for \(saved)")
                    return
                }
                if let address = place.name {
                    self.recentId.append(saved)
                    self.recentItems.append(address)
                } else if let address = place.formattedAddress {
                    self.recentId.append(saved)
                    self.recentItems.append(address)
                }
            }
        }
        if let secondRecent = userDefaults.value(forKey: "secondSavedRecentTerm") {
            let saved = secondRecent as! String
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(saved) { (place, error) in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                guard let place = place else {
                    print("No place details for \(saved)")
                    return
                }
                if let address = place.name {
                    self.recentItems.append(address)
                    self.recentId.append(saved)
                } else if let address = place.formattedAddress {
                    self.recentItems.append(address)
                    self.recentId.append(saved)
                }
            }
        }
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let height = keyboardViewEndFrame.height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            messageBottomAnchor.isActive = true
            messageKeyboardAnchor.isActive = false
        } else {
            messageBottomAnchor.isActive = false
            messageKeyboardAnchor.isActive = true
            messageKeyboardAnchor.constant = -height
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.BLACK
        toolBar.sizeToFit()
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        fromTextView.inputAccessoryView = toolBar
        toTextView.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
