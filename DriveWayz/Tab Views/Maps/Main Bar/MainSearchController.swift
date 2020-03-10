//
//  MainSearchController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MainSearchController: UIViewController {
    
    var delegate: MainScreenDelegate?
    var count: Int = 3
    var canPanSearchView: Bool = true
    
    var recentId: [String] = []
    var recentItems: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var matchingItems: [GMSAutocompletePrediction] = []
    var placesClient: GMSPlacesClient?
    
    var centerCoordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = centerCoordinate {
                let camera = GMSCameraPosition(target: coordinate, zoom: mapZoomLevel - 0.5)
                mapView.animate(to: camera)
            }
        }
    }
    
    var finalCoordinate: CLLocationCoordinate2D?
    var shouldMonitor: Bool = true
    var mapPin = MapDropPin()
    
    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.8249, longitude: -122.4194, zoom: 14.0)
        let view = GMSMapView(frame: .zero, camera: camera)
        view.delegate = self
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMyLocationEnabled = false
        view.settings.tiltGestures = false
        view.settings.compassButton = false
        view.settings.rotateGestures = false
        view.padding = UIEdgeInsets(top: statusHeight, left: horizontalPadding, bottom: horizontalPadding, right: horizontalPadding)

        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        button.layer.cornerRadius = 20
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var profileIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "profile_guy1")
        button.setImage(image, for: .normal)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where are you headed?"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
           
        return label
    }()
    
    lazy var fromTextView: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STANDARD_GRAY
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        view.textColor = Theme.BLACK
        view.placeholder = "Current location"
        view.font = Fonts.SSPRegularH4
        view.delegate = self
        view.keyboardAppearance = .dark
        view.tintColor = Theme.BLUE
        view.autocapitalizationType = .words
        view.attributedPlaceholder = NSAttributedString(string: "Current location", attributes: [NSAttributedString.Key.foregroundColor: Theme.GRAY_WHITE_1])

        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 20))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        return view
    }()
    
    lazy var toTextView: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STANDARD_GRAY
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        view.textColor = Theme.BLACK
        view.placeholder = "Address, venue, or airport"
        view.font = Fonts.SSPRegularH4
        view.delegate = self
        view.keyboardAppearance = .dark
        view.tintColor = Theme.BLUE
        view.autocapitalizationType = .words
        view.attributedPlaceholder = NSAttributedString(string: "Address, venue, or airport", attributes: [NSAttributedString.Key.foregroundColor: Theme.GRAY_WHITE_1])

        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 20))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        return view
    }()
    
    var underline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var fromPin: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var toPin: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var joinLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE_3
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SearchDestinationCell.self, forCellReuseIdentifier: "cell")
        view.register(FrequentCell.self, forCellReuseIdentifier: "cell2")
        view.delegate = self
        view.dataSource = self
        view.decelerationRate = .fast
        view.separatorStyle = .none
        view.backgroundColor = Theme.WHITE
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.keyboardDismissMode = .interactive
        view.alpha = 0
        
        return view
    }()
    
    var messageView = SearchMessageView()
    
    var mapBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 45/2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.alpha = 0
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.16
        button.addTarget(self, action: #selector(mapBackButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Move pin to adjust search location"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
           
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var nearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search near"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.alpha = 0
           
        return label
    }()
    
    lazy var searchView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(searchViewPressed), for: .touchUpInside)
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "945 Diamond Street"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "pin_filled")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        placesClient = GMSPlacesClient()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(searchViewPanned))
        view.addGestureRecognizer(pan)
        
        toTextView.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        fromTextView.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleTextChange(_:)), name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil)
        
        setupMap()
        setupViews()
        setupNear()
        
        checkRecentSearches()
        createToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableTopAnchor.constant = 0
        UIView.animateOut(withDuration: animationOut, animations: {
            self.tableView.alpha = 1
            self.backButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.toTextView.becomeFirstResponder()
            delayWithSeconds(animationIn) {
                UIView.animateOut(withDuration: animationOut, animations: {
                    self.messageView.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileIcon.alpha = 0
        tableTopAnchor.constant = 74
        UIView.animateIn(withDuration: animationIn, animations: {
            self.messageView.alpha = 0
            self.greetingLabel.alpha = 0
            self.fromTextView.alpha = 0
            self.toTextView.alpha = 0
            self.joinLine.alpha = 0
            self.backButton.alpha = 0
            self.tableView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    var tableTopAnchor: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    
    func setupMap() {

        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 240, paddingRight: 0, width: 0, height: 0)
        
        mapView.addSubview(mapPin)
        mapPin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapPin.bottomAnchor.constraint(equalTo: mapView.centerYAnchor, constant: 0).isActive = true
        mapPin.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mapPin.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        // Load the map style to be applied to Google Maps
        if let path = Bundle.main.path(forResource: "GoogleMapStyle", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                do {
                    // Set the map style by passing a valid JSON string.
                    if let jsonString = jsonToString(json: jsonResult as AnyObject) {
                        mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            } catch {
                // handle error
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
        
        view.addSubview(container)
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: phoneHeight)
            containerHeightAnchor.isActive = true
        
    }
    
    var underlineBottomAnchor: NSLayoutConstraint!
    var messageBottomAnchor: NSLayoutConstraint!
    var messageKeyboardAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(profileIcon)
        container.addSubview(backButton)
        container.addSubview(greetingLabel)
        
        backButton.anchor(top: container.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        profileIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: -2, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 65, height: 65)
        
        greetingLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 32).isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        greetingLabel.sizeToFit()
        
        container.addSubview(fromTextView)
        container.addSubview(toTextView)
        container.addSubview(underline)
        
        fromTextView.anchor(top: greetingLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        toTextView.anchor(top: fromTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        underline.anchor(top: nil, left: toTextView.leftAnchor, bottom: nil, right: toTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
         underlineBottomAnchor = underline.bottomAnchor.constraint(equalTo: toTextView.bottomAnchor)
             underlineBottomAnchor.isActive = true
        
        fromTextView.addSubview(fromPin)
        toTextView.addSubview(toPin)
        container.addSubview(joinLine)
        
        fromPin.anchor(top: fromTextView.topAnchor, left: fromTextView.leftAnchor, bottom: nil, right: nil, paddingTop: 17, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 6, height: 6)
        
        toPin.anchor(top: toTextView.topAnchor, left: toTextView.leftAnchor, bottom: nil, right: nil, paddingTop: 17, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 6, height: 6)
        
        joinLine.anchor(top: fromPin.bottomAnchor, left: nil, bottom: toPin.topAnchor, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 2, height: 0)
        joinLine.centerXAnchor.constraint(equalTo: fromPin.centerXAnchor).isActive = true
     
        container.addSubview(tableView)
        tableView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableTopAnchor = tableView.topAnchor.constraint(equalTo: toTextView.bottomAnchor, constant: 74)
            tableTopAnchor.isActive = true
        
        container.addSubview(messageView)
        messageView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 100)
        messageBottomAnchor = messageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            messageBottomAnchor.isActive = true
        messageKeyboardAnchor = messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            messageKeyboardAnchor.isActive = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideSearchMessage))
        messageView.addGestureRecognizer(tap)
        
    }
    
    var searchTopAnchor: NSLayoutConstraint!
    
    func setupNear() {
        
        view.addSubview(mapBackButton)
        mapBackButton.anchor(top: nil, left: view.leftAnchor, bottom: container.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 45, height: 45)
        
        container.addSubview(informationLabel)
        container.addSubview(line)
        container.addSubview(nearLabel)
        
        informationLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        line.anchor(top: informationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        nearLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        nearLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nearLabel.sizeToFit()
        
        container.addSubview(searchView)
        searchView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 60)
        searchTopAnchor = searchView.topAnchor.constraint(equalTo: nearLabel.bottomAnchor, constant: 36)
            searchTopAnchor.isActive = true
        
        searchView.addSubview(searchLabel)
        searchView.addSubview(searchButton)
        
        searchButton.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 16).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        
        searchLabel.leftAnchor.constraint(equalTo: searchButton.rightAnchor, constant: 16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        container.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    @objc func hideSearchMessage() {
        messageKeyboardAnchor.isActive = false
        messageBottomAnchor.isActive = true
        UIView.animateOut(withDuration: animationIn, animations: {
            self.messageView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func searchViewPressed() {
        toTextView.text = searchLabel.text
        toTextView.sendActions(for: .editingChanged)
        hideMap(edit: true)
    }
    
    func showMap() {
        canPanSearchView = false
        view.endEditing(true)
        containerHeightAnchor.constant = 300
        UIView.animateOut(withDuration: animationOut, animations: {
            self.changeAlphaSearch(percent: 1)
            self.mapBackButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.zoomMap(zoomIn: true)
            self.view.endEditing(true)
            delayWithSeconds(animationOut) {
                self.changeAlphaNear(alpha: 1)
                self.tableView.isScrollEnabled = false
            }
        }
    }
    
    func zoomMap(zoomIn: Bool) {
        if let coordinate = centerCoordinate {
            CATransaction.begin()
            CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
            if zoomIn {
                let camera = GMSCameraPosition(target: coordinate, zoom: mapZoomLevel)
                mapView.animate(to: camera)
            } else {
                let camera = GMSCameraPosition(target: coordinate, zoom: mapZoomLevel - 0.5)
                mapView.camera = camera
            }
            CATransaction.commit()
        }
    }
    
    func hideMap(edit: Bool) {
        canPanSearchView = false
        tableView.isScrollEnabled = false
        changeAlphaNear(alpha: 0)
        containerHeightAnchor.constant = phoneHeight
        UIView.animateOut(withDuration: animationOut, animations: {
            self.mapBackButton.alpha = 0
            self.mainButton.alpha = 0
            self.searchView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animateOut(withDuration: animationOut, animations: {
                self.profileIcon.layer.shadowOpacity = 0
                self.changeAlphaSearch(percent: 0)
            }) { (success) in
                self.zoomMap(zoomIn: false)
                if edit { self.toTextView.becomeFirstResponder() }
                self.canPanSearchView = true
                self.tableView.isScrollEnabled = true
            }
        }
    }
    
    func changeAlphaSearch(percent: CGFloat) {
        backButton.alpha = 1 - 1 * percent
        greetingLabel.alpha = 1 - 1 * percent
        fromTextView.alpha = 1 - 1 * percent
        toTextView.alpha = 1 - 1 * percent
        joinLine.alpha = 1 - 1 * percent
        tableView.alpha = 1 - 1 * percent
        underline.alpha = 1 - 1 * percent
    }
    
    func changeAlphaNear(alpha: CGFloat) {
        if alpha == 1 { searchTopAnchor.constant = 16 } else { searchTopAnchor.constant = 36 }
        UIView.animateOut(withDuration: animationOut, animations: {
            self.informationLabel.alpha = alpha
            self.line.alpha = alpha
            self.nearLabel.alpha = alpha
            self.searchView.alpha = alpha
            if alpha == 1 { self.profileIcon.layer.shadowOpacity = 0.16 } else { self.profileIcon.layer.shadowOpacity = 0 }
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animateOut(withDuration: animationOut, animations: {
                self.mainButton.alpha = alpha
            }, completion: nil)
        }
    }
    
    @objc func mainButtonPressed() {
        delegate?.openBookings() // NEED TO DETERMINE LOCATION
        hideMap(edit: false)
        backButtonPressed()
    }

    @objc func mapBackButtonPressed() {
        hideMap(edit: true)
    }
    
    @objc func backButtonPressed() {
        delegate?.closeMainScreen()
        modalTransitionStyle = .coverVertical
        dismiss(animated: true, completion: nil)
    }

}

extension MainSearchController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapPin.placePin()
        
        if shouldMonitor {
            let x = mapPin.center.x
            let y = mapPin.frame.maxY
            let point = CGPoint(x: x, y: y)
            
            let coordinate = mapView.projection.coordinate(for: point)
            finalCoordinate = coordinate
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            lookUpLocation(location: location) { (placemark) in
                if let address = placemark?.postalAddress?.street {
                    self.searchLabel.text = address
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapPin.pinMoving()
        searchLabel.text = "Loading..."
    }
    
    func lookUpLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
             // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
    
}
