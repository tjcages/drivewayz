//
//  LocationServicesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class LocationServicesViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.8249, longitude: -122.4194), latitudinalMeters: 22000, longitudinalMeters: 22000)
        view.setRegion(region, animated: false)
        
        return view
    }()
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH1
        label.text = "Location Services"
        
        return label
    }()
    
    var secondaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH3
        label.text = "Drivewayz would like to access your location to provide parking for you faster and simpler."
        label.numberOfLines = 3
        
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Allow", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(checkLocationServices), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        
        return button
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulse, color: Theme.WHITE, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.alpha = 0
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    var allowPressed: Bool = false
    var shouldSendSettings: Bool = false
    
    func setupViews() {
        
        self.view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.view.addSubview(viewContainer)
        viewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        viewContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        viewContainer.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 120).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        viewContainer.addSubview(secondaryLabel)
        secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20).isActive = true
        secondaryLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        secondaryLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -60).isActive = true
        secondaryLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        loadingActivity.bottomAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: -20).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 120).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
        createToolbar()
        
    }
    
    func createToolbar() {
        
        self.view.addSubview(nextButton)
        nextButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        nextButton.topAnchor.constraint(equalTo: loadingActivity.bottomAnchor, constant: 48).isActive = true
        nextButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 36).isActive = true
        nextButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -36).isActive = true
        
    }

}


extension LocationServicesViewController: CLLocationManagerDelegate {
    
    @objc func checkLocationServices() {
        UIView.animate(withDuration: animationIn) {
            self.loadingActivity.alpha = 1
            self.mainLabel.alpha = 0
            self.secondaryLabel.alpha = 0
            self.nextButton.alpha = 0
        }
        self.loadingActivity.startAnimating()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if self.allowPressed == true {
                    if self.shouldSendSettings == true {
                        if let url = NSURL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        }
                    } else {
                        self.shouldSendSettings = true
                        self.secondaryLabel.text = "Please enable location services before using Drivewayz"
                        self.view.layoutIfNeeded()
                        UIView.animate(withDuration: animationIn) {
                            self.loadingActivity.alpha = 0
                            self.loadingActivity.stopAnimating()
                            self.mainLabel.alpha = 1
                            self.secondaryLabel.alpha = 1
                        }
                    }
                }
            case .authorizedAlways, .authorizedWhenInUse:
                self.moveToMainController()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    self.loadingActivity.alpha = 0
                    self.loadingActivity.stopAnimating()
                }
            default:
                fatalError()
            }
            self.loadingActivity.alpha = 0
            self.loadingActivity.stopAnimating()
        } else {
            if let url = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        self.allowPressed = true
    }
    
    func moveToMainController() {
        let controller = TabViewController()
        controller.delegate = LaunchAnimationsViewController()
        controller.modalTransitionStyle = .crossDissolve

        self.present(controller, animated: true) {
            self.view.endEditing(true)
            controller.view.endEditing(true)
            
            controller.bringHamburger()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if self.allowPressed == true {
            self.checkLocationServices()
        }
    }
    
}
