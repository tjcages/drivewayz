//
//  HostListingDatabase.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

extension HostFinishListingView {
    
    func configureNewParking() {
        let ref = Database.database().reference().child("ParkingSpots")
        let childRef = ref.childByAutoId()
        let userID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values = ["id": userID,
                      "timestamp": timestamp]
        as [String: Any]
        
        if let childKey = childRef.key {
            values["parkingID"] = childKey
            values = addBasicInformation(values: values)
            
            childRef.updateChildValues(values) { (error, ref) in
                self.configureSpotType(ref: childRef)
                
                self.databaseSaved()
            }
        }
    }

    // Add standard information to create the new host space
    func addBasicInformation(values: [String: Any]) -> [String: Any] {
        var values = values
        if let value = hostEmail {
            values["hostEmail"] = value
        }
        if let value = parkingCost {
            values["parkingCost"] = value
        }
        
        return values
    }
    
    // Incorporate data about the type of parking space
    func configureSpotType(ref: DatabaseReference) {
        let typeRef = ref.child("Type")
        var values: [String: Any] = [:]
        if let value = mainType {
            values["mainType"] = value
        }
        if let value = secondaryType {
            values["secondaryType"] = value
        }
        if let value = numberSpots {
            values["numberSpots"] = value
        }
        if let value = parkingNumber {
            values["parkingNumber"] = value
        }
        if let value = gateNumber {
            values["gateNumber"] = value
        }
        if let value = hostMessage {
            values["hostMessage"] = value
            values["promotionalMessage"] = promotionalMessage
        }
        
        typeRef.updateChildValues(values) { (error, ref) in
            let amenitiesRef = typeRef.child("Amenities")
            if let amenities = selectedAmenities {
                amenitiesRef.setValue(amenities)
            }
        }
    }
    
    // New host space has successfully been saved
    func databaseSaved() {
        if let controller = self.successfulListingController {
            controller.animateSuccess()
            delayWithSeconds(3) {
                controller.closeSuccess()
                delayWithSeconds(animationOut, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissNewListing"), object: nil)
                })
            }
        }
    }
    
//
//    func loadDatabase() {
//        let mainType = self.parkingTypeController.parkingType
//        let secondaryType = self.parkingOptionsController.parkingType
//        let selectedAmenities = self.amenitiesController.selectedAmenities
//
//        let numberSpots = self.spotNumberController.numberField.text
//        var parkingNumber = self.spotNumberController.spotNumberField.text; if parkingNumber == "• • • •" { parkingNumber = "" }
//        var gateNumber = self.spotNumberController.gateCodeField.text; if gateNumber == "• • • •" { gateNumber = "" }
//
//        let streetAddress = self.locationController.streetField.text
//        let cityAddress = self.locationController.cityField.text
//        var stateAddress = self.locationController.stateField.text
//        if let state = stateAddress, state.first == " " { stateAddress = String(state.dropFirst()) }
//        if let state = stateAddress, state.last == " " { stateAddress = String(state.dropLast()) }
//        let zipAddress = self.locationController.zipField.text
//        let countryAddress = self.locationController.countryField.text
//        let overallAddress = self.locationController.newHostAddress
//
//        let latitude = self.mapController.latitude
//        let longitude = self.mapController.longitude
//
//        let mondayUnavailable = self.scheduleController.selectedMondays
//        let tuesdayUnavailable = self.scheduleController.selectedTuesdays
//        let wednesdayUnavailable = self.scheduleController.selectedWednesdays
//        let thursdayUnavailable = self.scheduleController.selectedThursdays
//        let fridayUnavailable = self.scheduleController.selectedFridays
//        let saturdayUnavailable = self.scheduleController.selectedSaturdays
//        let sundayUnavailable = self.scheduleController.selectedSundays
//
//        let mondayFromTimes = self.timesController.mondayAvailabilityController.selectedFromTime
//        let mondayToTimes = self.timesController.mondayAvailabilityController.selectedToTime
//        let tuesdayFromTimes = self.timesController.tuesdayAvailabilityController.selectedFromTime
//        let tuesdayToTimes = self.timesController.tuesdayAvailabilityController.selectedToTime
//        let wednesdayFromTimes = self.timesController.wednesdayAvailabilityController.selectedFromTime
//        let wednesdayToTimes = self.timesController.wednesdayAvailabilityController.selectedToTime
//        let thursdayFromTimes = self.timesController.thursdayAvailabilityController.selectedFromTime
//        let thursdayToTimes = self.timesController.thursdayAvailabilityController.selectedToTime
//        let fridayFromTimes = self.timesController.fridayAvailabilityController.selectedFromTime
//        let fridayToTimes = self.timesController.fridayAvailabilityController.selectedToTime
//        let saturdayFromTimes = self.timesController.saturdayAvailabilityController.selectedFromTime
//        let saturdayToTimes = self.timesController.saturdayAvailabilityController.selectedToTime
//        let sundayFromTimes = self.timesController.sundayAvailabilityController.selectedFromTime
//        let sundayToTimes = self.timesController.sundayAvailabilityController.selectedToTime
//
//        var parkingCost = self.costsController.costTextField.text?.replacingOccurrences(of: "$", with: "")
//        parkingCost = parkingCost!.replacingOccurrences(of: " ", with: "")
//        let hostMessage = self.messageController.messageTextView.text
//        let hostEmail = self.emailController.messageTextView.text
//
//        let ref = Database.database().reference().child("ParkingSpots")
//        let childRef = ref.childByAutoId()
//        let userID = Auth.auth().currentUser!.uid
//        let timestamp = Int(Date().timeIntervalSince1970)
//        if let childKey = childRef.key {
//            let values = ["parkingID": childKey,
//                          "id": userID,
//                          "timestamp": timestamp,
//                          "parkingCost": Double(parkingCost!) as Any,
//                          "hostMessage": hostMessage as Any,
//                          "hostEmail": hostEmail as Any]
//                as [String: Any]
//
//            childRef.updateChildValues(values) { (error, ref) in
//                if error != nil { print(error ?? ""); return }
//                let typeRef = childRef.child("Type")
//                let typeValues = ["mainType": mainType,
//                                  "secondaryType": secondaryType,
//                                  "numberSpots": numberSpots as Any,
//                                  "parkingNumber": parkingNumber as Any,
//                                  "gateNumber": gateNumber as Any]
//                    as [String: Any]
//
//                typeRef.updateChildValues(typeValues) { (error, ref) in
//                    if error != nil { print(error ?? ""); return }
//                    let amenitiesRef = typeRef.child("Amenities")
//                    amenitiesRef.setValue(selectedAmenities)
//
//                    if var state = stateAddress, state.count <= 3 {
//                        state = state.replacingOccurrences(of: " ", with: "")
//                        if let keys = (statesDictionary as NSDictionary).allKeys(for: state) as? [String], let newState = keys.first {
//                            stateAddress = newState
//                        }
//                    }
//
//                    let locationRef = childRef.child("Location")
//                    let locationValues = ["overallAddress": overallAddress as Any,
//                                          "streetAddress": streetAddress as Any,
//                                          "cityAddress": cityAddress as Any,
//                                          "stateAddress": stateAddress as Any,
//                                          "zipAddress": zipAddress as Any,
//                                          "countryAddress": countryAddress as Any,
//                                          "latitude": latitude as Any,
//                                          "longitude": longitude as Any]
//                        as [String: Any]
//
//                    if var state = stateAddress, let zip = zipAddress, let city = cityAddress, let numberString = numberSpots, let number = Int(numberString) {
//                        state = state.replacingOccurrences(of: " ", with: "")
////                        if state.count > 2 {
////                            if let newState = statesDictionary[state] {
////                                state = newState
////                            }
////                        }
//                        let tempRef = Database.database().reference().child("Surge").child("SurgeDemand").child(state).child(city).child(zip).child(childKey)
//                        tempRef.setValue(number)
//                        let checkRef = Database.database().reference().child("Surge").child("SurgeCheck").child(state).child(city).child(zip).child(childKey)
//                        checkRef.setValue(Int(number))
//
//                        if let overallAddress = overallAddress {
//                            let tempsRef = Database.database().reference().child("ParkingDetails").child("HostLocations").child(state).child(city)
//                            tempsRef.updateChildValues([overallAddress: childKey])
//                        }
//                    }
//
//                    if let city = cityAddress {
//                        let parkingLocRef = Database.database().reference().child("ParkingLocations").child(city)
//                        parkingLocRef.updateChildValues([childKey: childKey])
//                    }
//
//                    locationRef.updateChildValues(locationValues) { (error, ref) in
//                        if error != nil { print(error ?? ""); return }
//                        let unavailableRef = childRef.child("UnavailableDays")
//                        let unavailableMonday = unavailableRef.child("Monday")
//                        let unavailableTuesday = unavailableRef.child("Tuesday")
//                        let unavailableWednesday = unavailableRef.child("Wednesday")
//                        let unavailableThursday = unavailableRef.child("Thursday")
//                        let unavailableFriday = unavailableRef.child("Friday")
//                        let unavailableSaturday = unavailableRef.child("Saturday")
//                        let unavailableSunday = unavailableRef.child("Sunday")
//
//                        unavailableMonday.setValue(mondayUnavailable)
//                        unavailableTuesday.setValue(tuesdayUnavailable)
//                        unavailableWednesday.setValue(wednesdayUnavailable)
//                        unavailableThursday.setValue(thursdayUnavailable)
//                        unavailableFriday.setValue(fridayUnavailable)
//                        unavailableSaturday.setValue(saturdayUnavailable)
//                        unavailableSunday.setValue(sundayUnavailable)
//
//                        let availableRef = childRef.child("AvailableTimes")
//                        let availableMonday = availableRef.child("Monday")
//                        let availableTuesday = availableRef.child("Tuesday")
//                        let availableWednesday = availableRef.child("Wednesday")
//                        let availableThursday = availableRef.child("Thursday")
//                        let availableFriday = availableRef.child("Friday")
//                        let availableSaturday = availableRef.child("Saturday")
//                        let availableSunday = availableRef.child("Sunday")
//
//                        if self.timesController.mondayAvailabilityController.dayAvailable == 1 {
//                            availableMonday.updateChildValues(["From": mondayFromTimes, "To": mondayToTimes])
//                        }
//                        if self.timesController.tuesdayAvailabilityController.dayAvailable == 1 {
//                            availableTuesday.updateChildValues(["From": tuesdayFromTimes, "To": tuesdayToTimes])
//                        }
//                        if self.timesController.wednesdayAvailabilityController.dayAvailable == 1 {
//                            availableWednesday.updateChildValues(["From": wednesdayFromTimes, "To": wednesdayToTimes])
//                        }
//                        if self.timesController.thursdayAvailabilityController.dayAvailable == 1 {
//                            availableThursday.updateChildValues(["From": thursdayFromTimes, "To": thursdayToTimes])
//                        }
//                        if self.timesController.fridayAvailabilityController.dayAvailable == 1 {
//                            availableFriday.updateChildValues(["From": fridayFromTimes, "To": fridayToTimes])
//                        }
//                        if self.timesController.saturdayAvailabilityController.dayAvailable == 1 {
//                            availableSaturday.updateChildValues(["From": saturdayFromTimes, "To": saturdayToTimes])
//                        }
//                        if self.timesController.sundayAvailabilityController.dayAvailable == 1 {
//                            availableSunday.updateChildValues(["From": sundayFromTimes, "To": sundayToTimes])
//                        }
//
//                        let parkAvailRef = Database.database().reference().child("ParkingAvailability")
//                        let monAvailRef = parkAvailRef.child("Monday").child(childKey)
//                        let tuesAvailRef = parkAvailRef.child("Tuesday").child(childKey)
//                        let wedAvailRef = parkAvailRef.child("Wednesday").child(childKey)
//                        let thursAvailRef = parkAvailRef.child("Thursday").child(childKey)
//                        let friAvailRef = parkAvailRef.child("Friday").child(childKey)
//                        let satAvailRef = parkAvailRef.child("Saturday").child(childKey)
//                        let sunAvailRef = parkAvailRef.child("Sunday").child(childKey)
//
//                        monAvailRef.setValue(mondayUnavailable)
//                        tuesAvailRef.setValue(tuesdayUnavailable)
//                        wedAvailRef.setValue(wednesdayUnavailable)
//                        thursAvailRef.setValue(thursdayUnavailable)
//                        friAvailRef.setValue(fridayUnavailable)
//                        satAvailRef.setValue(saturdayToTimes)
//                        sunAvailRef.setValue(sundayUnavailable)
//
//                        self.loadImageDatabase(parkingID: childKey)
//
//                        let userRef = Database.database().reference().child("users").child(userID)
//                        userRef.updateChildValues(["email": hostEmail as Any])
//                        userRef.child("Hosting Spots").updateChildValues(["\(childKey)": childKey])
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            self.confirmController.endLoading()
//                            self.hostDelegate?.closeBackground()
////                            self.delegate?.hideNewHostingController()
//                            self.dismiss(animated: true, completion: {
//                                self.delegate?.bringHostingController()
//                                self.moveDelegate?.defaultContentStatusBar()
//                            })
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func loadImageDatabase(parkingID: String) {
//        let mainType = self.parkingTypeController.parkingType
//        let overallAddress = self.locationController.newHostAddress
//
//        let imageSpot1 = self.picturesController.addAnImageButton1.imageView?.image
//        let imageSpot2 = self.picturesController.addAnImageButton2.imageView?.image
//        let imageSpot3 = self.picturesController.addAnImageButton3.imageView?.image
//        let imageSpot4 = self.picturesController.addAnImageButton4.imageView?.image
//        let imageSpot5 = self.picturesController.addAnImageButton5.imageView?.image
//        let imageSpot6 = self.picturesController.addAnImageButton6.imageView?.image
//        let imageSpot7 = self.picturesController.addAnImageButton7.imageView?.image
//        let imageSpot8 = self.picturesController.addAnImageButton8.imageView?.image
//
//        let additionalImage1 = self.picturesController.addAnImageButton9.imageView?.image
//        let additionalImage2 = self.picturesController.addAnImageButton10.imageView?.image
//
//        let businessSpot1 = self.businessPicturesController.addAnImageButton1.imageView?.image
//        let businessSpot2 = self.businessPicturesController.addAnImageButton2.imageView?.image
//        let businessSpot3 = self.businessPicturesController.addAnImageButton3.imageView?.image
//        let businessSpot4 = self.businessPicturesController.addAnImageButton4.imageView?.image
//
//        guard let addy = overallAddress else { return }
//        let storageRef = Storage.storage().reference().child("ParkingSpotImages").child(addy)
//        let ref = Database.database().reference().child("ParkingSpots").child(parkingID)
//        let compareImage = UIImage(named: "addImageIcon")
//
//        if mainType == "parking lot" {
//            if !(businessSpot1?.isEqualToImage(image: compareImage!))! && businessSpot1 != nil {
//                if let uploadData = businessSpot1?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("firstImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("firstImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("BusinessImages").updateChildValues(["firstImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(businessSpot2?.isEqualToImage(image: compareImage!))! && businessSpot2 != nil {
//                if let uploadData = businessSpot2?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("secondImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("secondImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("BusinessImages").updateChildValues(["secondImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(businessSpot3?.isEqualToImage(image: compareImage!))! && businessSpot3 != nil {
//                if let uploadData = businessSpot3?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("thirdImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("thirdImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("BusinessImages").updateChildValues(["thirdImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(businessSpot4?.isEqualToImage(image: compareImage!))! && businessSpot4 != nil {
//                if let uploadData = businessSpot4?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("fourthImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("fourthImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("BusinessImages").updateChildValues(["fourthImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//        } else {
//            if !(imageSpot1?.isEqualToImage(image: compareImage!))! && imageSpot1 != nil {
//                if let uploadData = imageSpot1?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("firstImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("firstImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["firstImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(imageSpot2?.isEqualToImage(image: compareImage!))! && imageSpot2 != nil {
//                if let uploadData = imageSpot2?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("secondImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("secondImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["secondImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(imageSpot3?.isEqualToImage(image: compareImage!))! && imageSpot3 != nil {
//                if let uploadData = imageSpot3?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("thirdImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("thirdImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["thirdImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(imageSpot4?.isEqualToImage(image: compareImage!))! && imageSpot4 != nil {
//                if let uploadData = imageSpot4?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("fourthImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("fourthImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["fourthImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(imageSpot5?.isEqualToImage(image: compareImage!))! && imageSpot5 != nil {
//                if let uploadData = imageSpot5?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("fifthImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("fifthImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["fifthImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(imageSpot6?.isEqualToImage(image: compareImage!))! && imageSpot6 != nil {
//                if let uploadData = imageSpot6?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("sixthImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("sixthImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["sixthImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(imageSpot7?.isEqualToImage(image: compareImage!))! && imageSpot7 != nil {
//                if let uploadData = imageSpot7?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("seventhImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("seventhImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["seventhImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(imageSpot8?.isEqualToImage(image: compareImage!))! && imageSpot8 != nil {
//                if let uploadData = imageSpot8?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("eighthImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("eighthImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["eighthImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//
//            if !(additionalImage1?.isEqualToImage(image: compareImage!))! && additionalImage1 != nil {
//                if let uploadData = additionalImage1?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("firstAdditionalImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("firstAdditionalImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["firstAdditionalImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//            if !(additionalImage2?.isEqualToImage(image: compareImage!))! && additionalImage2 != nil {
//                if let uploadData = additionalImage2?.jpegData(compressionQuality: 0.5) {
//                    storageRef.child("secondAdditionalImage").putData(uploadData, metadata: nil) { (metadata, error) in
//                        if error != nil { print(error ?? ""); return }
//                        storageRef.child("secondAdditionalImage").downloadURL(completion: { (url, error) in
//                            if let parkingURL = url?.absoluteString {
//                                ref.child("SpotImages").updateChildValues(["secondAdditionalImage": parkingURL] as [String: Any])
//                            }
//                        })
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//extension ConfigureParkingViewController {
//
//    func saveParkingButtonPressed() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let storageRef = Storage.storage().reference().child("parking_images").child("\(formattedAddress).jpg")
//        if let uploadData = parkingSpotImage!.jpegData(compressionQuality: 0.5) {
//            storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                storageRef.downloadURL(completion: { (url, error) in
//                    if url?.absoluteString != nil {
//                        let parkingImageURL = url?.absoluteString
//                        let address = formattedAddress as AnyObject
//                        let values = ["parkingImageURL": parkingImageURL]
//                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
//                        let properties = ["parkingAddress": address, "parkingImageURL": parkingImageURL!, "parkingCity": cityAddress, "parkingDistance": "0", "parkingType": self.parkingTypeController.parkingType, "numberOfSpots": self.spotNumberController.numberField.text!] as [String : AnyObject]
//                        self.addParkingWithProperties(properties: properties)
//                    } else {
//                        print("Error finding image url:", error!)
//                        return
//                    }
//                })
//            })
//        }
//    }
//
//    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
//        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
//        let usersRef = ref.child("users").child(uid)
//        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
//            if err != nil {
//                print(err!)
//                return
//            }
//        })
//    }
//
//    private func addParkingWithProperties(properties: [String: AnyObject]) {
//        let ref = Database.database().reference().child("parking")
//        let childRef = ref.childByAutoId()
//        let id = Auth.auth().currentUser!.uid
//        let timestamp = Int(Date().timeIntervalSince1970)
//        let userParkingRef = Database.database().reference().child("user-parking")
//        let userRef = Database.database().reference().child("users").child(id).child("Parking")
//
//        let parkingID = childRef.key
//        userParkingRef.updateChildValues([parkingID!: 1])
//        userRef.updateChildValues(["parkingID": parkingID!])
//
//        var values = ["parkingID": parkingID!, "id": id, "timestamp": timestamp] as [String : Any]
//
//        properties.forEach({values[$0] = $1})
//
//        childRef.updateChildValues(values) { (error, ref) in
//            if error != nil {
//                print(error ?? "")
//                return
//            }
//        }
//        finishAddingParking()
//        addOtherProperties(parkingID: parkingID!)
//    }
//
//    func finishAddingParking() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//            UIView.animate(withDuration: 1, animations: {
//            }, completion: nil)
//
////            self.delegate?.hideNewHostingController()
//            self.delegate?.bringHostingController()
//            self.view.layoutIfNeeded()
//            self.activityIndicatorParkingView.stopAnimating()
//            self.nextButton.setTitle("CONFIRM PARKING", for: .normal)
//        })
//    }
//
//    func addOtherProperties(parkingID: String) {
//        self.costsController.addPropertiesToDatabase(parkingID: parkingID)
//        self.messageController.addPropertiesToDatabase(parkingID: parkingID)
//    }
//    
}
