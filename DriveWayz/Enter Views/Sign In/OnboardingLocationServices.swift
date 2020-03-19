//
//  OnboardingLocationServices.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 1/30/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit
import CoreLocation

class OnboardingLocationServices: UIViewController {

    var delegate: NameDelegate?
    var locationManager: CLLocationManager?
    
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    let loadingline = DashingLine()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Turn on Location Services", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz needs your location \nenabled to work properly."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.alpha = 0
        label.numberOfLines = 2
        
        return label
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Allow Location Services"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH25
        label.alpha = 0
        
        return label
    }()
    
    var mapIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Map_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimmingView.addGestureRecognizer(tap2)
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.informationLabel.alpha = 1
            self.mainLabel.alpha = 1
        }) { (success) in
            //
        }
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    var tableViewHeight: NSLayoutConstraint!
    var containerTopAnchor: NSLayoutConstraint!
    var emptyContainerTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        view.addSubview(pullButton)
        view.addSubview(dimmingView)
        
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        container.addSubview(mainButton)
        container.addSubview(informationLabel)
        container.addSubview(mainLabel)
        container.addSubview(mapIllustration)
        
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        profitsBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            profitsBottomAnchor.isActive = true
        
        informationLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -64).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        informationLabel.sizeToFit()
        
        mainLabel.bottomAnchor.constraint(equalTo: informationLabel.topAnchor, constant: -8).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        mainLabel.sizeToFit()
        
        let height = mapIllustration.image.size.height/mapIllustration.image.size.width * phoneWidth
        mapIllustration.anchor(top: nil, left: view.leftAnchor, bottom: mainLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, width: 0, height: height)
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mapIllustration.topAnchor).isActive = true
        
        view.layoutIfNeeded()
        
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.profitsBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func mainButtonPressed() {
        if mainButton.backgroundColor == Theme.BLACK {
            locationManager?.requestWhenInUseAuthorization()
            UIView.animateOut(withDuration: animationIn, animations: {
                self.dimmingView.alpha = 0.4
            }, completion: nil)
        } else {
            if let url = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func successfulSignIn() {
        delayWithSeconds(animationOut) {
            self.loadingline.endAnimate()
            self.delegate?.successfulSignIn()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func locationRestricted() {
        loadingline.endAnimate()
        mainButton.backgroundColor = Theme.LINE_GRAY
        mainButton.setTitle("Go to Settings", for: .normal)
        mainButton.setTitleColor(Theme.BLACK, for: .normal)
    }
    
    @objc func dismissView() {
        delegate?.closeBackground()
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension OnboardingLocationServices: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            let y = phoneHeight - container.frame.height + mapIllustration.frame.height + 80
            loadingline.position = CGPoint(x: 0, y: y)
            view.layer.addSublayer(loadingline)
            loadingline.animate()
        } else if status == .notDetermined {
            mainButton.backgroundColor = Theme.BLACK
            mainButton.setTitle("Turn on Location Services", for: .normal)
            mainButton.setTitleColor(Theme.WHITE, for: .normal)
        }
        UIView.animateOut(withDuration: animationIn, animations: {
            self.dimmingView.alpha = 0
        }) { (success) in
            switch status {
            case .notDetermined:
                print("Location Not Determined")
            case .restricted, .denied:
                self.locationRestricted()
            case .authorizedAlways, .authorizedWhenInUse:
                self.successfulSignIn()
            default:
                print("Verify Number Failed to login")
            }
        }
    }
    
}
