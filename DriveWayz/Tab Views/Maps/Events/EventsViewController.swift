//
//  EventsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/14/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import MapKit

var eventsAreAllowed: Bool = false

class EventsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    let identifier = "identifier"
    let locationManager = CLLocationManager()
    var localEvents: [LocalEvents] = []
    lazy var cellWidth: CGFloat = 240
    lazy var cellHeight: CGFloat = 140
    var costParking: String = "$4.50"
    var hrefEvent: String = ""
    var delegate: handleEventSelection?
    
    var eventsLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    var smallEventsLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        
        return layout
    }()
    
    lazy var eventsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: eventsLayout)
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.WHITE
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(EventCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        
        return picker
    }()

    lazy var smallEventsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: smallEventsLayout)
        picker.backgroundColor = Theme.WHITE
        picker.tintColor = Theme.WHITE
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(EventCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.alpha = 0

        return picker
    }()
    
    var specificEventView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        return view
    }()
    
    lazy var stillView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        let background = CAGradientLayer().mediumBlurColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        background.zPosition = -10
        view.layer.addSublayer(background)
        
        return view
    }()
    
    var fullBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    var specificImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    let specificEventLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.isScrollEnabled = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Event"
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    var specificEventDate: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPLightH3
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var specificEventVenue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.SSPRegularH3
        label.textColor = Theme.BLACK
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    var specificParking: UITextView = {
        let label = UITextView()
        label.text = ""
        label.font = Fonts.SSPLightH3
        label.textColor = Theme.BLACK
        label.isEditable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    var checkoutDrivewayz: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SEA_BLUE
        button.setTitle("Find a spot", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(findEventParking), for: .touchUpInside)
        
        return button
    }()
    
    var orLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var ticketMaster: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Purchase on Ticketmaster", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(openTicketMasterSite), for: .touchUpInside)
        
        return button
    }()
    
    var seeMoreLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Show venue details", for: .normal)
        button.setTitleColor(Theme.PURPLE.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(seeMorePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var venueParking: UITextView = {
        let label = UITextView()
        label.text = ""
        label.font = Fonts.SSPLightH4
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        label.isEditable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.alpha = 0
        
        return label
    }()
    
    var slideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.7)
        view.alpha = 0.9
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        eventsPicker.delegate = self
        eventsPicker.dataSource = self
        smallEventsPicker.delegate = self
        smallEventsPicker.dataSource = self
        locationManager.delegate = self
        
        checkEvents()
        setupViews()
    }
    
    var eventsPickerHeightAnchor: NSLayoutConstraint!
    var eventImageWidthAnchor: NSLayoutConstraint!
    var eventLabelHeightAnchor: NSLayoutConstraint!
    var venueParkingHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(stillView)
        stillView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stillView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stillView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stillView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(fullBackgroundView)
        fullBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fullBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        fullBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        fullBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.view.addSubview(eventsPicker)
        eventsPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        eventsPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        eventsPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        eventsPickerHeightAnchor = eventsPicker.heightAnchor.constraint(equalToConstant: 150)
            eventsPickerHeightAnchor.isActive = true
        
        self.view.addSubview(specificEventView)
        specificEventView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        specificEventView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        specificEventView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        specificEventView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 180).isActive = true
        
        specificEventView.addSubview(scrollView)
        specificEventView.addSubview(checkoutDrivewayz)
        scrollView.contentSize = CGSize.zero
        scrollView.leftAnchor.constraint(equalTo: specificEventView.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: specificEventView.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: checkoutDrivewayz.topAnchor, constant: -4).isActive = true
        scrollView.topAnchor.constraint(equalTo: specificEventView.topAnchor).isActive = true
        
        specificEventView.addSubview(smallEventsPicker)
        smallEventsPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        smallEventsPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        smallEventsPicker.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        smallEventsPicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(specificImageView)
        specificImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        specificImageView.rightAnchor.constraint(equalTo: specificEventView.rightAnchor, constant: -8).isActive = true
        eventImageWidthAnchor = specificImageView.widthAnchor.constraint(equalToConstant: 140)
            eventImageWidthAnchor.isActive = true
        specificImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        scrollView.addSubview(specificEventLabel)
        specificEventLabel.topAnchor.constraint(equalTo: specificImageView.bottomAnchor, constant: -4).isActive = true
        specificEventLabel.leftAnchor.constraint(equalTo: specificEventView.leftAnchor, constant: 12).isActive = true
        specificEventLabel.rightAnchor.constraint(equalTo: specificEventView.rightAnchor, constant: -48).isActive = true
        eventLabelHeightAnchor = specificEventLabel.heightAnchor.constraint(equalToConstant: 40)
            eventLabelHeightAnchor.isActive = true
        
        scrollView.addSubview(specificEventVenue)
        specificEventVenue.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        specificEventVenue.leftAnchor.constraint(equalTo: specificEventView.leftAnchor, constant: 16).isActive = true
        specificEventVenue.rightAnchor.constraint(equalTo: specificImageView.leftAnchor, constant: -12).isActive = true
        specificEventVenue.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(specificEventDate)
        specificEventDate.topAnchor.constraint(equalTo: specificEventVenue.bottomAnchor, constant: 0).isActive = true
        specificEventDate.leftAnchor.constraint(equalTo: specificEventView.leftAnchor, constant: 16).isActive = true
        specificEventDate.rightAnchor.constraint(equalTo: specificImageView.leftAnchor, constant: 0).isActive = true
        specificEventDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(specificParking)
        specificParking.leftAnchor.constraint(equalTo: specificEventView.leftAnchor, constant: 14).isActive = true
        specificParking.rightAnchor.constraint(equalTo: specificEventView.rightAnchor, constant: -14).isActive = true
        specificParking.topAnchor.constraint(equalTo: specificEventLabel.bottomAnchor, constant: -10).isActive = true
        specificParking.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        scrollView.addSubview(seeMoreLabel)
        seeMoreLabel.leftAnchor.constraint(equalTo: specificEventView.leftAnchor, constant: 18).isActive = true
        seeMoreLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        seeMoreLabel.topAnchor.constraint(equalTo: specificParking.bottomAnchor, constant: 10).isActive = true
        seeMoreLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(venueParking)
        venueParking.leftAnchor.constraint(equalTo: specificEventView.leftAnchor, constant: 14).isActive = true
        venueParking.rightAnchor.constraint(equalTo: specificEventView.rightAnchor, constant: -14).isActive = true
        venueParking.topAnchor.constraint(equalTo: seeMoreLabel.bottomAnchor, constant: 10).isActive = true
        venueParkingHeightAnchor = venueParking.heightAnchor.constraint(equalToConstant: 80)
            venueParkingHeightAnchor.isActive = true
        
        specificEventView.addSubview(ticketMaster)
        ticketMaster.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        ticketMaster.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        ticketMaster.bottomAnchor.constraint(equalTo: smallEventsPicker.topAnchor, constant: -5).isActive = true
        ticketMaster.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        specificEventView.addSubview(orLine)
        orLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        orLine.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        orLine.bottomAnchor.constraint(equalTo: ticketMaster.topAnchor, constant: -5).isActive = true
        orLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        checkoutDrivewayz.centerXAnchor.constraint(equalTo: specificEventView.centerXAnchor).isActive = true
        checkoutDrivewayz.widthAnchor.constraint(equalToConstant: 240).isActive = true
        checkoutDrivewayz.bottomAnchor.constraint(equalTo: orLine.topAnchor, constant: -20).isActive = true
        checkoutDrivewayz.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        specificEventView.addSubview(slideView)
        slideView.centerXAnchor.constraint(equalTo: specificEventView.centerXAnchor).isActive = true
        slideView.bottomAnchor.constraint(equalTo: specificEventView.topAnchor, constant: -8).isActive = true
        slideView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        slideView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTouched))
        fullBackgroundView.addGestureRecognizer(tapGesture)
        
    }
    
    func checkEvents() {
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        var localEvents: [LocalEvents] = []
        var testEvents: [String] = []
        var dateEvents: [Double] = []
        let latlong = "\(location.latitude),\(location.longitude)"
        LocalEvents.eventLookup(withLocation: latlong) { (results: [LocalEvents]) in
            for result in results {
                let date = self.formattDate(date: result.date, time: result.time, type: "dotDate")
                let timestamp = self.getTimestamp(date: result.date, time: result.time)
                if !testEvents.contains(result.name) && date != "" {
                    testEvents.append(result.name)
                    localEvents.append(result)
                    dateEvents.append(timestamp)
                }
            }
            let combined = zip(dateEvents, localEvents).sorted {$0.0 < $1.0}
            let sortedEvents = combined.map {$0.1}
            self.localEvents = sortedEvents
            if localEvents.count > 0 {
                DispatchQueue.main.async {
                    self.eventsPicker.reloadData()
                    self.smallEventsPicker.reloadData()
                    eventsAreAllowed = true
                    self.delegate?.eventsControllerHidden()
                    self.view.layoutIfNeeded()
                }
            }
        }
        fetchCityAndState(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) { (city, state, err) in
            guard let city = city, let state = state, err == nil else { return }
            self.configureCustomPricing(state: state, city: city)
        }
    }
    
    func configureCustomPricing(state: String, city: String) {
        let ref = Database.database().reference().child("CostLocations")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let cities = dictionary["\(state)"] as? [String:AnyObject] {
                    for cit in cities {
                        let key = cit.key
                        if key == city {
                            if let cost = cit.value as? Double {
                                self.costParking = "$\(cost)0"
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchCityAndState(from location: CLLocation, completion: @escaping (_ city: String?, _ state:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.administrativeArea,
                       error)
        }
    }
    
    @objc func seeMorePressed(sender: UIButton) {
        UIView.animate(withDuration: animationIn) {
            if self.venueParking.alpha == 1 {
                self.scrollView.contentSize = CGSize.zero
                self.seeMoreLabel.setTitle("Show venue details", for: .normal)
                self.venueParking.alpha = 0
            } else {
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 180 + self.venueParking.text.height(withConstrainedWidth: self.view.frame.width - 24, font: Fonts.SSPLightH4))
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.view.frame.height - 410)
                self.seeMoreLabel.setTitle("Hide venue details", for: .normal)
                self.venueParking.alpha = 1
            }
        }
    }
    
    @objc func backgroundTouched() {
        self.delegate?.closeSpecificEvent()
        UIView.animate(withDuration: animationOut, animations: {
            self.smallEventsPicker.alpha = 0
            self.eventsPickerHeightAnchor.constant = 150
            self.eventsPicker.alpha = 1
            self.specificEventView.alpha = 0
            self.fullBackgroundView.alpha = 0
            self.scrollView.contentSize = CGSize.zero
            self.seeMoreLabel.setTitle("Show venue details", for: .normal)
            self.venueParking.alpha = 0
            self.seeMoreLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.localEvents.count == 0 {
            return 1
        } else {
            return self.localEvents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == eventsPicker {
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            return CGSize(width: 70, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == eventsPicker {
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! EventCell
        if collectionView == eventsPicker {
            if localEvents.count == 0 {
                cell.eventLabel.text = "Event"
                cell.date.text = ""
                return cell
            }
            let venueImage = localEvents[indexPath.row].venueImageURL
            if venueImage != "" {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(venueImage)
                cell.image = cell.backgroundImageView.image
            } else {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(localEvents[indexPath.row].imageURL)
                cell.image = cell.backgroundImageView.image
            }
            cell.eventLabel.text = localEvents[indexPath.row].name
            cell.date.text = formattDate(date: localEvents[indexPath.row].date, time: localEvents[indexPath.row].time, type: "dotDate")
            cell.darkView.alpha = 0.6
            cell.layoutIfNeeded()
            
            return cell
        } else {
            if localEvents.count == 0 {
                cell.eventLabel.text = ""
                cell.date.text = ""
                return cell
            }
            let venueImage = localEvents[indexPath.row].venueImageURL
            if venueImage != "" {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(venueImage)
                cell.image = cell.backgroundImageView.image
            } else {
                cell.backgroundImageView.loadImageUsingCacheWithUrlString(localEvents[indexPath.row].imageURL)
                cell.image = cell.backgroundImageView.image
            }
            cell.eventLabel.text = ""
            cell.date.text = ""
            cell.darkView.alpha = 0
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.openSpecificEvent()
        self.hrefEvent = self.localEvents[indexPath.row].hrefEvent
        self.specificImageView.loadImageUsingCacheWithUrlString(self.localEvents[indexPath.row].imageURL)
        self.specificEventDate.text = self.formattDate(date: self.localEvents[indexPath.row].date, time: self.localEvents[indexPath.row].time, type: "regularDate")
        self.specificEventVenue.text = self.localEvents[indexPath.row].venueName.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)", with: "", options: .regularExpression)
        self.checkParkingOptions(text: self.localEvents[indexPath.row].venueParking)
        if let width = self.specificImageView.image?.size.width, let height = self.specificImageView.image?.size.height {
            let scale = width / height
            self.eventImageWidthAnchor.constant = scale * 100
        }
        self.specificEventLabel.text = self.localEvents[indexPath.row].name
        self.eventLabelHeightAnchor.constant = self.specificEventLabel.text.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPSemiBoldH2) + 20
        UIView.animate(withDuration: animationIn, animations: {
            self.venueParking.alpha = 0
            self.scrollView.contentSize = .zero
            self.fullBackgroundView.alpha = 0.4
            self.specificEventView.alpha = 1
            self.eventsPicker.alpha = 0
            self.eventsPickerHeightAnchor.constant = 50
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.smallEventsPicker.alpha = 1
            })
        }
    }
    
    func checkParkingOptions(text: String) {
        self.venueParking.text = text + "\n\nvia TicketMaster"
        self.venueParkingHeightAnchor.constant = self.venueParking.text.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPLightH4) + 20
        self.seeMoreLabel.alpha = 1
        self.view.layoutIfNeeded()
        var fullText: String = ""
        if text.contains("$") {
            let startIndex = text.range(of: "$")!.lowerBound
            let newText = text[startIndex...]
            let endIndex = newText.range(of: " ")!.lowerBound
            let finalText = newText[..<endIndex]
            fullText = "This venue averages \(finalText) for parking or you can park in a residential spot through Drivewayz for only \(self.costParking)/hour."
            let range = (NSString(string: fullText)).range(of: String(finalText))
            let attributedString = NSMutableAttributedString(string: fullText)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.PURPLE , range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH3 , range: range)
            let fullRange = NSString(string: fullText).range(of: fullText)
            attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPLightH3 , range: fullRange)
            let hourlyRange = (NSString(string: fullText)).range(of: String(self.costParking))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.SEA_BLUE , range: hourlyRange)
            attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH3 , range: hourlyRange)
            self.specificParking.attributedText = attributedString
            return
        } else if text.contains("parking pass") {
            fullText = "This venue recommends a parking pass. Or you can park in a residential spot through Drivewayz for only \(self.costParking)/hour."
        } else if text.contains("limited") {
            fullText = "This venue has very limited parking. Or you can park in a residential spot through Drivewayz for only \(self.costParking)/hour."
        } else if text.contains("price varies") {
            fullText = "Parking prices vary for this venue. You can park in a residential spot through Drivewayz for only \(self.costParking)/hour."
        } else {
            fullText = "This venue doens't have any parking price info. You can park in a residential spot through Drivewayz for only \(self.costParking)/hour."
            self.seeMoreLabel.alpha = 0
        }
        let hourlyRange = (NSString(string: fullText)).range(of: String(self.costParking))
        let attributedString = NSMutableAttributedString(string: fullText)
        let fullRange = NSString(string: fullText).range(of: fullText)
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPLightH3 , range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.SEA_BLUE , range: hourlyRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH3 , range: hourlyRange)
        self.specificParking.attributedText = attributedString
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.eventsPicker {
            self.smallEventsPicker.contentOffset.x = scrollView.contentOffset.x / (self.cellWidth + 12) * 74
        }
    }
    
    @objc func findEventParking() {
        guard let location = self.specificEventVenue.text else { return }
        self.backgroundTouched()
        self.delegate?.eventsControllerHidden()
//        self.delegate?.searchForParking()
        self.delegate?.zoomToSearchLocation(address: location)
    }
    
    @objc func openTicketMasterSite() {
        guard let url = URL(string: self.hrefEvent) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func getTimestamp(date: String, time: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: "\(date) \(time)") {
            return date.timeIntervalSince1970
        } else {
            return 0
        }
    }
    
    func formattDate(date: String, time: String, type: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: "\(date) \(time)") {
            let currentDate = Date()
            let formatter = DateFormatter()
            if type == "dotDate" {
                formatter.dateFormat = "EEEE '•' h a"
                let dayInWeek = formatter.string(from: date)
                if let days = Calendar.current.dateComponents([.day], from: currentDate, to: date).day {
                    if days == 0 {
                        if dayInWeek.contains("•") {
                            let startIndex = dayInWeek.range(of: "•")!.lowerBound
                            let newText = dayInWeek[startIndex...]
                            return "Today " + newText
                        } else {
                            return "Today"
                        }
                    } else if days == 1 {
                        return "Tomorrow"
                    } else if days > 1 && days < 7 {
                        return "\(dayInWeek)"
                    } else if days >= 7 && days < 14 {
                        return "Next \(dayInWeek)"
                    } else if days >= 14 && days < 30 {
                        return "In 2 weeks"
                    } else if days >= 30 && days < 60 {
                        return "Next month"
                    } else {
                        return ""
                    }
                }
            } else if type == "regularDate" {
                formatter.dateFormat = "MM/dd/yyyy '•' h:mm a"
                let dayInWeek = formatter.string(from: date)
                return dayInWeek
            }
        }
        return ""
    }

}
