//
//  PrimeSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Cosmos

class PrimeSpotViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hourArray: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    var minuteArray: [Int] = [00,15,30,45]
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.8
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        let image = UIImage(named: "background1")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var spotLocatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Two-Car Driveway on 9th"
        label.font = Fonts.SSPLightH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.text = "$4.50 per hour"
        label.font = Fonts.SSPRegularH5
        
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
    
    var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        view.alpha = 0
        
        let label = UILabel(frame: CGRect(x: 24, y: 10, width: 100, height: 30))
        label.text = "Visa 4422"
        label.font = Fonts.SSPRegularH4
        view.addSubview(label)
        
        return view
    }()
    
    var carIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "singleCarIcon")
        var image = UIImage(cgImage: img!.cgImage!, scale: 1.0, orientation: UIImage.Orientation.upMirrored)
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "1"
        label.font = Fonts.SSPLightH5
        label.textAlignment = .right
        
        return label
    }()
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PURPLE
        label.text = "$9.53"
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        label.alpha = 0
        
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
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "information")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        hourPicker.delegate = self
        hourPicker.dataSource = self
        minutePicker.delegate = self
        minutePicker.dataSource = self
        
        setupViews()
        setupDuration()
        setupPurchase()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        container.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        container.addSubview(parkingImageView)
        parkingImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
        parkingImageView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        parkingImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        parkingImageView.widthAnchor.constraint(equalTo: parkingImageView.heightAnchor, constant: 32).isActive = true
        
        container.addSubview(spotLocatingLabel)
        spotLocatingLabel.topAnchor.constraint(equalTo: parkingImageView.topAnchor).isActive = true
        spotLocatingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        spotLocatingLabel.rightAnchor.constraint(equalTo: parkingImageView.leftAnchor, constant: -24).isActive = true
        spotLocatingLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        container.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: spotLocatingLabel.bottomAnchor, constant: -4).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: parkingImageView.leftAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(stars)
        stars.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0).isActive = true
        stars.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 88).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        container.addSubview(starsLabel)
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    var durationViewTopAnchor: NSLayoutConstraint!
    
    func setupDuration() {
        
        self.view.addSubview(durationView)
        durationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        durationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        durationView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8).isActive = true
        durationView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        self.view.addSubview(durationLabel)
        durationLabel.topAnchor.constraint(equalTo: durationView.topAnchor, constant: 0).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        durationLabel.widthAnchor.constraint(equalToConstant: (durationLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 15).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(hourPicker)
        hourPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hourPicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        hourPicker.centerYAnchor.constraint(equalTo: durationView.centerYAnchor, constant: 10).isActive = true
        hourPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        durationView.addSubview(minutePicker)
        minutePicker.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -40).isActive = true
        minutePicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2 - 24).isActive = true
        minutePicker.centerYAnchor.constraint(equalTo: durationView.centerYAnchor, constant: 10).isActive = true
        minutePicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        durationView.addSubview(hourLabel)
        hourLabel.leftAnchor.constraint(equalTo: hourPicker.centerXAnchor, constant: -15).isActive = true
        hourLabel.rightAnchor.constraint(equalTo: minutePicker.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: hourPicker.centerYAnchor).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(minuteLabel)
        minuteLabel.leftAnchor.constraint(equalTo: minutePicker.centerXAnchor, constant: 0).isActive = true
        minuteLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        minuteLabel.centerYAnchor.constraint(equalTo: minutePicker.centerYAnchor).isActive = true
        minuteLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setupPurchase() {

        self.view.addSubview(cardView)
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        cardView.topAnchor.constraint(equalTo: durationView.bottomAnchor, constant: -10).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        cardView.addSubview(carIcon)
        carIcon.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        carIcon.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10).isActive = true
        carIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        carIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cardView.addSubview(carLabel)
        carLabel.rightAnchor.constraint(equalTo: carIcon.leftAnchor, constant: -4).isActive = true
        carLabel.centerYAnchor.constraint(equalTo: carIcon.centerYAnchor).isActive = true
        carLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        carLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.view.addSubview(informationIcon)
        let string = "PURCHASE"
        informationIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30 + string.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3)).isActive = true
        informationIcon.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor, constant: 2).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true

        self.view.addSubview(totalCostLabel)
        totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        totalCostLabel.leftAnchor.constraint(equalTo: durationLabel.rightAnchor, constant: 24).isActive = true
        totalCostLabel.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor, constant: 5).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        self.view.addSubview(fullDatesLabel)
        fullDatesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        fullDatesLabel.leftAnchor.constraint(equalTo: durationLabel.rightAnchor, constant: 24).isActive = true
        fullDatesLabel.topAnchor.constraint(equalTo: totalCostLabel.bottomAnchor).isActive = true
        fullDatesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
//    func saveDurationPressed() {
//        UIView.animate(withDuration: animationIn) {
//            self.stars.alpha = 0
//            self.starsLabel.alpha = 0
//            self.priceLabel.alpha = 0
//        }
//    }
//
//    func confirmPurchaseDismissed() {
//        UIView.animate(withDuration: animationIn) {
//            self.stars.alpha = 1
//            self.starsLabel.alpha = 1
//            self.priceLabel.alpha = 1
//        }
//    }
    
    func bookSpotPressed() {
        UIView.animate(withDuration: animationIn) {
            self.durationView.alpha = 0
            self.cardView.alpha = 1
            self.informationIcon.alpha = 1
            self.totalCostLabel.alpha = 1
            self.fullDatesLabel.alpha = 1
        }
        self.durationLabel.text = "PURCHASE"
    }
    
    func backToBook() {
        UIView.animate(withDuration: animationIn) {
            self.durationView.alpha = 1
            self.cardView.alpha = 0
            self.informationIcon.alpha = 0
            self.totalCostLabel.alpha = 0
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
