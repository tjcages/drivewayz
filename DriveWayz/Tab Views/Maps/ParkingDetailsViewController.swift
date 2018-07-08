//
//  ParkingDetailsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/19/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class ParkingDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    var cityAddress: String?
    var parkingDistance: String?
    var imageURL: String?
    var parkingCost: String?
    var formattedAddress: String?
    var hours: Int?
    var timestamp: NSNumber?
    var id: String?
    var parkingID: String?
    
    var Monday: Int?
    var Tuesday: Int?
    var Wednesday: Int?
    var Thursday: Int?
    var Friday: Int?
    var Saturday: Int?
    var Sunday: Int?
    
    var MondayFrom: String?
    var MondayTo: String?
    var TuesdayFrom: String?
    var TuesdayTo: String?
    var WednesdayFrom: String?
    var WednesdayTo: String?
    var ThursdayFrom: String?
    var ThursdayTo: String?
    var FridayFrom: String?
    var FridayTo: String?
    var SaturdayFrom: String?
    var SaturdayTo: String?
    var SundayFrom: String?
    var SundayTo: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        collectAvailiability()
        setupViews()
    }
    
    func setData(cityAddress: String, imageURL: String, parkingCost: String, formattedAddress: String, timestamp: NSNumber, id: String, parkingID: String, parkingDistance: String) {
        labelTitle.text = cityAddress
        self.cityAddress = cityAddress
        self.parkingDistance = parkingDistance
        labelDistance.text = "\(parkingDistance) miles"
        imageView.loadImageUsingCacheWithUrlString(imageURL)
        labelCost.text = parkingCost
        self.formattedAddress = formattedAddress
        self.timestamp = timestamp
        self.id = id
        self.parkingID = parkingID
    }
    
    var parkingViewTopAnchor: NSLayoutConstraint!
    var titleLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        myScrollView.delegate = self
        
        self.view.addSubview(myScrollView)
        myScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -statusHeight).isActive = true
        myScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myScrollView.contentSize.height = 1200
        
        myScrollView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 4).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(parkingView)
        parkingView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        parkingView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        parkingViewTopAnchor = parkingView.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        parkingViewTopAnchor.isActive = true
        parkingView.heightAnchor.constraint(equalToConstant: 145).isActive = true
        
        parkingView.addSubview(labelTitle)
        titleLeftAnchor = labelTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15)
        titleLeftAnchor.isActive = true
        labelTitle.topAnchor.constraint(equalTo: parkingView.topAnchor, constant: 20).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        parkingView.addSubview(labelDistance)
        labelDistance.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 16).isActive = true
        labelDistance.topAnchor.constraint(equalTo: labelTitle.bottomAnchor).isActive = true
        labelDistance.leftAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelDistance.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        parkingView.addSubview(labelCost)
        labelCost.leftAnchor.constraint(equalTo: labelTitle.leftAnchor, constant: 16).isActive = true
        labelCost.topAnchor.constraint(equalTo: labelDistance.bottomAnchor).isActive = true
        labelCost.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelCost.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(labelDescription)
        labelDescription.leftAnchor.constraint(equalTo: parkingView.leftAnchor, constant: 20).isActive = true
        labelDescription.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 380).isActive = true
        labelDescription.rightAnchor.constraint(equalTo: parkingView.rightAnchor, constant: -20).isActive = true
        labelDescription.text = "\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\""
        labelDescription.sizeToFit()
        
        containerView.addSubview(labelAvailability)
        labelAvailability.leftAnchor.constraint(equalTo: parkingView.leftAnchor, constant: 8).isActive = true
        labelAvailability.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 8).isActive = true
        labelAvailability.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelAvailability.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(mondayButton)
        mondayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        mondayButton.topAnchor.constraint(equalTo: labelAvailability.bottomAnchor, constant: 4).isActive = true
        mondayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mondayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(mondayLabel)
        mondayLabel.leftAnchor.constraint(equalTo: mondayButton.rightAnchor, constant: 8).isActive = true
        mondayLabel.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        mondayLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        mondayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(tuesdayButton)
        tuesdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        tuesdayButton.topAnchor.constraint(equalTo: mondayButton.bottomAnchor, constant: 2).isActive = true
        tuesdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        tuesdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(tuesdayLabel)
        tuesdayLabel.leftAnchor.constraint(equalTo: tuesdayButton.rightAnchor, constant: 8).isActive = true
        tuesdayLabel.centerYAnchor.constraint(equalTo: tuesdayButton.centerYAnchor).isActive = true
        tuesdayLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        tuesdayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(wednesdayButton)
        wednesdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        wednesdayButton.topAnchor.constraint(equalTo: tuesdayButton.bottomAnchor, constant: 2).isActive = true
        wednesdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        wednesdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(wednesdayLabel)
        wednesdayLabel.leftAnchor.constraint(equalTo: wednesdayButton.rightAnchor, constant: 8).isActive = true
        wednesdayLabel.centerYAnchor.constraint(equalTo: wednesdayButton.centerYAnchor).isActive = true
        wednesdayLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        wednesdayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(thursdayButton)
        thursdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        thursdayButton.topAnchor.constraint(equalTo: wednesdayButton.bottomAnchor, constant: 2).isActive = true
        thursdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thursdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(thursdayLabel)
        thursdayLabel.leftAnchor.constraint(equalTo: thursdayButton.rightAnchor, constant: 8).isActive = true
        thursdayLabel.centerYAnchor.constraint(equalTo: thursdayButton.centerYAnchor).isActive = true
        thursdayLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        thursdayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(fridayButton)
        fridayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        fridayButton.topAnchor.constraint(equalTo: thursdayButton.bottomAnchor, constant: 2).isActive = true
        fridayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fridayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(fridayLabel)
        fridayLabel.leftAnchor.constraint(equalTo: fridayButton.rightAnchor, constant: 8).isActive = true
        fridayLabel.centerYAnchor.constraint(equalTo: fridayButton.centerYAnchor).isActive = true
        fridayLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        fridayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(saturdayButton)
        saturdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        saturdayButton.topAnchor.constraint(equalTo: fridayButton.bottomAnchor, constant: 2).isActive = true
        saturdayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        saturdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(saturdayLabel)
        saturdayLabel.leftAnchor.constraint(equalTo: saturdayButton.rightAnchor, constant: 8).isActive = true
        saturdayLabel.centerYAnchor.constraint(equalTo: saturdayButton.centerYAnchor).isActive = true
        saturdayLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        saturdayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(sundayButton)
        sundayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        sundayButton.topAnchor.constraint(equalTo: saturdayButton.bottomAnchor, constant: 2).isActive = true
        sundayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sundayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(sundayLabel)
        sundayLabel.leftAnchor.constraint(equalTo: sundayButton.rightAnchor, constant: 8).isActive = true
        sundayLabel.centerYAnchor.constraint(equalTo: sundayButton.centerYAnchor).isActive = true
        sundayLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sundayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(labelReserve)
        labelReserve.leftAnchor.constraint(equalTo: parkingView.leftAnchor, constant: 8).isActive = true
        labelReserve.topAnchor.constraint(equalTo: sundayLabel.bottomAnchor, constant: 20).isActive = true
        labelReserve.rightAnchor.constraint(equalTo: labelTitle.rightAnchor).isActive = true
        labelReserve.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(hourLabel)
        hourLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        hourLabel.topAnchor.constraint(equalTo: labelReserve.bottomAnchor, constant: 4).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hourLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        containerView.addSubview(hourSlider)
        hourSlider.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        hourSlider.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 2).isActive = true
        hourSlider.widthAnchor.constraint(equalToConstant: 300).isActive = true
        hourSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(saveReservationButton)
        saveReservationButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        saveReservationButton.topAnchor.constraint(equalTo: hourSlider.bottomAnchor, constant: 50).isActive = true
        saveReservationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveReservationButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
        
        containerView.bringSubview(toFront: parkingView)
        
    }
    
    func collectAvailiability() {
        
        let ref = Database.database().reference().child("parking").child(parkingID!).child("Availability")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let availability = snapshot.value as? [String: AnyObject] {
                
                if let mondayValues = availability["Monday"] as? [String:AnyObject] {
                    self.Monday = 1
                    self.MondayTo = mondayValues["To"] as? String
                    self.MondayFrom = mondayValues["From"] as? String
                    self.mondayLabel.text = "From  \(String(describing: self.MondayFrom!))  to  \(String(describing: self.MondayTo!))"

                    self.mondayButton.backgroundColor = Theme.PRIMARY_COLOR
                    self.mondayButton.setTitleColor(Theme.WHITE, for: .normal)
                    
                } else {
                    self.Monday = 0
                    
                    self.mondayButton.backgroundColor = UIColor.clear
                    self.mondayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                    self.mondayLabel.text = "N/A"
                }
                if let tuesdayValues = availability["Tuesday"] as? [String:AnyObject] {
                    self.Tuesday = 1
                    self.TuesdayTo = tuesdayValues["To"] as? String
                    self.TuesdayFrom = tuesdayValues["From"] as? String
                    self.tuesdayLabel.text = "From  \(String(describing: self.TuesdayFrom!))  to  \(String(describing: self.TuesdayTo!))"
                    
                    self.tuesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                    self.tuesdayButton.setTitleColor(Theme.WHITE, for: .normal)
                    
                } else {
                    self.Tuesday = 0
                    
                    self.tuesdayButton.backgroundColor = UIColor.clear
                    self.tuesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                    self.tuesdayLabel.text = "N/A"
                }
                if let wednedayValues = availability["Wednesday"] as? [String:AnyObject] {
                    self.Wednesday = 1
                    self.WednesdayTo = wednedayValues["To"] as? String
                    self.WednesdayFrom = wednedayValues["From"] as? String
                    self.wednesdayLabel.text = "From  \(String(describing: self.WednesdayFrom!))  to  \(String(describing: self.WednesdayTo!))"
                    
                    self.wednesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                    self.wednesdayButton.setTitleColor(Theme.WHITE, for: .normal)
                    
                } else {
                    self.Wednesday = 0
                    
                    self.wednesdayButton.backgroundColor = UIColor.clear
                    self.wednesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                    self.wednesdayLabel.text = "N/A"
                }
                if let thursdayValues = availability["Thursday"] as? [String:AnyObject] {
                    self.Thursday = 1
                    self.ThursdayTo = thursdayValues["To"] as? String
                    self.ThursdayFrom = thursdayValues["From"] as? String
                    self.thursdayLabel.text = "From  \(String(describing: self.ThursdayFrom!))  to  \(String(describing: self.ThursdayTo!))"
                    
                    self.thursdayButton.backgroundColor = Theme.PRIMARY_COLOR
                    self.thursdayButton.setTitleColor(Theme.WHITE, for: .normal)
                    
                } else {
                    self.Thursday = 0
                    
                    self.thursdayButton.backgroundColor = UIColor.clear
                    self.thursdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                    self.thursdayLabel.text = "N/A"
                }
                if let fridayValues = availability["Friday"] as? [String:AnyObject] {
                    self.Friday = 1
                    self.FridayTo = fridayValues["To"] as? String
                    self.FridayFrom = fridayValues["From"] as? String
                    self.fridayLabel.text = "From  \(String(describing: self.FridayFrom!))  to  \(String(describing: self.FridayTo!))"
                    
                    self.fridayButton.backgroundColor = Theme.PRIMARY_COLOR
                    self.fridayButton.setTitleColor(Theme.WHITE, for: .normal)
                    
                } else {
                    self.Friday = 0
                    
                    self.fridayButton.backgroundColor = UIColor.clear
                    self.fridayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                    self.fridayLabel.text = "N/A"
                }
                if let saturdayValues = availability["Saturday"] as? [String:AnyObject] {
                    self.Saturday = 1
                    self.SaturdayTo = saturdayValues["To"] as? String
                    self.SaturdayFrom = saturdayValues["From"] as? String
                    self.saturdayLabel.text = "From  \(String(describing: self.SaturdayFrom!))  to  \(String(describing: self.SaturdayTo!))"
                    
                    self.saturdayButton.backgroundColor = Theme.PRIMARY_COLOR
                    self.saturdayButton.setTitleColor(Theme.WHITE, for: .normal)
                    
                } else {
                    self.Saturday = 0
                    
                    self.saturdayButton.backgroundColor = UIColor.clear
                    self.saturdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                    self.saturdayLabel.text = "N/A"
                }
                if let sundayValues = availability["Sunday"] as? [String:AnyObject] {
                    self.Sunday = 1
                    self.SundayTo = sundayValues["To"] as? String
                    self.SundayFrom = sundayValues["From"] as? String
                    self.sundayLabel.text = "From  \(String(describing: self.SundayFrom!))  to  \(String(describing: self.SundayTo!))"
                    
                    self.sundayButton.backgroundColor = Theme.PRIMARY_COLOR
                    self.sundayButton.setTitleColor(Theme.WHITE, for: .normal)
                    
                } else {
                    self.Sunday = 0
                    
                    self.sundayButton.backgroundColor = UIColor.clear
                    self.sundayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                    self.sundayLabel.text = "N/A"
                }
            }
        })
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        
        saveReservationButton.isUserInteractionEnabled = true
        saveReservationButton.alpha = 1
        
        let roundedStepValue = sender.value.rounded()
        sender.value = roundedStepValue
        let formatted = String(format: "%.0f", sender.value)
        let integer = Int(formatted)
        self.hourLabel.text = "Hours: \(formatted)"
        self.hours = integer
    }
    
    @objc func saveReservationButtonPressed(sender: UIButton) {

        let product = labelTitle.text
        
        let price = labelCost.text
        let edited = price?.replacingOccurrences(of: "$", with: "")
        let editedPrice = edited?.replacingOccurrences(of: ".", with: "")
        let editedHour = editedPrice?.replacingOccurrences(of: "/hour", with: "")
        let cost: Int = Int(editedHour!)!
        
        let hours = self.hours
        let totalCost = cost * hours!
        
        let checkoutViewController = CheckoutViewController(product: product!,
                                                            price: totalCost, hours: hours!)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
    
    private var lastContentOffset: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y >= 220 {
            let statusHeight = UIApplication.shared.statusBarFrame.height
            self.parkingViewTopAnchor.constant = scrollView.contentOffset.y - 240 + statusHeight
            UIApplication.shared.statusBarStyle = .default
        } else {
            self.parkingViewTopAnchor.constant = 0
            UIApplication.shared.statusBarStyle = .lightContent
        }
        if scrollView.contentOffset.y >= 220 && scrollView.contentOffset.y <= 260 {
            let alpha = (scrollView.contentOffset.y - 220) / 20
            let image = UIImage(named: "Expand")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            exitButton.setImage(tintedImage, for: .normal)
            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            exitButton.tintColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(alpha)
        } else if scrollView.contentOffset.y < 220 {
            let image = UIImage(named: "Expand")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            exitButton.setImage(tintedImage, for: .normal)
            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            exitButton.tintColor = Theme.WHITE
        }
        if scrollView.contentOffset.y >= 220 && scrollView.contentOffset.y <= 260 {
            let alpha = (scrollView.contentOffset.y - 220)
            self.titleLeftAnchor.constant = 4 + alpha
        } else if scrollView.contentOffset.y > 260 {
            self.titleLeftAnchor.constant = 44
            let image = UIImage(named: "Expand")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            exitButton.setImage(tintedImage, for: .normal)
            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            exitButton.tintColor = Theme.PRIMARY_DARK_COLOR
        } else {
            self.titleLeftAnchor.constant = 4
            let image = UIImage(named: "Expand")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            exitButton.setImage(tintedImage, for: .normal)
            exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            exitButton.tintColor = Theme.WHITE
        }
    }
    
    
    @objc func dismissDetails(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    

    let myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let parkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "home-4")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let exitButton: UIButton = {
        let exitButton = UIButton()
        let exitImage = UIImage(named: "Expand")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(dismissDetails(sender:)), for: .touchUpInside)
        exitButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        return exitButton
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDistance: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelCost: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Theme.PRIMARY_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelAvailability: UILabel = {
        let label = UILabel()
        label.text = "Availability:"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Theme.PRIMARY_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var mondayButton: UIButton = {
        let monday = UIButton()
        monday.setTitle("M", for: .normal)
        monday.setTitleColor(Theme.WHITE, for: .normal)
        monday.backgroundColor = Theme.PRIMARY_COLOR
        monday.clipsToBounds = true
        monday.layer.cornerRadius = 20
        monday.translatesAutoresizingMaskIntoConstraints = false
        monday.isUserInteractionEnabled = false

        return monday
    }()
    
    var mondayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    var tuesdayButton: UIButton = {
        let tuesday = UIButton()
        tuesday.setTitle("T", for: .normal)
        tuesday.setTitleColor(Theme.WHITE, for: .normal)
        tuesday.backgroundColor = Theme.PRIMARY_COLOR
        tuesday.clipsToBounds = true
        tuesday.layer.cornerRadius = 20
        tuesday.translatesAutoresizingMaskIntoConstraints = false
        tuesday.isUserInteractionEnabled = false

        return tuesday
    }()
    
    var tuesdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    var wednesdayButton: UIButton = {
        let wednesday = UIButton()
        wednesday.setTitle("W", for: .normal)
        wednesday.setTitleColor(Theme.WHITE, for: .normal)
        wednesday.backgroundColor = Theme.PRIMARY_COLOR
        wednesday.clipsToBounds = true
        wednesday.layer.cornerRadius = 20
        wednesday.translatesAutoresizingMaskIntoConstraints = false
        wednesday.isUserInteractionEnabled = false

        return wednesday
    }()
    
    var wednesdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    var thursdayButton: UIButton = {
        let thursday = UIButton()
        thursday.setTitle("T.", for: .normal)
        thursday.setTitleColor(Theme.WHITE, for: .normal)
        thursday.backgroundColor = Theme.PRIMARY_COLOR
        thursday.clipsToBounds = true
        thursday.layer.cornerRadius = 20
        thursday.translatesAutoresizingMaskIntoConstraints = false
        thursday.isUserInteractionEnabled = false

        return thursday
    }()
    
    var thursdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    var fridayButton: UIButton = {
        let friday = UIButton()
        friday.setTitle("F", for: .normal)
        friday.setTitleColor(Theme.WHITE, for: .normal)
        friday.backgroundColor = Theme.PRIMARY_COLOR
        friday.clipsToBounds = true
        friday.layer.cornerRadius = 20
        friday.translatesAutoresizingMaskIntoConstraints = false
        friday.isUserInteractionEnabled = false

        return friday
    }()
    
    var fridayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    var saturdayButton: UIButton = {
        let saturday = UIButton()
        saturday.setTitle("S", for: .normal)
        saturday.setTitleColor(Theme.WHITE, for: .normal)
        saturday.backgroundColor = Theme.PRIMARY_COLOR
        saturday.clipsToBounds = true
        saturday.layer.cornerRadius = 20
        saturday.translatesAutoresizingMaskIntoConstraints = false
        saturday.isUserInteractionEnabled = false

        return saturday
    }()
    
    var saturdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    var sundayButton: UIButton = {
        let sunday = UIButton()
        sunday.setTitle("S.", for: .normal)
        sunday.setTitleColor(Theme.WHITE, for: .normal)
        sunday.backgroundColor = Theme.PRIMARY_COLOR
        sunday.clipsToBounds = true
        sunday.layer.cornerRadius = 20
        sunday.translatesAutoresizingMaskIntoConstraints = false
        sunday.isUserInteractionEnabled = false

        return sunday
    }()
    
    var sundayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let labelReserve: UILabel = {
        let label = UILabel()
        label.text = "Reserve:"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Theme.PRIMARY_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var hourLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Theme.PRIMARY_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Hours"
        
        return label
    }()
    
    var hourSlider: UISlider = {
        let slider = UISlider(frame:CGRect(x: 10, y: 100, width: 300, height: 20))
        slider.minimumValue = 0
        slider.maximumValue = 24
        slider.isContinuous = true
        slider.tintColor = Theme.PRIMARY_COLOR
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
        
        return slider
    }()
    
    var saveReservationButton: UIButton = {
        let saveParkingButton = UIButton()
        saveParkingButton.setTitle("Reserve Spot", for: .normal)
        saveParkingButton.setTitle("", for: .selected)
        saveParkingButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        saveParkingButton.backgroundColor = Theme.PRIMARY_COLOR
        saveParkingButton.alpha = 0.5
        saveParkingButton.translatesAutoresizingMaskIntoConstraints = false
        saveParkingButton.titleLabel?.textColor = Theme.WHITE
        saveParkingButton.layer.cornerRadius = 15
        saveParkingButton.isUserInteractionEnabled = false
        saveParkingButton.addTarget(self, action: #selector(saveReservationButtonPressed(sender:)), for: .touchUpInside)
        
        return saveParkingButton
    }()
}














