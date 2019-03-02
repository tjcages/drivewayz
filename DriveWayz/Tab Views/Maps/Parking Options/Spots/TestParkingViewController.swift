//
//  TestParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/19/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos
import NVActivityIndicatorView
import CoreLocation

class TestParkingViewController: UIViewController {

    var hourArray: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    var minuteArray: [Int] = [00,15,30,45]
    
    var delegate: handleParkingImages?
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 60
        let image = UIImage(named: "exampleParking")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var spotLocatingLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "One-Car Driveway on University Heights Avenue"
        label.font = Fonts.SSPRegularH2
        label.isUserInteractionEnabled = false
//        label.isScrollEnabled = false
        label.isEditable = false
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.text = "$3.15 / hour"
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 15
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.SEA_BLUE
        view.settings.emptyBorderColor = Theme.OFF_WHITE
        view.settings.filledBorderColor = Theme.SEA_BLUE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "10"
        label.font = Fonts.SSPLightH5
        
        return label
    }()
    
    var durationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "DURATION"
        label.font = Fonts.SSPSemiBoldH3
        label.backgroundColor = Theme.WHITE
        
        return label
    }()
    
    var hourPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.BLACK
        picker.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.BLACK, forKeyPath: "textColor")
        
        return picker
    }()
    
    var minutePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.BLACK
        picker.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.BLACK, forKeyPath: "textColor")
        
        return picker
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "HOUR"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var minuteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "MINUTES"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var fullDatesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "2:15 PM to 4:30 PM"
        label.font = Fonts.SSPLightH3
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        loading.contentMode = .left
        loading.color = Theme.DARK_GRAY.withAlphaComponent(0.7)
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
//        hourPicker.delegate = self
//        hourPicker.dataSource = self
//        minutePicker.delegate = self
//        minutePicker.dataSource = self
        
        setupViews()
    }
    
    func configureDynamicParking(parking: ParkingSpots, overallDestination: CLLocationCoordinate2D) {
        if let latitude = parking.latitude, let longitude = parking.longitude, let state = parking.stateAddress, let city = parking.cityAddress {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
            dynamicPricing.getDynamicPricing(place: location, state: state, city: city, overallDestination: overallDestination) { (dynamicPrice: CGFloat) in
                let price = String(format: "%.2f", dynamicPrice)
                self.priceLabel.text = "$\(price) per hour"
                self.loadingActivity.alpha = 0
                self.loadingActivity.stopAnimating()
            }
        }
    }
    
    func setData(parking: ParkingSpots) {
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
        self.priceLabel.text = ""
        if var streetAddress = parking.streetAddress, let numberSpots = parking.numberSpots, let secondaryType = parking.secondaryType {
            if let spaceRange = streetAddress.range(of: " ") {
                streetAddress.removeSubrange(streetAddress.startIndex..<spaceRange.upperBound)
                if let number = Int(numberSpots) {
                    let wordString = number.asWord
                    let publicAddress = "\(wordString.capitalizingFirstLetter())-Car \(secondaryType.capitalizingFirstLetter()) on \(streetAddress)"
                    self.spotLocatingLabel.text = publicAddress
                    if let numberRatings = parking.numberRatings, let totalRating = parking.totalRating {
                        if let ratings = Double(numberRatings), let total = Double(totalRating) {
                            let averageRating: Double = total/ratings
                            self.stars.rating = averageRating
                            self.starsLabel.text = numberRatings
                        }
                    } else {
                        self.stars.rating = 5
                        self.starsLabel.text = ""
                    }
                    if let firstPhoto = parking.firstImage {
                        self.delegate?.setPrimeImage(imageString: firstPhoto)
                    }
                }
            }
        }
    }

    func setupViews() {
        
        self.view.addSubview(spotLocatingLabel)
        spotLocatingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 136).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: (spotLocatingLabel.text?.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPRegularH2))! + 12).isActive = true
        
        self.view.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -4).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 26).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(stars)
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2).isActive = true
        stars.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 26).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 88).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.view.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.leftAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -4).isActive = true
        loadingActivity.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        loadingActivity.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    var durationViewTopAnchor: NSLayoutConstraint!
    
//    func setupDuration() {
//
//        self.view.addSubview(durationView)
//        durationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
//        durationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
//        durationView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8).isActive = true
//        durationView.heightAnchor.constraint(equalToConstant: 90).isActive = true
//
//        self.view.addSubview(durationLabel)
//        durationLabel.topAnchor.constraint(equalTo: durationView.topAnchor, constant: 0).isActive = true
//        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
//        durationLabel.widthAnchor.constraint(equalToConstant: (durationLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 15).isActive = true
//        durationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        durationView.addSubview(hourPicker)
//        hourPicker.selectRow(1, inComponent: 0, animated: false)
//        hourPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        hourPicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
//        hourPicker.centerYAnchor.constraint(equalTo: durationView.centerYAnchor, constant: 18).isActive = true
//        hourPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        durationView.addSubview(minutePicker)
//        minutePicker.selectRow(1, inComponent: 0, animated: false)
//        minutePicker.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -40).isActive = true
//        minutePicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2 - 24).isActive = true
//        minutePicker.centerYAnchor.constraint(equalTo: durationView.centerYAnchor, constant: 18).isActive = true
//        minutePicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        durationView.addSubview(hourLabel)
//        hourLabel.leftAnchor.constraint(equalTo: hourPicker.centerXAnchor, constant: -15).isActive = true
//        hourLabel.rightAnchor.constraint(equalTo: minutePicker.centerXAnchor).isActive = true
//        hourLabel.centerYAnchor.constraint(equalTo: hourPicker.centerYAnchor).isActive = true
//        hourLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        durationView.addSubview(minuteLabel)
//        minuteLabel.leftAnchor.constraint(equalTo: minutePicker.centerXAnchor, constant: 0).isActive = true
//        minuteLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        minuteLabel.centerYAnchor.constraint(equalTo: minutePicker.centerYAnchor).isActive = true
//        minuteLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//    }
    
    func backToBook() {
        UIView.animate(withDuration: animationIn) {
            self.durationView.alpha = 1
            self.fullDatesLabel.alpha = 0
        }
        self.durationLabel.text = "DURATION"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width/2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hourPicker && self.hourArray.count > 0 {
            return self.hourArray.count
        } else if pickerView == minutePicker && self.minuteArray.count > 0 {
            return self.minuteArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == hourPicker && self.hourArray.count > row {
            return "\(self.hourArray[row])"
        } else if pickerView == minutePicker && self.minuteArray.count > row {
            return "\(self.minuteArray[row])"
        } else {
            return "0"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        
        let label = UILabel()
        label.frame = CGRect(x: -40, y: 0, width: 90, height: 80)
        label.textAlignment = .center
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        if pickerView == hourPicker && self.hourArray.count > row {
            label.text = "\(self.hourArray[row])"
        } else if pickerView == minutePicker && self.minuteArray.count > row {
            if self.minuteArray[row] == 0 {
                label.text = "00"
            } else {
                label.text = "\(self.minuteArray[row])"
            }
        }
        
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPicker {
            if row > 0 {
                self.hourLabel.text = "HOURS"
            } else {
                self.hourLabel.text = "HOUR"
            }
        }
    }
    
}
