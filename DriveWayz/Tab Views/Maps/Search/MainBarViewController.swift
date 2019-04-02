//
//  MainBarViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/31/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MainBarViewController: UIViewController {
    
    var alreadyFoundParking: Bool = false
    var alreadyZoomedIn: Bool = true
    var fullSearchOpen: Bool = false
    var delegate: mainBarSearchDelegate?
    
    enum ParkingState {
        case foundParking
        case noParking
        case zoomIn
    }
    
    var shouldBeLoading: Bool = true
    var shouldRefresh: Bool = true
    var parkingState: ParkingState = .foundParking {
        didSet {
            if parkingState == .foundParking && self.alreadyFoundParking == false {
                self.alreadyFoundParking = true
                self.endSearching(status: parkingState)
                delayWithSeconds(0.4) {
                    self.alreadyZoomedIn = false
                }
            } else if parkingState == .zoomIn && self.alreadyZoomedIn == false {
                self.alreadyZoomedIn = true
                self.endSearching(status: parkingState)
                delayWithSeconds(0.4) {
                    self.alreadyFoundParking = false
                }
            } else if parkingState == .noParking && self.shouldRefresh == true {
                self.shouldRefresh = false
                self.endSearching(status: parkingState)
                delayWithSeconds(0.4) {
                    self.alreadyFoundParking = false
                    self.alreadyZoomedIn = false
                    delayWithSeconds(2, completion: {
                        self.shouldRefresh = true
                    })
                }
            }
        }
    }
    
    var searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "locationArrow")
        button.setImage(image, for: .normal)
        //        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.8
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var searchLabel: UITextField = {
        let label = UITextField()
        label.text = "Where are you headed?"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var couponLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "Park today and receive 10% off!"
        label.font = Fonts.SSPRegularH6
        label.alpha = 0
        
        return label
    }()
    
    var couponButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "saleIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.alpha = 0
        
        return button
    }()
    
    var searchBackButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var fromSearchBar: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Current location"
        view.textColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.8)
        view.font = Fonts.SSPRegularH3
        view.clearButtonMode = .never
        view.alpha = 0
        view.isUserInteractionEnabled = false ////////////////////////////NEED TO FIX
        view.alpha = 0
        
        return view
    }()
    
    var searchLocation: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchLocation")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var fromSearchIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.borderColor = Theme.BLUE.cgColor
        view.layer.borderWidth = 5
        view.layer.cornerRadius = 8
        view.alpha = 0
        
        return view
    }()
    
    var fromSearchLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.alpha = 0
        
        let dot1 = UIView(frame: CGRect(x: 0, y: 8.2, width: 4, height: 4))
        dot1.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        dot1.layer.cornerRadius = 2
        view.addSubview(dot1)
        
        let dot2 = UIView(frame: CGRect(x: 0, y: 20.4, width: 4, height: 4))
        dot2.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        dot2.layer.cornerRadius = 2
        view.addSubview(dot2)
        
        let dot3 = UIView(frame: CGRect(x: 0, y: 32.6, width: 4, height: 4))
        dot3.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        dot3.layer.cornerRadius = 2
        view.addSubview(dot3)
        
        return view
    }()
    
    var fromSearchLocation: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "locator")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(searchLocationPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchLabel.delegate = self

        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        
        setupViews()
        setupSearch()
        loadingParking()
    }
    
    var mainBarTopAnchor: NSLayoutConstraint!
    
    var searchBarHeightAnchor: NSLayoutConstraint!
    var loadingParkingLeftAnchor: NSLayoutConstraint!
    var loadingParkingRightAnchor: NSLayoutConstraint!
    var loadingParkingWidthAnchor: NSLayoutConstraint!
    var loadingParkingHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(searchBarView)
        mainBarTopAnchor = searchBarView.topAnchor.constraint(equalTo: self.view.topAnchor)
            mainBarTopAnchor.isActive = true
        searchBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        searchBarView.widthAnchor.constraint(equalToConstant: 327).isActive = true
        searchBarHeightAnchor = searchBarView.heightAnchor.constraint(equalToConstant: 63)
            searchBarHeightAnchor.isActive = true
        
        searchBarView.addSubview(searchButton)
        searchButton.leftAnchor.constraint(equalTo: searchBarView.leftAnchor, constant: 16).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchBarView.topAnchor, constant: 31.5).isActive = true
        
        searchBarView.addSubview(searchLabel)
        searchLabel.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchLabel.leftAnchor.constraint(equalTo: searchBarView.leftAnchor, constant: 52).isActive = true
        searchLabel.rightAnchor.constraint(equalTo: searchBarView.rightAnchor, constant: -12).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        searchLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchBarView.addSubview(searchLine)
        loadingParkingHeightAnchor = searchLine.heightAnchor.constraint(equalToConstant: 3)
            loadingParkingHeightAnchor.isActive = true
        searchLine.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor).isActive = true
        loadingParkingLeftAnchor = searchLine.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            loadingParkingLeftAnchor.isActive = true
        loadingParkingRightAnchor = searchLine.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            loadingParkingRightAnchor.isActive = false
        loadingParkingWidthAnchor = searchLine.widthAnchor.constraint(equalToConstant: 0)
            loadingParkingWidthAnchor.isActive = true

        searchBarView.addSubview(couponLabel)
        couponLabel.leftAnchor.constraint(equalTo: searchBarView.leftAnchor, constant: 12).isActive = true
        couponLabel.centerYAnchor.constraint(equalTo: searchLine.centerYAnchor).isActive = true
        couponLabel.rightAnchor.constraint(equalTo: searchBarView.rightAnchor, constant: -12).isActive = true
        couponLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        searchBarView.addSubview(couponButton)
        couponButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        couponButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        couponButton.rightAnchor.constraint(equalTo: searchBarView.rightAnchor, constant: -4).isActive = true
        couponButton.centerYAnchor.constraint(equalTo: couponLabel.centerYAnchor).isActive = true
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchBarTapped))
//        searchBarView.addGestureRecognizer(tapGesture)
        
    }
    
    var fromSeachTopAnchor: NSLayoutConstraint!
    
    func setupSearch() {
        
        self.view.addSubview(searchLocation)
        let width: CGFloat = (self.view.frame.width - 300)/2
        searchLocation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -width).isActive = true
        searchLocation.centerYAnchor.constraint(equalTo: searchLabel.centerYAnchor).isActive = true
        searchLocation.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchLocation.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        self.view.addSubview(searchBackButton)
        searchBackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchBackButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        searchBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            searchBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        case .iphoneX:
            searchBackButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        }
        
        self.view.addSubview(fromSearchBar)
        self.view.addSubview(fromSearchLocation)
        fromSearchBar.leftAnchor.constraint(equalTo: searchLabel.leftAnchor).isActive = true
        fromSearchBar.rightAnchor.constraint(equalTo: fromSearchLocation.leftAnchor, constant: -4).isActive = true
        fromSeachTopAnchor = fromSearchBar.bottomAnchor.constraint(equalTo: searchLabel.topAnchor, constant: -10)
            fromSeachTopAnchor.isActive = true
        fromSearchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fromSearchBar.addSubview(fromSearchIcon)
        fromSearchIcon.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor).isActive = true
        fromSearchIcon.centerYAnchor.constraint(equalTo: fromSearchBar.centerYAnchor).isActive = true
        fromSearchIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        fromSearchIcon.widthAnchor.constraint(equalTo: fromSearchIcon.heightAnchor).isActive = true
        
        fromSearchBar.addSubview(fromSearchLine)
        fromSearchBar.bringSubviewToFront(fromSearchIcon)
        fromSearchLine.centerXAnchor.constraint(equalTo: searchButton.centerXAnchor).isActive = true
        fromSearchLine.topAnchor.constraint(equalTo: fromSearchIcon.bottomAnchor).isActive = true
        fromSearchLine.widthAnchor.constraint(equalToConstant: 4).isActive = true
        fromSearchLine.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        fromSearchLocation.centerXAnchor.constraint(equalTo: searchLocation.centerXAnchor).isActive = true
        fromSearchLocation.centerYAnchor.constraint(equalTo: fromSearchBar.centerYAnchor).isActive = true
        fromSearchLocation.widthAnchor.constraint(equalToConstant: 26).isActive = true
        fromSearchLocation.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
    }
    
    func loadingParking() {
        if shouldBeLoading == true {
            self.loadingParkingHeightAnchor.constant = 3
            self.searchBarHeightAnchor.constant = 63
            self.loadingParkingWidthAnchor.constant = 100
            UIView.animate(withDuration: 0.4, animations: {
                self.searchLine.backgroundColor = Theme.BLACK
                self.couponLabel.alpha = 0
                self.couponButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.loadingParkingLeftAnchor.isActive = false
                self.loadingParkingRightAnchor.isActive = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    self.loadingParkingWidthAnchor.constant = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        self.loadingParkingLeftAnchor.isActive = true
                        self.loadingParkingRightAnchor.isActive = false
                        self.view.layoutIfNeeded()
                        self.loadingParking()
                    })
                })
            }
        }
    }
    
    func endSearching(status: ParkingState) {
        self.shouldBeLoading = false
        self.loadingParkingHeightAnchor.constant = 3
        self.searchBarHeightAnchor.constant = 63
        self.loadingParkingWidthAnchor.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.searchLine.backgroundColor = Theme.BLACK
            self.couponLabel.alpha = 0
            self.couponButton.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.loadingParkingLeftAnchor.isActive = true
            self.loadingParkingRightAnchor.isActive = false
            self.view.layoutIfNeeded()
            self.loadingParkingWidthAnchor.constant = 100
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.loadingParkingLeftAnchor.isActive = true
                self.loadingParkingRightAnchor.isActive = true
                self.loadingParkingWidthAnchor.constant = 327
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    self.loadingParkingHeightAnchor.constant = 26
                    self.searchBarHeightAnchor.constant = 89
                    if status == .foundParking {
                        self.foundParking()
                    } else if status == .noParking {
                        self.noParking()
                    } else if status == .zoomIn {
                        self.zoomIn()
                    }
                })
            }
        })
    }
    
    func foundParking() {
        print("found")
        let image = UIImage(named: "saleIcon")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        UIView.animate(withDuration: animationOut, animations: {
            self.couponLabel.text = "Park today and receive 10% off!"
            self.couponButton.setImage(tintedImage, for: .normal)
            self.searchLine.backgroundColor = Theme.LIGHT_BLUE
            self.couponLabel.alpha = 1
            self.couponButton.alpha = 0.8
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func noParking() {
        print("none")
        let image = UIImage(named: "Home")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        UIView.animate(withDuration: animationOut, animations: {
            self.couponLabel.text = "There is currently no parking in this area"
            self.couponButton.setImage(tintedImage, for: .normal)
            self.searchLine.backgroundColor = Theme.STRAWBERRY_PINK.withAlphaComponent(0.9)
            self.couponLabel.alpha = 1
            self.couponButton.alpha = 0.8
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func zoomIn() {
        print("zoom")
        let image = UIImage(named: "locator")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        UIView.animate(withDuration: animationOut, animations: {
            self.couponLabel.text = "Zoom in to find available parking spots"
            self.couponButton.setImage(tintedImage, for: .normal)
            self.searchLine.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.5)
            self.couponLabel.alpha = 1
            self.couponButton.alpha = 0.8
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }

    @objc func searchBarTapped() {
        if fullSearchOpen == false {
            self.openSearchBar()
        } else {
            self.closeSearchBar()
        }
    }
    
    func openSearchBar() {
        self.shouldRefresh = false
        self.fullSearchOpen = true
        self.delegate?.mainBarWillOpen()
        self.searchBarHeightAnchor.constant = 63
        UIView.animate(withDuration: animationIn, animations: {
            UIView.animate(withDuration: animationOut) {
                self.view.backgroundColor = Theme.WHITE
                self.searchBackButton.alpha = 1
                self.searchLine.alpha = 0
                self.view.layoutIfNeeded()
            }
        }) { (success) in
            switch device {
            case .iphone8:
                self.mainBarTopAnchor.constant = 116
            case .iphoneX:
                self.mainBarTopAnchor.constant = 136
            }
            UIView.animate(withDuration: animationOut) {
                self.fromSearchBar.alpha = 1
                self.searchLocation.alpha = 0.1
                self.fromSearchIcon.alpha = 1
                self.fromSearchLine.alpha = 1
                self.fromSearchLocation.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func closeSearchBar() {
        self.view.endEditing(true)
        self.shouldRefresh = true
        self.fullSearchOpen = false
        self.delegate?.mainBarWillClose()
        self.searchBarHeightAnchor.constant = 89
        self.searchLabel.text = "Where are you headed?"
        UIView.animate(withDuration: animationIn, animations: {
            UIView.animate(withDuration: animationOut) {
                self.fromSearchBar.alpha = 0
                self.searchLocation.alpha = 0
                self.fromSearchIcon.alpha = 0
                self.fromSearchLine.alpha = 0
                self.fromSearchLocation.alpha = 0
                self.searchBackButton.alpha = 0
                self.view.layoutIfNeeded()
            }
        }) { (success) in
            self.mainBarTopAnchor.constant = 0
            UIView.animate(withDuration: animationOut) {
                self.view.backgroundColor = UIColor.clear
                self.searchLine.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
}


extension MainBarViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fromSearchBar && fromSearchBar.text == "Current location" {
            self.fromSearchBar.text = ""
            self.fromSearchBar.textColor = Theme.BLACK
            return true
        } else if textField == self.searchLabel && self.searchBarHeightAnchor.constant != 89 {
            return true
        } else {
            self.searchBarTapped()
            self.delegate?.expandSearchBar()
            return false
        }
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text":textField.text!])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
        self.searchLabel.becomeFirstResponder()
    }
    
}

