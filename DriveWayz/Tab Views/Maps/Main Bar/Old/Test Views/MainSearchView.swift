//
//  TestSearchViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class MainSearchView: UIViewController {
    
    var delegate: handleInviteControllers?
    lazy var bottomHeight: CGFloat = -cancelBottomHeight + durationBottomController.buttonHeight + 16
    var recents: [String] = ["", ""]
    var cellHeight: CGFloat = 64
    
    var city: String? {
        didSet {
            if let city = self.city {
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(city) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        else {
                            // handle no location found
                            return
                    }
                    userCurrentLocation = location
                }
            }
        }
    }
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Good morning"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where are you headed?"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var recommendationButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.BLUE.withAlphaComponent(0.8), for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        label.contentHorizontalAlignment = .left
        
        return label
    }()
    
    var searchView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        button.clipsToBounds = true
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Parking near "
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Search")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var discountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DarkGreen.withAlphaComponent(0.9)
        button.setTitle("10% off", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH5
        button.isUserInteractionEnabled = false
        button.titleEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        button.alpha = 0
        
        return button
    }()
    
    lazy var durationBottomController: DurationBottomView = {
        let controller = DurationBottomView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
//        controller.delegate = self
        
        return controller
    }()
    
    @objc func setData() {
        let time = Date()
        let greeting = check(time: time)
        
        let name = UserDefaults.standard.string(forKey: "userName") ?? ""
        let nameArray = name.split(separator: " ")
        if nameArray.count > 0 {
            let userName = String(nameArray[0])
            if name != "" {
                greetingLabel.text = "Good \(greeting), \(userName)"
            } else {
                greetingLabel.text = "Good \(greeting)"
            }
        } else {
            greetingLabel.text = "Good \(greeting)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        NotificationCenter.default.addObserver(self, selector: #selector(setData), name: UIApplication.significantTimeChangeNotification, object: nil)
        
        loadingLine.startAnimating()
        
        setData()
        
        setupViews()
        setupSearch()
    }
    
    func setupViews() {
        
        view.addSubview(greetingLabel)
        view.addSubview(mainLabel)
        view.addSubview(searchView)

        greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        greetingLabel.sizeToFit()
        
        mainLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 0).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(discountButton)
        discountButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        discountButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        discountButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        discountButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    }
    
    func setupSearch() {
        
        searchView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        
        searchView.addSubview(searchLabel)
        view.addSubview(recommendationButton)
        searchView.addSubview(searchButton)
        
        searchLabel.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        recommendationButton.leftAnchor.constraint(equalTo: searchLabel.rightAnchor, constant: 4).isActive = true
        recommendationButton.rightAnchor.constraint(lessThanOrEqualTo: searchButton.leftAnchor, constant: -12).isActive = true
        recommendationButton.centerYAnchor.constraint(equalTo: searchLabel.centerYAnchor).isActive = true
        recommendationButton.sizeToFit()
        
        searchButton.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -8).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 10).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        
        searchView.addSubview(loadingLine)
        loadingLine.anchor(top: nil, left: searchView.leftAnchor, bottom: searchView.bottomAnchor, right: searchView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(durationBottomController.view)
        durationBottomController.view.anchor(top: searchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: bottomHeight)

    }
    
    func determineCity(location: CLLocation) {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self.loadingLine.endAnimating()
                mapTutorialController.loadingLine.endAnimating()
                if let city = placemark.subLocality {
                    self.recommendationButton.setTitle(city, for: .normal)
                    mapTutorialController.recommendationButton.setTitle(city, for: .normal)
                    self.city = city
                } else if let city = placemark.locality {
                    self.recommendationButton.setTitle(city, for: .normal)
                    mapTutorialController.recommendationButton.setTitle(city, for: .normal)
                    self.city = city
                }
            }
        })
    }
    
    func check(time: Date) -> String {
        let hour = Calendar.current.component(.hour, from: time)
        
        switch hour {
        case 6..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
        }
    }

}
