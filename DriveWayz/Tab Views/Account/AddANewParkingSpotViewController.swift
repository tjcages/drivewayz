//
//  AddANewParkingSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import GoogleMaps
import GooglePlaces

let DenverLocation = CLLocation(latitude: 39.7392, longitude: -104.9903)
let tenMiles = 16093.4 //meters
var expensesListing: Int = 1
var searchController: UISearchController?
var resultView: UITextView?

class AddANewParkingSpotViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var parkingLicensePlate: MadokaTextField!
    var parkingYear: MadokaTextField!
    var parkingModel: MadokaTextField!
    var parkingMake: MadokaTextField!
    var parkingImageView: UIImageView!
    var parkingImageURL: String?
    
    var visualBlurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurparkingInfoView = UIVisualEffectView(effect: blurEffect)
        blurparkingInfoView.alpha = 1
        blurparkingInfoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurparkingInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurparkingInfoView
    }()
    
    var costParking: String = "$1.00"
    var parkingSpotImage: UIImage?
    var parking: Int = 0
    
    var monday: Int = 1
    var tuesday: Int = 1
    var wednesday: Int = 1
    var thursday: Int = 1
    var friday: Int = 1
    var saturday: Int = 1
    var sunday: Int = 1
    
    var mondayFrom: String = "All Day"
    var mondayTo: String = "All Day"
    var tuesdayFrom: String = "All Day"
    var tuesdayTo: String = "All Day"
    var wednesdayFrom: String = "All Day"
    var wednesdayTo: String = "All Day"
    var thursdayFrom: String = "All Day"
    var thursdayTo: String = "All Day"
    var fridayFrom: String = "All Day"
    var fridayTo: String = "All Day"
    var saturdayFrom: String = "All Day"
    var saturdayTo: String = "All Day"
    var sundayFrom: String = "All Day"
    var sundayTo: String = "All Day"

    var addANewParkingView: UIView = {
        let addANewParkingView = UIView()
        addANewParkingView.layer.cornerRadius = 20
        addANewParkingView.clipsToBounds = true
        addANewParkingView.isUserInteractionEnabled = true
        addANewParkingView.translatesAutoresizingMaskIntoConstraints = false
        
        return addANewParkingView
    }()
    
    let activityIndicatorParkingView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let mapView: GMSMapView = {
        let view = GMSMapView()
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UITextField = {
        let search = UITextField()
        search.borderStyle = .roundedRect
        search.backgroundColor = .white
        search.layer.borderColor = UIColor.darkGray.cgColor
        search.placeholder = "Search.."
        search.translatesAutoresizingMaskIntoConstraints = false
        search.addTarget(self, action: #selector(searchBarSearching), for: .editingDidBegin)
        return search
    }()
    
    var mondayButton: UIButton = {
        let monday = UIButton()
        monday.setTitle("M", for: .normal)
        monday.setTitleColor(Theme.WHITE, for: .normal)
        monday.backgroundColor = Theme.PRIMARY_COLOR
        monday.clipsToBounds = true
        monday.layer.cornerRadius = 20
        monday.addTarget(self, action: #selector(mondayPressed(sender:)), for: .touchUpInside)
        monday.translatesAutoresizingMaskIntoConstraints = false
        
        return monday
    }()
    
    var tuesdayButton: UIButton = {
        let tuesday = UIButton()
        tuesday.setTitle("T", for: .normal)
        tuesday.setTitleColor(Theme.WHITE, for: .normal)
        tuesday.backgroundColor = Theme.PRIMARY_COLOR
        tuesday.clipsToBounds = true
        tuesday.layer.cornerRadius = 20
        tuesday.addTarget(self, action: #selector(tuesdayPressed(sender:)), for: .touchUpInside)
        tuesday.translatesAutoresizingMaskIntoConstraints = false
        
        return tuesday
    }()
    
    var wednesdayButton: UIButton = {
        let wednesday = UIButton()
        wednesday.setTitle("W", for: .normal)
        wednesday.setTitleColor(Theme.WHITE, for: .normal)
        wednesday.backgroundColor = Theme.PRIMARY_COLOR
        wednesday.clipsToBounds = true
        wednesday.layer.cornerRadius = 20
        wednesday.addTarget(self, action: #selector(wednesdayPressed(sender:)), for: .touchUpInside)
        wednesday.translatesAutoresizingMaskIntoConstraints = false
        
        return wednesday
    }()
    
    var thursdayButton: UIButton = {
        let thursday = UIButton()
        thursday.setTitle("T.", for: .normal)
        thursday.setTitleColor(Theme.WHITE, for: .normal)
        thursday.backgroundColor = Theme.PRIMARY_COLOR
        thursday.clipsToBounds = true
        thursday.layer.cornerRadius = 20
        thursday.addTarget(self, action: #selector(thursdayPressed(sender:)), for: .touchUpInside)
        thursday.translatesAutoresizingMaskIntoConstraints = false
        
        return thursday
    }()
    
    var fridayButton: UIButton = {
        let friday = UIButton()
        friday.setTitle("F", for: .normal)
        friday.setTitleColor(Theme.WHITE, for: .normal)
        friday.backgroundColor = Theme.PRIMARY_COLOR
        friday.clipsToBounds = true
        friday.layer.cornerRadius = 20
        friday.addTarget(self, action: #selector(fridayPressed(sender:)), for: .touchUpInside)
        friday.translatesAutoresizingMaskIntoConstraints = false
        
        return friday
    }()
    
    var saturdayButton: UIButton = {
        let saturday = UIButton()
        saturday.setTitle("S", for: .normal)
        saturday.setTitleColor(Theme.WHITE, for: .normal)
        saturday.backgroundColor = Theme.PRIMARY_COLOR
        saturday.clipsToBounds = true
        saturday.layer.cornerRadius = 20
        saturday.addTarget(self, action: #selector(saturdayPressed(sender:)), for: .touchUpInside)
        saturday.translatesAutoresizingMaskIntoConstraints = false
        
        return saturday
    }()
    
    var sundayButton: UIButton = {
        let sunday = UIButton()
        sunday.setTitle("S.", for: .normal)
        sunday.setTitleColor(Theme.WHITE, for: .normal)
        sunday.backgroundColor = Theme.PRIMARY_COLOR
        sunday.clipsToBounds = true
        sunday.layer.cornerRadius = 20
        sunday.addTarget(self, action: #selector(sundayPressed(sender:)), for: .touchUpInside)
        sunday.translatesAutoresizingMaskIntoConstraints = false
        
        return sunday
    }()
    
    var calendarLabel: UILabel = {
        let calendar = UILabel()
        calendar.text = "Select the days of availability:"
        calendar.textColor = Theme.WHITE
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return calendar
    }()
    
    var segmentedControl: UISegmentedControl = {
        let items = ["Everyday", "Specific Days"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5
        segment.backgroundColor = UIColor.white
        segment.tintColor = Theme.PRIMARY_COLOR
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(changeSegmentCalendar(sender:)), for: .valueChanged)
        
        return segment
    }()
    
    var timesLabel: UILabel = {
        let times = UILabel()
        times.text = "Times:"
        times.textColor = Theme.WHITE
        times.translatesAutoresizingMaskIntoConstraints = false
        times.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        times.contentMode = .center
        
        return times
    }()
    
    var pickerView: UIView!
    var timeFromPicker: UIPickerView!
    var timeToPicker: UIPickerView!
    
    func everydayTimePicker() {
        pickerView = UIView()
        pickerView.backgroundColor = UIColor.clear
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.alpha = 1
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        fromLabel.contentMode = .center
        pickerView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: pickerView.leftAnchor, constant: 16).isActive = true
        fromLabel.topAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        timeFromPicker = UIPickerView()
        timeFromPicker.backgroundColor = UIColor.clear
        timeFromPicker.tintColor = Theme.WHITE
        timeFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        timeFromPicker.translatesAutoresizingMaskIntoConstraints = false
        timeFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        timeFromPicker.delegate = self
        timeFromPicker.dataSource = self
        pickerView.addSubview(timeFromPicker)
        
        timeFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor).isActive = true
        timeFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        timeFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        toLabel.contentMode = .center
        pickerView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: timeFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeToPicker = UIPickerView()
        timeToPicker.backgroundColor = UIColor.clear
        timeToPicker.tintColor = Theme.WHITE
        timeToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        timeToPicker.translatesAutoresizingMaskIntoConstraints = false
        timeToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        timeToPicker.delegate = self
        timeToPicker.dataSource = self
        pickerView.addSubview(timeToPicker)
        
        timeToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor).isActive = true
        timeToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        timeToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var costPicker: UIPickerView = {
        let cost = UIPickerView()
        cost.backgroundColor = UIColor.clear
        cost.tintColor = Theme.WHITE
        cost.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        cost.translatesAutoresizingMaskIntoConstraints = false
        cost.setValue(UIColor.white, forKeyPath: "textColor")
        
        return cost
    }()
    
    var mondayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Monday:"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var mondayFromPicker: UIPickerView = {
        let mondayFromPicker = UIPickerView()
        mondayFromPicker.backgroundColor = UIColor.clear
        mondayFromPicker.tintColor = Theme.WHITE
        mondayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        mondayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        mondayFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        mondayFromPicker.alpha = 0
        
        return mondayFromPicker
    }()
    
    var mondayToPicker: UIPickerView = {
        let mondayToPicker = UIPickerView()
        mondayToPicker.backgroundColor = UIColor.clear
        mondayToPicker.tintColor = Theme.WHITE
        mondayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        mondayToPicker.translatesAutoresizingMaskIntoConstraints = false
        mondayToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        mondayToPicker.alpha = 0
        
        return mondayToPicker
    }()
    
    func mondayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        mondayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: mondayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: mondayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        mondayTimeView.addSubview(mondayFromPicker)
        mondayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        mondayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        mondayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mondayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        mondayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: mondayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        mondayTimeView.addSubview(mondayToPicker)
        mondayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        mondayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        mondayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mondayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var tuesdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Tuesday:"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var tuesdayFromPicker: UIPickerView = {
        let tuesdayFromPicker = UIPickerView()
        tuesdayFromPicker.backgroundColor = UIColor.clear
        tuesdayFromPicker.tintColor = Theme.WHITE
        tuesdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        tuesdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        tuesdayFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        tuesdayFromPicker.alpha = 0
        
        return tuesdayFromPicker
    }()
    
    var tuesdayToPicker: UIPickerView = {
        let tuesdayToPicker = UIPickerView()
        tuesdayToPicker.backgroundColor = UIColor.clear
        tuesdayToPicker.tintColor = Theme.WHITE
        tuesdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        tuesdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        tuesdayToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        tuesdayToPicker.alpha = 0
        
        return tuesdayToPicker
    }()
    
    func tuesdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        tuesdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: tuesdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: tuesdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        tuesdayTimeView.addSubview(tuesdayFromPicker)
        tuesdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        tuesdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        tuesdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        tuesdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        tuesdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: tuesdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        tuesdayTimeView.addSubview(tuesdayToPicker)
        tuesdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        tuesdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        tuesdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        tuesdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var wednesdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Wednesday:"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var wednesdayFromPicker: UIPickerView = {
        let wednesdayFromPicker = UIPickerView()
        wednesdayFromPicker.backgroundColor = UIColor.clear
        wednesdayFromPicker.tintColor = Theme.WHITE
        wednesdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        wednesdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        wednesdayFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        wednesdayFromPicker.alpha = 0
        
        return wednesdayFromPicker
    }()
    
    var wednesdayToPicker: UIPickerView = {
        let wednesdayToPicker = UIPickerView()
        wednesdayToPicker.backgroundColor = UIColor.clear
        wednesdayToPicker.tintColor = Theme.WHITE
        wednesdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        wednesdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        wednesdayToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        wednesdayToPicker.alpha = 0
        
        return wednesdayToPicker
    }()
    
    func wednesdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        wednesdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: wednesdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: wednesdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        wednesdayTimeView.addSubview(wednesdayFromPicker)
        wednesdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        wednesdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        wednesdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        wednesdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        wednesdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: wednesdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        wednesdayTimeView.addSubview(wednesdayToPicker)
        wednesdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        wednesdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        wednesdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        wednesdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var thursdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Thursday:"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var thursdayFromPicker: UIPickerView = {
        let thursdayFromPicker = UIPickerView()
        thursdayFromPicker.backgroundColor = UIColor.clear
        thursdayFromPicker.tintColor = Theme.WHITE
        thursdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        thursdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        thursdayFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        thursdayFromPicker.alpha = 0
        
        return thursdayFromPicker
    }()
    
    var thursdayToPicker: UIPickerView = {
        let thursdayToPicker = UIPickerView()
        thursdayToPicker.backgroundColor = UIColor.clear
        thursdayToPicker.tintColor = Theme.WHITE
        thursdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        thursdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        thursdayToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        thursdayToPicker.alpha = 0
        
        return thursdayToPicker
    }()
    
    func thursdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        thursdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: thursdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: thursdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        thursdayTimeView.addSubview(thursdayFromPicker)
        thursdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        thursdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        thursdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thursdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        thursdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: thursdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        thursdayTimeView.addSubview(thursdayToPicker)
        thursdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        thursdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        thursdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thursdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var fridayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Friday:"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var fridayFromPicker: UIPickerView = {
        let fridayFromPicker = UIPickerView()
        fridayFromPicker.backgroundColor = UIColor.clear
        fridayFromPicker.tintColor = Theme.WHITE
        fridayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        fridayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        fridayFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        fridayFromPicker.alpha = 0
        
        return fridayFromPicker
    }()
    
    var fridayToPicker: UIPickerView = {
        let fridayToPicker = UIPickerView()
        fridayToPicker.backgroundColor = UIColor.clear
        fridayToPicker.tintColor = Theme.WHITE
        fridayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        fridayToPicker.translatesAutoresizingMaskIntoConstraints = false
        fridayToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        fridayToPicker.alpha = 0
        
        return fridayToPicker
    }()
    
    func fridayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        fridayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: fridayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: fridayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        fridayTimeView.addSubview(fridayFromPicker)
        fridayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        fridayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        fridayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fridayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        fridayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: fridayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        fridayTimeView.addSubview(fridayToPicker)
        fridayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        fridayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        fridayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fridayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var saturdayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Saturday:"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var saturdayFromPicker: UIPickerView = {
        let saturdayFromPicker = UIPickerView()
        saturdayFromPicker.backgroundColor = UIColor.clear
        saturdayFromPicker.tintColor = Theme.WHITE
        saturdayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        saturdayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        saturdayFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        saturdayFromPicker.alpha = 0
        
        return saturdayFromPicker
    }()
    
    var saturdayToPicker: UIPickerView = {
        let saturdayToPicker = UIPickerView()
        saturdayToPicker.backgroundColor = UIColor.clear
        saturdayToPicker.tintColor = Theme.WHITE
        saturdayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        saturdayToPicker.translatesAutoresizingMaskIntoConstraints = false
        saturdayToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        saturdayToPicker.alpha = 0
        
        return saturdayToPicker
    }()
    
    func saturdayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        saturdayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: saturdayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: saturdayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        saturdayTimeView.addSubview(saturdayFromPicker)
        saturdayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        saturdayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        saturdayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        saturdayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        saturdayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: saturdayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        saturdayTimeView.addSubview(saturdayToPicker)
        saturdayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        saturdayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        saturdayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        saturdayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var sundayTimeView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        
        let image = UIImage(named: "Expand")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Sunday:"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return container
    }()
    
    var sundayFromPicker: UIPickerView = {
        let sundayFromPicker = UIPickerView()
        sundayFromPicker.backgroundColor = UIColor.clear
        sundayFromPicker.tintColor = Theme.WHITE
        sundayFromPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        sundayFromPicker.translatesAutoresizingMaskIntoConstraints = false
        sundayFromPicker.setValue(UIColor.white, forKeyPath: "textColor")
        sundayFromPicker.alpha = 0
        
        return sundayFromPicker
    }()
    
    var sundayToPicker: UIPickerView = {
        let sundayToPicker = UIPickerView()
        sundayToPicker.backgroundColor = UIColor.clear
        sundayToPicker.tintColor = Theme.WHITE
        sundayToPicker.frame = CGRect(x: 0, y: 0, width: 400, height: 280)
        sundayToPicker.translatesAutoresizingMaskIntoConstraints = false
        sundayToPicker.setValue(UIColor.white, forKeyPath: "textColor")
        sundayToPicker.alpha = 0
        
        return sundayToPicker
    }()
    
    func sundayTimePicker() {
        
        let fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.textColor = Theme.WHITE
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        fromLabel.contentMode = .center
        sundayTimeView.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: sundayTimeView.leftAnchor, constant: 32).isActive = true
        fromLabel.topAnchor.constraint(equalTo: sundayTimeView.topAnchor, constant: 4).isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fromLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        sundayTimeView.addSubview(sundayFromPicker)
        sundayFromPicker.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 4).isActive = true
        sundayFromPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        sundayFromPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sundayFromPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let toLabel = UILabel()
        toLabel.text = "To"
        toLabel.textColor = Theme.WHITE
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toLabel.contentMode = .center
        sundayTimeView.addSubview(toLabel)
        
        toLabel.leftAnchor.constraint(equalTo: sundayFromPicker.rightAnchor, constant: 8).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        sundayTimeView.addSubview(sundayToPicker)
        sundayToPicker.leftAnchor.constraint(equalTo: toLabel.rightAnchor, constant: 4).isActive = true
        sundayToPicker.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
        sundayToPicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sundayToPicker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    private let timeValues: NSArray = ["All Day","1:00 am","1:15 am","1:30 am","1:45 am","2:00 am","2:15 am","2:30 am","2:45 am","3:00 am","3:15 am","3:30 am","3:45 am","4:00 am","4:15 am","4:30 am","4:45 am","5:00 am","5:15 am","5:30 am","5:45 am","6:00 am","6:15 am","6:30 am","6:45 am","7:00 am","7:15 am","7:30 am","7:45 am","8:00 am","8:15 am","8:30 am","8:45 am","9:00 am","9:15 am","9:30 am","9:45 am","10:00 am","10:15 am","10:30 am","10:45 am","11:00 am","11:15 am","11:30 am","11:45 am","12:00 pm","12:15 pm","12:30 pm","12:45 pm","1:00 pm","1:15 pm","1:30 pm","1:45 pm","2:00 pm","2:15 pm","2:30 pm","2:45 pm","3:00 pm","3:15 pm","3:30 pm","3:45 pm","4:00 pm","4:15 pm","4:30 pm","4:45 pm","5:00 pm","5:15 pm","5:30 pm","5:45 pm","6:00 pm","6:15 pm","6:30 pm","6:45 pm","7:00 pm","7:15 pm","7:30 pm","7:45 pm","8:00 pm","8:15 pm","8:30 pm","8:45 pm","9:00 pm","9:15 pm","9:30 pm","9:45 pm","10:00 pm","10:15 pm","10:30 pm","10:45 pm","11:00 pm","11:15 pm","11:30 pm","11:45 pm","12:00 pm","12:15 pm","12:30 pm","12:45 pm"]
    
    private let cheapCostValues: NSArray = ["$4.00","$4.50","$5.00","$5.50","$6.00","$6.50","$7.00","$7.50","$8.00"]
    
    private let expensiveCostValues: NSArray = ["$8.00","$8.50","$9.00","$9.50","$10.00", "$10.50", "$11.00", "$11.50", "$12.00"]
    
    lazy var fullBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    lazy var panoLabel: UILabel = {
        let panoLabel = UILabel()
        panoLabel.text = "Please pan around until you can clearly see the parking spot. Try to fit the entire view within the line on the left."
        panoLabel.textColor = UIColor.white
        panoLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        panoLabel.contentMode = .center
        panoLabel.numberOfLines = 4
        panoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLabel
    }()
    
    lazy var panoLine: UIView = {
        let panoLine = UIView()
        panoLine.backgroundColor = Theme.PRIMARY_COLOR
        panoLine.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
        panoLine.layer.borderWidth = 1
        panoLine.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLine
    }()
    
    lazy var screenShotButton: UIButton = {
        let screenShot = UIButton()
        screenShot.backgroundColor = Theme.PRIMARY_COLOR
        screenShot.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        screenShot.layer.shadowRadius = 3
        screenShot.layer.shadowOpacity = 0
        screenShot.translatesAutoresizingMaskIntoConstraints = false
        screenShot.setTitle("Press to Select", for: .normal)
        screenShot.tintColor = UIColor.white
        screenShot.layer.cornerRadius = 15
        screenShot.alpha = 1
        
        return screenShot
    }()
    
    lazy var exitButton: UIButton = {
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(dismissPano), for: .touchUpInside)
        
        return exitButton
    }()
    
    
    var overlay: UIView = {
        let overlay = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        overlay.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        overlay.layer.borderWidth = 2
        overlay.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5)
        
        return overlay
    }()
    
    lazy var dotLabel: UILabel = {
        let panoLabel = UILabel()
        panoLabel.text = "Please move the dots to highlight the area for parking. Press confirm when the dots clearly indicate the spot."
        panoLabel.textColor = UIColor.white
        panoLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        panoLabel.contentMode = .center
        panoLabel.numberOfLines = 4
        panoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLabel
    }()
    
    lazy var dotShotButton: UIButton = {
        let screenShot = UIButton()
        screenShot.backgroundColor = Theme.PRIMARY_COLOR
        screenShot.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        screenShot.layer.shadowRadius = 3
        screenShot.layer.shadowOpacity = 0
        screenShot.translatesAutoresizingMaskIntoConstraints = false
        screenShot.setTitle("Confirm Parking Spot", for: .normal)
        screenShot.tintColor = UIColor.white
        screenShot.layer.cornerRadius = 15
        screenShot.alpha = 1
        screenShot.addTarget(self, action: #selector(finalScreenShot(sender:)), for: .touchUpInside)
        
        return screenShot
    }()
    
    let fullBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var screenShotView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.tabBarController?.tabBar.isHidden = true

        mapView.delegate = self
        
        costPicker.delegate = self
        costPicker.dataSource = self
        mondayFromPicker.delegate = self
        mondayFromPicker.dataSource = self
        mondayToPicker.delegate = self
        mondayToPicker.dataSource = self
        tuesdayFromPicker.delegate = self
        tuesdayFromPicker.dataSource = self
        tuesdayToPicker.delegate = self
        tuesdayToPicker.dataSource = self
        wednesdayFromPicker.delegate = self
        wednesdayFromPicker.dataSource = self
        wednesdayToPicker.delegate = self
        wednesdayToPicker.dataSource = self
        thursdayFromPicker.dataSource = self
        thursdayToPicker.delegate = self
        thursdayToPicker.dataSource = self
        thursdayFromPicker.delegate = self
        fridayFromPicker.dataSource = self
        fridayToPicker.delegate = self
        fridayToPicker.dataSource = self
        fridayFromPicker.delegate = self
        saturdayFromPicker.dataSource = self
        saturdayToPicker.delegate = self
        saturdayToPicker.dataSource = self
        saturdayFromPicker.delegate = self
        sundayFromPicker.delegate = self
        sundayFromPicker.dataSource = self
        sundayToPicker.delegate = self
        sundayToPicker.dataSource = self
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        setupAddAParkingView()
        
    }

    var pickerParking: UIImagePickerController?
    
    @objc func handleSelectParkingImageView() {
        pickerParking = UIImagePickerController()
        pickerParking?.delegate = self
        pickerParking?.allowsEditing = true
        
        present(pickerParking!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            if picker == pickerParking {
                parkingSpotImage = selectedImage
                self.takeScreenShot()
            }
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let imageName = NSUUID().uuidString
        
        if picker == pickerParking {
            let storageRef = Storage.storage().reference().child("parking_images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(selectedImageFromPicker!, 0.5) {
                storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if url?.absoluteString != nil {
                            self.parkingImageURL = url?.absoluteString
                            let values = ["parkingImageURL": self.parkingImageURL]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        } else {
                            print("Error finding image url:", error!)
                            return
                        }
                    })
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
        let usersRef = ref.child("users").child(uid)
        
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        exitAddParking()
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var scrollViewParking: UIScrollView!
    var saveParkingButton: UIButton!
    var correctButton: UIButton!
    var parkingContainerView: UIView!
    var correctButtonBottomAnchor: NSLayoutConstraint!
    
    func setupAddAParkingView() {
        
        self.view.addSubview(visualBlurEffect)
        visualBlurEffect.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        visualBlurEffect.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        visualBlurEffect.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        visualBlurEffect.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        
        self.view.addSubview(addANewParkingView)
        addANewParkingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addANewParkingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        addANewParkingView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50).isActive = true
        addANewParkingView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 170).isActive = true
        
        addANewParkingView.addSubview(mapView)
        mapView.centerXAnchor.constraint(equalTo: addANewParkingView.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: addANewParkingView.centerYAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: addANewParkingView.heightAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: addANewParkingView.widthAnchor).isActive = true
        
        addANewParkingView.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: addANewParkingView.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: 200).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
        let searchImage = UIImage(named: "map_Pin")
        setupTextField(textField: searchBar, img: searchImage!)
        
        correctButton = UIButton()
        correctButton.backgroundColor = Theme.PRIMARY_COLOR
        correctButton.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        correctButton.layer.shadowRadius = 3
        correctButton.layer.shadowOpacity = 0
        correctButton.translatesAutoresizingMaskIntoConstraints = false
        correctButton.setTitle("Correct Location?", for: .normal)
        correctButton.tintColor = UIColor.white
        correctButton.layer.cornerRadius = 15
        correctButton.alpha = 0
        
        addANewParkingView.addSubview(correctButton)
        correctButton.centerXAnchor.constraint(equalTo: addANewParkingView.centerXAnchor).isActive = true
        correctButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        correctButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        correctButtonBottomAnchor = correctButton.bottomAnchor.constraint(equalTo: addANewParkingView.bottomAnchor, constant: 40)
        correctButtonBottomAnchor.isActive = true
        
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitAddParking), for: .touchUpInside)
        addANewParkingView.addSubview(exitButton)
        
        exitButton.rightAnchor.constraint(equalTo: addANewParkingView.rightAnchor, constant: 16).isActive = true
        exitButton.topAnchor.constraint(equalTo: addANewParkingView.topAnchor, constant: -16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        setupDayOfTheWeeks()
        
    }
    
    var weekContainer: UIView!
    var costLabelEverydayAnchor: NSLayoutConstraint!
    var costLabelSpecificAnchor: NSLayoutConstraint!
    var mondayHeightAnchor: NSLayoutConstraint!
    var tuesdayHeightAnchor: NSLayoutConstraint!
    var wednesdayHeightAnchor: NSLayoutConstraint!
    var thursdayHeightAnchor: NSLayoutConstraint!
    var fridayHeightAnchor: NSLayoutConstraint!
    var saturdayHeightAnchor: NSLayoutConstraint!
    var sundayHeightAnchor: NSLayoutConstraint!
    
    func setupDayOfTheWeeks() {
        
        weekContainer = UIView()
        weekContainer.backgroundColor = UIColor.clear
        weekContainer.translatesAutoresizingMaskIntoConstraints = false
        weekContainer.alpha = 0
        self.view.addSubview(weekContainer)
        
        weekContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        weekContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weekContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        weekContainer.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        scrollViewParking = UIScrollView(frame: view.bounds)
        scrollViewParking.backgroundColor = UIColor.clear
        scrollViewParking.isScrollEnabled = true
        scrollViewParking.showsVerticalScrollIndicator = true
        scrollViewParking.showsHorizontalScrollIndicator = false
        scrollViewParking.translatesAutoresizingMaskIntoConstraints = false
        scrollViewParking.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        weekContainer.addSubview(scrollViewParking)
        
        scrollViewParking.leftAnchor.constraint(equalTo: weekContainer.leftAnchor).isActive = true
        scrollViewParking.rightAnchor.constraint(equalTo: weekContainer.rightAnchor).isActive = true
        scrollViewParking.topAnchor.constraint(equalTo: weekContainer.topAnchor).isActive = true
        scrollViewParking.bottomAnchor.constraint(equalTo: weekContainer.bottomAnchor).isActive = true
        
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitAddParking), for: .touchUpInside)
        weekContainer.addSubview(exitButton)
        
        exitButton.rightAnchor.constraint(equalTo: weekContainer.rightAnchor).isActive = true
        exitButton.topAnchor.constraint(equalTo: weekContainer.topAnchor, constant: 32).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollViewParking.addSubview(calendarLabel)
        calendarLabel.topAnchor.constraint(equalTo: scrollViewParking.topAnchor, constant: 100).isActive = true
        calendarLabel.leftAnchor.constraint(equalTo: weekContainer.leftAnchor, constant: 20).isActive = true
        calendarLabel.rightAnchor.constraint(equalTo: weekContainer.rightAnchor, constant: -20).isActive = true
        calendarLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollViewParking.addSubview(mondayButton)
        scrollViewParking.addSubview(tuesdayButton)
        scrollViewParking.addSubview(wednesdayButton)
        scrollViewParking.addSubview(thursdayButton)
        scrollViewParking.addSubview(fridayButton)
        scrollViewParking.addSubview(saturdayButton)
        scrollViewParking.addSubview(sundayButton)
        
        mondayButton.leftAnchor.constraint(equalTo: weekContainer.leftAnchor, constant: (self.view.frame.width - 280) / 8).isActive = true
        mondayButton.topAnchor.constraint(equalTo: calendarLabel.bottomAnchor, constant: 10).isActive = true
        mondayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mondayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        tuesdayButton.leftAnchor.constraint(equalTo: mondayButton.rightAnchor, constant: (self.view.frame.width - 280) / 8).isActive = true
        tuesdayButton.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        tuesdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tuesdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        wednesdayButton.leftAnchor.constraint(equalTo: tuesdayButton.rightAnchor, constant: (self.view.frame.width - 280) / 8).isActive = true
        wednesdayButton.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        wednesdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        wednesdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        thursdayButton.leftAnchor.constraint(equalTo: wednesdayButton.rightAnchor, constant: (self.view.frame.width - 280) / 8).isActive = true
        thursdayButton.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        thursdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        thursdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        fridayButton.leftAnchor.constraint(equalTo: thursdayButton.rightAnchor, constant: (self.view.frame.width - 280) / 8).isActive = true
        fridayButton.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        fridayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fridayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        saturdayButton.leftAnchor.constraint(equalTo: fridayButton.rightAnchor, constant: (self.view.frame.width - 280) / 8).isActive = true
        saturdayButton.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        saturdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saturdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        sundayButton.leftAnchor.constraint(equalTo: saturdayButton.rightAnchor, constant: (self.view.frame.width - 280) / 8).isActive = true
        sundayButton.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        sundayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sundayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollViewParking.addSubview(timesLabel)
        timesLabel.topAnchor.constraint(equalTo: sundayButton.bottomAnchor, constant: 25).isActive = true
        timesLabel.leftAnchor.constraint(equalTo: weekContainer.leftAnchor, constant: 20).isActive = true
        timesLabel.rightAnchor.constraint(equalTo: weekContainer.rightAnchor, constant: -40).isActive = true
        timesLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollViewParking.addSubview(segmentedControl)
        segmentedControl.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: timesLabel.bottomAnchor, constant: 10).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        everydayTimePicker()
        
        scrollViewParking.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40).isActive = true
        pickerView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        mondayTimePicker()
        
        scrollViewParking.addSubview(mondayTimeView)
        mondayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        mondayTimeView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40).isActive = true
        mondayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        mondayHeightAnchor = mondayTimeView.heightAnchor.constraint(equalToConstant: 120)
        mondayHeightAnchor.isActive = true
        
        tuesdayTimePicker()
        
        scrollViewParking.addSubview(tuesdayTimeView)
        tuesdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        tuesdayTimeView.topAnchor.constraint(equalTo: mondayTimeView.bottomAnchor, constant: 5).isActive = true
        tuesdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        tuesdayHeightAnchor = tuesdayTimeView.heightAnchor.constraint(equalToConstant: 120)
        tuesdayHeightAnchor.isActive = true
        
        wednesdayTimePicker()
        
        scrollViewParking.addSubview(wednesdayTimeView)
        wednesdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        wednesdayTimeView.topAnchor.constraint(equalTo: tuesdayTimeView.bottomAnchor, constant: 5).isActive = true
        wednesdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        wednesdayHeightAnchor = wednesdayTimeView.heightAnchor.constraint(equalToConstant: 120)
        wednesdayHeightAnchor.isActive = true
        
        thursdayTimePicker()
        
        scrollViewParking.addSubview(thursdayTimeView)
        thursdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        thursdayTimeView.topAnchor.constraint(equalTo: wednesdayTimeView.bottomAnchor, constant: 5).isActive = true
        thursdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        thursdayHeightAnchor = thursdayTimeView.heightAnchor.constraint(equalToConstant: 120)
        thursdayHeightAnchor.isActive = true
        
        fridayTimePicker()
        
        scrollViewParking.addSubview(fridayTimeView)
        fridayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        fridayTimeView.topAnchor.constraint(equalTo: thursdayTimeView.bottomAnchor, constant: 5).isActive = true
        fridayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        fridayHeightAnchor = fridayTimeView.heightAnchor.constraint(equalToConstant: 120)
        fridayHeightAnchor.isActive = true
        
        saturdayTimePicker()
        
        scrollViewParking.addSubview(saturdayTimeView)
        saturdayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        saturdayTimeView.topAnchor.constraint(equalTo: fridayTimeView.bottomAnchor, constant: 5).isActive = true
        saturdayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        saturdayHeightAnchor = saturdayTimeView.heightAnchor.constraint(equalToConstant: 120)
        saturdayHeightAnchor.isActive = true
        
        sundayTimePicker()
        
        scrollViewParking.addSubview(sundayTimeView)
        sundayTimeView.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        sundayTimeView.topAnchor.constraint(equalTo: saturdayTimeView.bottomAnchor, constant: 5).isActive = true
        sundayTimeView.widthAnchor.constraint(equalTo: weekContainer.widthAnchor).isActive = true
        sundayHeightAnchor = sundayTimeView.heightAnchor.constraint(equalToConstant: 120)
        sundayHeightAnchor.isActive = true
        
        let costLabel = UILabel()
        costLabel.text = "Cost:"
        costLabel.textColor = Theme.WHITE
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        costLabel.contentMode = .center
        scrollViewParking.addSubview(costLabel)
        
        costLabel.leftAnchor.constraint(equalTo: pickerView.leftAnchor, constant: 20).isActive = true
        costLabelEverydayAnchor = costLabel.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10)
        costLabelEverydayAnchor.isActive = true
        costLabelSpecificAnchor = costLabel.topAnchor.constraint(equalTo: sundayTimeView.bottomAnchor, constant: 10)
        costLabelSpecificAnchor.isActive = false
        costLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        costLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        costPicker.transform = CGAffineTransform(rotationAngle: (-90 * (.pi/180)))
        scrollViewParking.addSubview(costPicker)
        costPicker.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor).isActive = true
        costPicker.centerXAnchor.constraint(equalTo: weekContainer.centerXAnchor).isActive = true
        costPicker.widthAnchor.constraint(equalToConstant: 80).isActive = true
        costPicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let hourLabel = UILabel()
        hourLabel.text = "/Hour"
        hourLabel.textColor = Theme.WHITE
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        hourLabel.contentMode = .center
        scrollViewParking.addSubview(hourLabel)
        
        hourLabel.rightAnchor.constraint(equalTo: pickerView.rightAnchor, constant: -20).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hourLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        saveParkingButton = UIButton()
        saveParkingButton.setTitle("Save", for: .normal)
        saveParkingButton.setTitle("", for: .selected)
        saveParkingButton.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        saveParkingButton.translatesAutoresizingMaskIntoConstraints = false
        saveParkingButton.titleLabel?.textColor = Theme.WHITE
        saveParkingButton.layer.cornerRadius = 30
        saveParkingButton.layer.borderColor = UIColor.white.cgColor
        saveParkingButton.layer.borderWidth = 2
        saveParkingButton.addTarget(self, action: #selector(saveParkingButtonPressed(sender:)), for: .touchUpInside)
        scrollViewParking.addSubview(saveParkingButton)
        
        saveParkingButton.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        saveParkingButton.topAnchor.constraint(equalTo: costPicker.bottomAnchor, constant: -30).isActive = true
        saveParkingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveParkingButton.widthAnchor.constraint(equalToConstant: self.view.frame.width * 3/4).isActive = true
        
        saveParkingButton.addSubview(activityIndicatorParkingView)
        activityIndicatorParkingView.centerXAnchor.constraint(equalTo: saveParkingButton.centerXAnchor).isActive = true
        activityIndicatorParkingView.centerYAnchor.constraint(equalTo: saveParkingButton.centerYAnchor).isActive = true
        activityIndicatorParkingView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorParkingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func searchBarSearching() {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        lattitudeConstant = place.coordinate.latitude
        longitudeConstant = place.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lattitudeConstant, longitude: longitudeConstant, zoom: 18.0)
        mapView.camera = camera
        searchBar.text = place.formattedAddress
        formattedAddress = place.formattedAddress!
        
        let addressSeparated = formattedAddress.components(separatedBy: ",")
        cityAddress = addressSeparated[1] + addressSeparated[2]
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lattitudeConstant, longitude: longitudeConstant)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = mapView
        
        checkDistance()
        
        self.dismiss(animated: true) {
            self.correctButtonBottomAnchor.constant = -20
            self.correctButton.addTarget(self, action: #selector(self.selectPanoView(sender:)), for: .touchUpInside)
            UIView.animate(withDuration: 1, animations: {
                self.correctButton.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func checkDistance() {
        let location = CLLocation(latitude: lattitudeConstant, longitude: longitudeConstant)
        let distanceFromLocation = location.distance(from: DenverLocation)
        print(distanceFromLocation)
        if distanceFromLocation <= tenMiles {
            expensesListing = 1
        } else {
            expensesListing = 0
        }
    }
    
    @objc func selectPanoView(sender: UIButton) {
        let alert = UIAlertController(title: "Select an Image:", message: "How would you like to upload an image of the parking spot?", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.default, handler: { action in
            self.handleSelectParkingImageView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.bringSecondOptions()
            }
        }))
        alert.addAction(UIAlertAction(title: "Google Street View", style: UIAlertActionStyle.default, handler: { action in
            self.sendAlready()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.bringSecondOptions()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func sendAlready() {
        let panoViewController = PanoViewController()
        present(panoViewController, animated: true, completion: nil)
    }
    
    func bringSecondOptions() {
        self.view.bringSubview(toFront: weekContainer)
        UIView.animate(withDuration: 1) {
            self.addANewParkingView.alpha = 0
            self.weekContainer.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func bringFirstOptions() {
        self.view.sendSubview(toBack: weekContainer)
        self.addANewParkingView.removeFromSuperview()
        UIView.animate(withDuration: 1) {
            self.weekContainer.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func mondayPressed(sender: UIButton) {
        if monday == 1 {
            monday = 0
            self.mondayButton.backgroundColor = UIColor.clear
            self.mondayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            self.mondayHeightAnchor.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.mondayTimeView.alpha = 0
                self.mondayToPicker.alpha = 0
                self.mondayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            monday = 1
            self.mondayButton.backgroundColor = Theme.PRIMARY_COLOR
            self.mondayButton.setTitleColor(UIColor.white, for: .normal)
            if segment == 0 {
                self.mondayHeightAnchor.constant = 120
                UIView.animate(withDuration: 0.3) {
                    self.mondayTimeView.alpha = 1
                    self.mondayToPicker.alpha = 1
                    self.mondayFromPicker.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func tuesdayPressed(sender: UIButton) {
        if tuesday == 1 {
            tuesday = 0
            self.tuesdayButton.backgroundColor = UIColor.clear
            self.tuesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            self.tuesdayHeightAnchor.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.tuesdayTimeView.alpha = 0
                self.tuesdayToPicker.alpha = 0
                self.tuesdayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            tuesday = 1
            self.tuesdayButton.backgroundColor = Theme.PRIMARY_COLOR
            self.tuesdayButton.setTitleColor(UIColor.white, for: .normal)
            if segment == 0 {
                self.tuesdayHeightAnchor.constant = 120
                UIView.animate(withDuration: 0.3) {
                    self.tuesdayTimeView.alpha = 1
                    self.tuesdayToPicker.alpha = 1
                    self.tuesdayFromPicker.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func wednesdayPressed(sender: UIButton) {
        if wednesday == 1 {
            wednesday = 0
            self.wednesdayButton.backgroundColor = UIColor.clear
            self.wednesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            self.wednesdayHeightAnchor.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.wednesdayTimeView.alpha = 0
                self.wednesdayToPicker.alpha = 0
                self.wednesdayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            wednesday = 1
            self.wednesdayButton.backgroundColor = Theme.PRIMARY_COLOR
            self.wednesdayButton.setTitleColor(UIColor.white, for: .normal)
            if segment == 0 {
                self.wednesdayHeightAnchor.constant = 120
                UIView.animate(withDuration: 0.3) {
                    self.wednesdayTimeView.alpha = 1
                    self.wednesdayToPicker.alpha = 1
                    self.wednesdayFromPicker.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func thursdayPressed(sender: UIButton) {
        if thursday == 1 {
            thursday = 0
            self.thursdayButton.backgroundColor = UIColor.clear
            self.thursdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            self.thursdayHeightAnchor.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.thursdayTimeView.alpha = 0
                self.thursdayToPicker.alpha = 0
                self.thursdayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            thursday = 1
            self.thursdayButton.backgroundColor = Theme.PRIMARY_COLOR
            self.thursdayButton.setTitleColor(UIColor.white, for: .normal)
            if segment == 0 {
                self.thursdayHeightAnchor.constant = 120
                UIView.animate(withDuration: 0.3) {
                    self.thursdayTimeView.alpha = 1
                    self.thursdayToPicker.alpha = 1
                    self.thursdayFromPicker.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func fridayPressed(sender: UIButton) {
        if friday == 1 {
            friday = 0
            self.fridayButton.backgroundColor = UIColor.clear
            self.fridayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            self.fridayHeightAnchor.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.fridayTimeView.alpha = 0
                self.fridayToPicker.alpha = 0
                self.fridayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            friday = 1
            self.fridayButton.backgroundColor = Theme.PRIMARY_COLOR
            self.fridayButton.setTitleColor(UIColor.white, for: .normal)
            if segment == 0 {
                self.fridayHeightAnchor.constant = 120
                UIView.animate(withDuration: 0.3) {
                    self.fridayTimeView.alpha = 1
                    self.fridayToPicker.alpha = 1
                    self.fridayFromPicker.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func saturdayPressed(sender: UIButton) {
        if saturday == 1 {
            saturday = 0
            self.saturdayButton.backgroundColor = UIColor.clear
            self.saturdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            self.saturdayHeightAnchor.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.saturdayTimeView.alpha = 0
                self.saturdayToPicker.alpha = 0
                self.saturdayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            saturday = 1
            self.saturdayButton.backgroundColor = Theme.PRIMARY_COLOR
            self.saturdayButton.setTitleColor(UIColor.white, for: .normal)
            if self.segment == 0 {
                self.saturdayHeightAnchor.constant = 120
                UIView.animate(withDuration: 0.3) {
                    self.saturdayTimeView.alpha = 1
                    self.saturdayToPicker.alpha = 1
                    self.saturdayFromPicker.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func sundayPressed(sender: UIButton) {
        if sunday == 1 {
            sunday = 0
            self.sundayButton.backgroundColor = UIColor.clear
            self.sundayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
            self.sundayHeightAnchor.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.sundayTimeView.alpha = 0
                self.sundayToPicker.alpha = 0
                self.sundayFromPicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            sunday = 1
            self.sundayButton.backgroundColor = Theme.PRIMARY_COLOR
            self.sundayButton.setTitleColor(UIColor.white, for: .normal)
            if self.segment == 0 {
                self.sundayHeightAnchor.constant = 120
                UIView.animate(withDuration: 0.3) {
                    self.sundayTimeView.alpha = 1
                    self.sundayToPicker.alpha = 1
                    self.sundayFromPicker.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    var segment: Int = 1
    
    @objc func changeSegmentCalendar(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            segment = 0
            costLabelEverydayAnchor.isActive = false
            costLabelSpecificAnchor.isActive = true
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerView.alpha = 0
                if self.monday == 1 {
                    self.mondayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.mondayTimeView.alpha = 1
                        self.mondayToPicker.alpha = 1
                        self.mondayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.tuesday == 1 {
                    self.tuesdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.tuesdayTimeView.alpha = 1
                        self.tuesdayToPicker.alpha = 1
                        self.tuesdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.wednesday == 1 {
                    self.wednesdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.wednesdayTimeView.alpha = 1
                        self.wednesdayToPicker.alpha = 1
                        self.wednesdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.thursday == 1 {
                    self.thursdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.thursdayTimeView.alpha = 1
                        self.thursdayToPicker.alpha = 1
                        self.thursdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.friday == 1 {
                    self.fridayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.fridayTimeView.alpha = 1
                        self.fridayToPicker.alpha = 1
                        self.fridayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.saturday == 1 {
                    self.saturdayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.saturdayTimeView.alpha = 1
                        self.saturdayToPicker.alpha = 1
                        self.saturdayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                if self.sunday == 1 {
                    self.sundayHeightAnchor.constant = 120
                    UIView.animate(withDuration: 0.3) {
                        self.sundayTimeView.alpha = 1
                        self.sundayToPicker.alpha = 1
                        self.sundayFromPicker.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
                self.scrollViewParking.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2.5)
                self.view.layoutIfNeeded()
            }, completion: nil)
        default:
            segment = 1
            costLabelEverydayAnchor.isActive = true
            costLabelSpecificAnchor.isActive = false
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerView.alpha = 1
                self.mondayTimeView.alpha = 0
                self.mondayToPicker.alpha = 0
                self.mondayFromPicker.alpha = 0
                self.mondayTimeView.alpha = 0
                self.mondayToPicker.alpha = 0
                self.mondayFromPicker.alpha = 0
                self.tuesdayTimeView.alpha = 0
                self.tuesdayToPicker.alpha = 0
                self.tuesdayFromPicker.alpha = 0
                self.wednesdayTimeView.alpha = 0
                self.wednesdayToPicker.alpha = 0
                self.wednesdayFromPicker.alpha = 0
                self.thursdayTimeView.alpha = 0
                self.thursdayToPicker.alpha = 0
                self.thursdayFromPicker.alpha = 0
                self.fridayTimeView.alpha = 0
                self.fridayToPicker.alpha = 0
                self.fridayFromPicker.alpha = 0
                self.saturdayTimeView.alpha = 0
                self.saturdayToPicker.alpha = 0
                self.saturdayFromPicker.alpha = 0
                self.sundayTimeView.alpha = 0
                self.sundayToPicker.alpha = 0
                self.sundayFromPicker.alpha = 0
                self.scrollViewParking.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == costPicker {
            return 70
        } else {
            return 20
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == costPicker {
            return 40
        } else {
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == costPicker {
            if expensesListing == 1 {
                return expensiveCostValues.count
            } else {
                return cheapCostValues.count
            }
        } else {
            return timeValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == costPicker {
            if expensesListing == 1 {
                return expensiveCostValues[row] as? String
            } else {
                return cheapCostValues[row] as? String
            }
        } else {
            return timeValues[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == costPicker {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 120, height: 140)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 120, height: 140)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 20)
            
            if expensesListing == 1 {
                label.text = expensiveCostValues[row] as? String
            } else {
                label.text = cheapCostValues[row] as? String
            }
            
            view.addSubview(label)
            
            view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
            
            return view
        } else {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 20)
            label.text = timeValues[row] as? String
            view.addSubview(label)
            
            return view
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == costPicker {
            if expensesListing == 1 {
                costParking = expensiveCostValues[row] as! String
            } else {
                costParking = cheapCostValues[row] as! String
            }
        } else if pickerView == timeFromPicker {
            mondayFrom = timeValues[row] as! String
            tuesdayFrom = timeValues[row] as! String
            wednesdayFrom = timeValues[row] as! String
            thursdayFrom = timeValues[row] as! String
            fridayFrom = timeValues[row] as! String
            saturdayFrom = timeValues[row] as! String
            sundayFrom = timeValues[row] as! String
        } else if pickerView == timeToPicker {
            mondayTo = timeValues[row] as! String
            tuesdayTo = timeValues[row] as! String
            wednesdayTo = timeValues[row] as! String
            thursdayTo = timeValues[row] as! String
            fridayTo = timeValues[row] as! String
            saturdayTo = timeValues[row] as! String
            sundayTo = timeValues[row] as! String
        } else if pickerView == mondayFromPicker {
            mondayFrom = timeValues[row] as! String
        } else if pickerView == mondayToPicker {
            mondayTo = timeValues[row] as! String
        } else if pickerView == tuesdayFromPicker {
            tuesdayFrom = timeValues[row] as! String
        } else if pickerView == tuesdayToPicker {
            tuesdayTo = timeValues[row] as! String
        } else if pickerView == wednesdayFromPicker {
            wednesdayFrom = timeValues[row] as! String
        } else if pickerView == wednesdayToPicker {
            wednesdayTo = timeValues[row] as! String
        } else if pickerView == thursdayFromPicker {
            thursdayFrom = timeValues[row] as! String
        } else if pickerView == thursdayToPicker {
            thursdayTo = timeValues[row] as! String
        } else if pickerView == fridayFromPicker {
            fridayFrom = timeValues[row] as! String
        } else if pickerView == fridayToPicker {
            fridayTo = timeValues[row] as! String
        } else if pickerView == saturdayFromPicker {
            saturdayFrom = timeValues[row] as! String
        } else if pickerView == saturdayToPicker {
            saturdayTo = timeValues[row] as! String
        } else if pickerView == sundayFromPicker {
            sundayFrom = timeValues[row] as! String
        } else if pickerView == sundayToPicker {
            sundayTo = timeValues[row] as! String
        } else {
            print("something else")
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    @objc func saveParkingButtonPressed(sender: UIButton) {
        activityIndicatorParkingView.startAnimating()
        saveParkingButton.isSelected = true
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let storageRef = Storage.storage().reference().child("parking_images").child("\(formattedAddress).jpg")
        if let uploadData = UIImageJPEGRepresentation(parkingSpotImage!, 0.5) {
            storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let perHour = "/hour"
                let cost = self.costParking + perHour
                
                storageRef.downloadURL(completion: { (url, error) in
                    if url?.absoluteString != nil {
                        let parkingImageURL = url?.absoluteString
                        let values = ["parkingImageURL": parkingImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        let properties = ["parkingAddress" : formattedAddress, "parkingImageURL" : parkingImageURL, "parkingCost": cost, "parkingCity": cityAddress, "parkingDistance": "0"] as [String : AnyObject]
                        self.addParkingWithProperties(properties: properties)
                    } else {
                        print("Error finding image url:", error!)
                        return
                    }
                })
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.exitAddParking()
        })
    }
    
    private func addParkingWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("parking")
        let childRef = ref.childByAutoId()
        let id = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let userParkingRef = Database.database().reference().child("user-parking")
        let userRef = Database.database().reference().child("users").child(id)
        
        let parkingID = childRef.key
        userParkingRef.updateChildValues([parkingID: 1])
        userRef.updateChildValues(["parkingID": parkingID])
        
        var values = ["parkingID": parkingID, "id": id, "timestamp": timestamp] as [String : Any]
        
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
        }
        if monday == 1 {
            childRef.child("Availability").child("Monday").updateChildValues(["From": mondayFrom, "To": mondayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            childRef.child("Availability").updateChildValues(["Monday": monday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if tuesday == 1 {
            childRef.child("Availability").child("Tuesday").updateChildValues(["From": tuesdayFrom, "To": tuesdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            childRef.child("Availability").updateChildValues(["Tuesday": tuesday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if wednesday == 1 {
            childRef.child("Availability").child("Wednesday").updateChildValues(["From": wednesdayFrom, "To": wednesdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            childRef.child("Availability").updateChildValues(["Wednesday": wednesday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if thursday == 1 {
            childRef.child("Availability").child("Thursday").updateChildValues(["From": thursdayFrom, "To": thursdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            childRef.child("Availability").updateChildValues(["Thursday": thursday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if friday == 1 {
            childRef.child("Availability").child("Friday").updateChildValues(["From": fridayFrom, "To": fridayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            childRef.child("Availability").updateChildValues(["Friday": friday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if saturday == 1 {
            childRef.child("Availability").child("Saturday").updateChildValues(["From": saturdayFrom, "To": saturdayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            childRef.child("Availability").updateChildValues(["Saturday": saturday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        if sunday == 1 {
            childRef.child("Availability").child("Sunday").updateChildValues(["From": sundayFrom, "To": sundayTo]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            childRef.child("Availability").updateChildValues(["Sunday": sunday]) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }
        finishAddingParking()
    }
    
    func finishAddingParking() {
        bringFirstOptions()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            UIView.animate(withDuration: 1, animations: {
            }, completion: nil)
            self.view.layoutIfNeeded()
            self.activityIndicatorParkingView.stopAnimating()
        })
    }
    
    @objc func exitAddParking() {
        if parking > 0 {
            self.finishAddingParking()
        } else {}
        self.view.alpha = 0
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartUpViewController") as! StartUpViewController
        
        present(viewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        addANewParkingView.endEditing(true)
    }
    
    @objc func tabBarRight() {
        print("Rightmost VC")
    }
    @objc func tabBarLeft() {
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.selectedIndex = 1
        }, completion: nil)
    }
    
    
    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {}
    
    func takeScreenShot() {
        
        self.view.addSubview(fullBlurView)
        fullBlurView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fullBlurView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fullBlurView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        fullBlurView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        screenShotView = UIImageView(image: parkingSpotImage)
        screenShotView.contentMode = .scaleAspectFit
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenShotView)
        
        screenShotView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        screenShotView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        screenShotView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 120).isActive = true
        screenShotView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(dotLabel)
        dotLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        dotLabel.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: 4).isActive = true
        dotLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor).isActive = true
        dotLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        
        self.view.addSubview(dotShotButton)
        dotShotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dotShotButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dotShotButton.widthAnchor.constraint(equalToConstant: 215).isActive = true
        dotShotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        
        addOverlay()
    }
    
    @objc func finalScreenShot(sender: UIButton) {
        
        let contextImage = view?.snapshot
        let rect = CGRect(x: 0, y: 300, width: self.view.frame.width, height: self.view.frame.height + 80)
        let croppedImage = cropping(contextImage!, toRect: rect)
        parkingSpotImage = croppedImage
        parking = parking + 1
        startActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.screenShotView.removeFromSuperview()
            self.activityIndicatorView.stopAnimating()
            self.fullBlurView.removeFromSuperview()
            self.fullBlur.removeFromSuperview()
            self.dotLabel.removeFromSuperview()
            self.dotShotButton.removeFromSuperview()
            self.overlay.removeFromSuperview()
            self.exitButton.removeFromSuperview()
            dot1.removeFromSuperview()
            dot2.removeFromSuperview()
            dot3.removeFromSuperview()
            dot4.removeFromSuperview()
            self.shapeLayer.removeFromSuperlayer()
        })
    }
    
    @objc func dismissPano() {
        self.screenShotView.removeFromSuperview()
    }
    
    func startActivityIndicator() {
        self.view.addSubview(self.fullBlur)
        
        self.fullBlur.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.fullBlur.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.fullBlur.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.fullBlur.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.activityIndicatorView.startAnimating()
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let startActivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var dot1View: UIView!
    var dot2View: UIView!
    var dot3View: UIView!
    var dot4View: UIView!
    
    func addOverlay() {
        
        dot1 = UIButton(frame: CGRect(x: 100, y: 300, width: 36, height: 36))
        dot1.layer.cornerRadius = 18
        dot1.layer.backgroundColor = UIColor.clear.cgColor
        dot1.translatesAutoresizingMaskIntoConstraints = false
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panButton1(sender:)))
        dot1.addGestureRecognizer(pan1)
        view.addSubview(dot1)
        
        dot1View = UIView()
        dot1View.layer.cornerRadius = 4
        dot1View.backgroundColor = Theme.PRIMARY_COLOR
        dot1View.center = dot1.center
        dot1View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot1View)
        
        dot1View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.centerXAnchor.constraint(equalTo: dot1.centerXAnchor).isActive = true
        dot1View.centerYAnchor.constraint(equalTo: dot1.centerYAnchor).isActive = true
        
        dot1.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        dot2 = UIButton(frame: CGRect(x: 200, y: 300, width: 36, height: 36))
        dot2.layer.cornerRadius = 18
        dot2.backgroundColor = UIColor.clear
        dot2.translatesAutoresizingMaskIntoConstraints = false
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(panButton2(sender:)))
        dot2.addGestureRecognizer(pan2)
        view.addSubview(dot2)
        
        dot2View = UIView()
        dot2View.layer.cornerRadius = 4
        dot2View.backgroundColor = Theme.PRIMARY_COLOR
        dot2View.center = dot1.center
        dot2View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot2View)
        
        dot2View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.centerXAnchor.constraint(equalTo: dot2.centerXAnchor).isActive = true
        dot2View.centerYAnchor.constraint(equalTo: dot2.centerYAnchor).isActive = true
        
        dot2.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        dot3 = UIButton(frame: CGRect(x: 200, y: 400, width: 36, height: 36))
        dot3.layer.cornerRadius = 18
        dot3.backgroundColor = UIColor.clear
        dot3.translatesAutoresizingMaskIntoConstraints = false
        let pan3 = UIPanGestureRecognizer(target: self, action: #selector(panButton3(sender:)))
        dot3.addGestureRecognizer(pan3)
        view.addSubview(dot3)
        
        dot3View = UIView()
        dot3View.layer.cornerRadius = 4
        dot3View.backgroundColor = Theme.PRIMARY_COLOR
        dot3View.center = dot1.center
        dot3View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot3View)
        
        dot3View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.centerXAnchor.constraint(equalTo: dot3.centerXAnchor).isActive = true
        dot3View.centerYAnchor.constraint(equalTo: dot3.centerYAnchor).isActive = true
        
        dot3.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot3.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        
        dot4 = UIButton(frame: CGRect(x: 100, y: 400, width: 36, height: 36))
        dot4.layer.cornerRadius = 18
        dot4.backgroundColor = UIColor.clear
        dot4.translatesAutoresizingMaskIntoConstraints = false
        let pan4 = UIPanGestureRecognizer(target: self, action: #selector(panButton4(sender:)))
        dot4.addGestureRecognizer(pan4)
        view.addSubview(dot4)
        
        dot4View = UIView()
        dot4View.layer.cornerRadius = 4
        dot4View.backgroundColor = Theme.PRIMARY_COLOR
        dot4View.center = dot1.center
        dot4View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot4View)
        
        dot4View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.centerXAnchor.constraint(equalTo: dot4.centerXAnchor).isActive = true
        dot4View.centerYAnchor.constraint(equalTo: dot4.centerYAnchor).isActive = true
        
        dot4.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot4.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        
        self.view.layer.addSublayer(shapeLayer)
        startPan()
        
    }
    
    func cropping(_ inputImage: UIImage, toRect cropRect: CGRect) -> UIImage {
        
        let cropZone = CGRect(x:cropRect.origin.x,
                              y:cropRect.origin.y,
                              width:cropRect.size.width * 2,
                              height:cropRect.size.height)
        
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return inputImage
        }
        
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
        
    }
    
    func startPan() {
        let location1 = CGPoint(x: 100, y: 300)
        let location2 = CGPoint(x: 200, y: 300)
        let location3 = CGPoint(x: 200, y: 400)
        let location4 = CGPoint(x: 100, y: 400)
        dot1.center = location1
        dot1View.center = location1
        dot2.center = location2
        dot2View.center = location2
        dot3.center = location3
        dot3View.center = location3
        dot4.center = location4
        dot4View.center = location4
        moveOverlay()
    }
    
    @objc func panButton1(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot1.center = location // set button to where finger is
            dot1View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton2(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot2.center = location // set button to where finger is
            dot2View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton3(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot3.center = location // set button to where finger is
            dot3View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton4(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot4.center = location // set button to where finger is
            dot4View.center = location
        }
        moveOverlay()
    }
    
    let shapeLayer = CAShapeLayer()
    
    func moveOverlay() {
        //        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let width: CGFloat = 640
        let height: CGFloat = 640
        
        shapeLayer.frame = CGRect(x: 0, y: 0,
                                  width: width, height: height)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: dot1.center.x, y: dot1.center.y))
        path.addLine(to: CGPoint(x: dot2.center.x, y: dot2.center.y))
        path.addLine(to: CGPoint(x: dot3.center.x, y: dot3.center.y))
        path.addLine(to: CGPoint(x: dot4.center.x, y: dot4.center.y))
        path.close()
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = Theme.PRIMARY_COLOR.cgColor
        shapeLayer.fillColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5).cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
    }

}


// Handle the user's selection.
extension AccountViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}