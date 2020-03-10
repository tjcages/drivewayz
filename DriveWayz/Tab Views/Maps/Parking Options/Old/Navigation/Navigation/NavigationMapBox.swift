//
//  TestingMapBox.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/23/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
//import Mapbox
//import MapboxDirections
//import MapboxNavigation
//import MapboxCoreNavigation
//import MapboxNavigationNative
//import MapboxMobileEvents
import AVFoundation

class NavigationMapBox: UIViewController {
    
//    var delegate: handleRouteNavigation?
//    let locationManager = CLLocationManager()
//    var currentBookingImage: UIImage?
//    var currentBookingTime: String?
//    var currentSuccess: Bool = false
//
//    var directionsRoute: Route?
//    var walkingRoute: Route?
//    var directionsLegs: RouteLeg?
//    var directionsInstructions: [RouteStep]?
//    let directions = Directions.shared
//
//    var routeProgress: RouteProgress! {
//        didSet {
//            updateNavigator()
//        }
//    }
//    typealias StepSection = [RouteStep]
//    var sections = [StepSection]()
    
    var previousLegIndex: Int = NSNotFound
    var previousStepIndex: Int = NSNotFound
    let textDistanceFormatter = DistanceFormatter(approximate: true)
    
    var previousBookingPercentage: CGFloat = 0
    var durationLeftAnchor: NSLayoutConstraint!
    var durationRightAnchor: NSLayoutConstraint!
    var durationHeightAnchor: NSLayoutConstraint!
    var currentBookingHeight: CGFloat = phoneHeight - 116 - 252
    
    var timer: Timer?
    
    lazy var speechSynth = AVSpeechSynthesizer()
    
    /**
     The route controller’s delegate.
     */
//    @objc public weak var routeDelegate: RouterDelegate?
//    let navigator = MBNavigator()
    
    public enum DefaultBehavior {
        public static let shouldRerouteFromLocation: Bool = true
        public static let shouldDiscardLocation: Bool = true
        public static let didArriveAtWaypoint: Bool = true
        public static let shouldPreventReroutesWhenArrivingAtWaypoint: Bool = true
        public static let shouldDisableBatteryMonitoring: Bool = true
    }
    
//    var userDestinationLocation: CLLocationCoordinate2D?
//    var parkingSpotLocation: CLLocationCoordinate2D?
//    var currentBooking: Bookings? {
//        didSet {
//            if let booking = self.currentBooking {
//                if let latitude = booking.parkingLat, let longitude = booking.parkingLong {
//                    self.parkingSpotLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                    self.mapToParking()
//                }
//                if let latitude = booking.destinationLat, let longitude = booking.destinationLong {
//                    let destination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                    self.userDestinationLocation = destination
//                    self.mapToDestination(destinationSpot: destination)
//                } else {
//                    delayWithSeconds(1) {
//                        guard let userLocation = self.locationManager.location?.coordinate else { return }
//                        self.mapToDestination(destinationSpot: userLocation)
//                    }
//                }
//                if let parkingName = booking.parkingName {
//                    self.navigationBottom.durationController.mainLabel.text = parkingName
//                }
//                self.navigationBottom.currentBooking = booking
//            }
//        }
//    }
    
    var fullBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
//    lazy var navigationInstructions: NavigationInstructions = {
//        let controller = NavigationInstructions()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.alpha = 0
//        controller.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
////        controller.delegate = self
//
//        return controller
//    }()
    
    lazy var navigationBottom: NavigationBottomView = {
        let controller = NavigationBottomView()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.delegate = self
        
        return controller
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 28
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(locatorButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    var voiceButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "soundOff") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        if let myImage = UIImage(named: "soundOn") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .selected)
        }
        button.isSelected = true
        button.tintColor = Theme.WHITE
        button.backgroundColor = Theme.BLUE
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(voiceGuidancePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var routeButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_route") {
            button.setImage(myImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(routeButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    var walkingLocatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 28
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
//        button.addTarget(self, action: #selector(walkingLocatorPressed), for: .touchUpInside)
        
        return button
    }()
    
    var currentBottomHeightAnchor: NSLayoutConstraint!
    var mainBarPreviousPosition: CGFloat = 0.0
    var lowestHeight: CGFloat = 304
    var minimizedHeight: CGFloat = 192
    var mainBarHighest: Bool = false
    
//    var navigationMapController: NavigationViewController!
    
    /**
     The navigation service that coordinates the view controller’s nonvisual components, tracking the user’s location as they proceed along the route.
     */
//    var navigationService: NavigationService!
//    var navigationMapView: NavigationMapView!
    
    var currentLegIndexMapped = 0
    var currentStepIndexMapped = 0
    
    /**
     A Boolean value that determines whether the map annotates the locations at which instructions are spoken for debugging purposes.
     */
    var annotatesSpokenInstructions = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechSynth.delegate = self

//        setupLocationManager()
    }
//
//    func openCurrentBooking(image: UIImage, time: String) {
//        currentSuccess = true
//        currentBookingImage = image
//        currentBookingTime = time
//    }
    
//    func mapToParking() {
//        guard let userLocation = locationManager.location?.coordinate else { return }
//        if let parkingSpot = parkingSpotLocation {
//            self.calculateRoute(from: userLocation, to: parkingSpot, method: .automobileAvoidingTraffic, completion: { (route, error) in
//                if error != nil {
//                    print("Error calculating route")
//                }
//                guard let route = route else { return }
//                let options = NavigationOptions(styles: [CustomHiddenStyle()], navigationService: nil, voiceController: nil, topBanner: nil, bottomBanner: nil)
//                let navigationController = NavigationViewController(for: route, options: options)
//                //                let navigationController = NavigationViewController(for: route)
//                navigationController.delegate = self
//                navigationController.showsReportFeedback = false
//                navigationController.showsEndOfRouteFeedback = false
//                navigationController.mapView!.logoView.isHidden = true
//                navigationController.mapView!.attributionButton.isHidden = true
//
//                self.navigationMapController = navigationController
//                self.navigationService = navigationController.navigationService
//                self.navigationMapView = navigationController.mapView
//
//                self.navigationService.simulationSpeedMultiplier = 30
//
//                self.navigationService.delegate = self
//                self.navigationMapView.delegate = self
//                self.navigationMapView.courseTrackingDelegate = self
//
//                self.present(navigationController, animated: false, completion: {
////                    self.setupNavigation()
//                    if self.currentSuccess {
//                        self.openCurrentSuccess()
//                    } else {
//                        self.openGeneralSuccess()
//                    }
//                    if let booking = self.currentBooking, let check = booking.checkedIn {
//                        if check {
////                            self.checkInButtonPressed()
//                        }
//                    }
//                })
//            })
//        }
//    }
//
//    func mapToDestination(destinationSpot: CLLocationCoordinate2D) {
//        if let parkingSpot = parkingSpotLocation {
//            self.calculateRoute(from: parkingSpot, to: destinationSpot, method: .walking, completion: { (route, error) in
//                if error != nil {
//                    print("Error calculating route")
//                }
//                guard let route = route else { return }
//                self.walkingRoute = route
//
//                self.navigationBottom.durationController.expectedTravelTime = route.expectedTravelTime
//            })
//        }
//    }
//
//    func calculateRoute(from originCoor: CLLocationCoordinate2D, to destinationCoor: CLLocationCoordinate2D, method: MBDirectionsProfileIdentifier, completion: @escaping (Route?, Error?) -> Void) {
//        let origin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
//        let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")
//
//        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: method)
//
//        Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
//            guard let route = routes?.first else { return }
//            let legs = route.legs.first
//            self.directionsLegs = legs
//            self.directionsInstructions = legs?.steps
//
//            self.directionsRoute = route
//
//            completion(route, error)
//        })
//    }
    
//    func openCurrentSuccess() {
//        if let image = currentBookingImage, let time = currentBookingTime {
//            let controller = SuccessfulPurchaseViewController()
//            if let totalTime = currentTotalTime {
//                controller.changeDates(totalTime: totalTime)
//            }
//            controller.spotIcon.image = image
//            controller.loadingActivity.startAnimating()
//            controller.modalTransitionStyle = .crossDissolve
//            controller.modalPresentationStyle = .overFullScreen
//            controller.changeDates(totalTime: time)
//
//            navigationMapController.present(controller, animated: true) {
//                controller.animateSuccess()
//
//                delayWithSeconds(3, completion: {
//                    controller.closeSuccess()
//                    delayWithSeconds(animationIn, completion: {
//                        controller.dismiss(animated: true, completion: {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerForNotifications"), object: nil)
//                        })
//                    })
//                })
//            }
//        }
//    }
    
//    func openGeneralSuccess() {
//        let controller = SuccessfulPurchaseViewController()
//        if let totalTime = currentTotalTime {
//            controller.changeDates(totalTime: totalTime)
//        }
//        controller.loadingActivity.startAnimating()
//        controller.modalTransitionStyle = .crossDissolve
//        controller.modalPresentationStyle = .overFullScreen
//
//        navigationMapController.present(controller, animated: true) {
//            delayWithSeconds(1, completion: {
//                controller.closeSuccess()
//                delayWithSeconds(animationIn, completion: {
//                    controller.dismiss(animated: true, completion: {
//
//                    })
//                })
//            })
//        }
//    }
//
//}

//extension NavigationMapBox: NavigationServiceDelegate {
//
//    func navigationViewController(_ navigationViewController: NavigationViewController, shouldRerouteFrom location: CLLocation) -> Bool {
//        let shouldReroute = navigationService(navigationService, shouldRerouteFrom: location)
//
//        return shouldReroute
//    }
//
//    func navigationService(_ service: NavigationService, didRerouteAlong route: Route, at location: CLLocation?, proactive: Bool) {
//        let legs = route.legs.first
//        directionsLegs = legs
//        directionsInstructions = legs?.steps
//
//        navigationMapView.showRoutes([route])
//        navigationMapView.showWaypoints(route)
//    }
//
//    func navigationService(_ service: NavigationService, shouldRerouteFrom location: CLLocation) -> Bool {
//        let willReroute = !userIsOnRoute(location) && routeDelegate?.router?(self as! Router, shouldRerouteFrom: location)
//            ?? DefaultBehavior.shouldRerouteFromLocation
//
//        return !willReroute
//    }
//
//    public func userIsOnRoute(_ location: CLLocation) -> Bool {
//
//        // If the user has arrived, do not continue monitor reroutes, step progress, etc
//        if routeProgress.currentLegProgress.userHasArrivedAtWaypoint &&
//            (routeDelegate?.router?(self as! Router, shouldPreventReroutesWhenArrivingAt: routeProgress.currentLeg.destination) ??
//                DefaultBehavior.shouldPreventReroutesWhenArrivingAtWaypoint) {
//            return true
//        }
//
//        let status = navigator.getStatusForTimestamp(location.timestamp)
//        let offRoute = status.routeState == .offRoute
//        return !offRoute
//    }
//
//    func navigationViewController(_ navigationViewController: NavigationViewController, didRerouteAlong route: Route) {
////        self.removeLayers()
//
//        navigationMapView.showRoutes([route])
//        navigationMapView.showWaypoints(route)
//        navigationMapController.navigationService.route = route
//    }
//
//    func updateNavigator() {
//        if let route = directionsRoute {
//            assert(route.json != nil, "route.json missing, please verify the version of MapboxDirections.swift")
//
//            let data = try! JSONSerialization.data(withJSONObject: route.json!, options: [])
//            let jsonString = String(data: data, encoding: .utf8)!
//
//            // TODO: Add support for alternative route
//            navigator.setRouteForRouteResponse(jsonString, route: 0, leg: 0)
//        }
//    }
//
//    func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
//        routeProgress = progress
//        navigationMapView.updateCourseTracking(location: location, animated: true)
//
//        let route = progress.route
//        let legIndex = progress.legIndex
//        let stepIndex = progress.currentLegProgress.stepIndex
//
//        guard let navMap = navigationMapView else { return }
//        navMap.updatePreferredFrameRate(for: progress)
//        if currentLegIndexMapped != legIndex {
//            navMap.showWaypoints(route, legIndex: legIndex)
//            navMap.showRoutes([route], legIndex: legIndex)
//
//            currentLegIndexMapped = legIndex
//        }
//
//        if currentStepIndexMapped != stepIndex {
//            updateMapOverlays(for: progress)
//            currentStepIndexMapped = stepIndex
//        }
//
//        if directionsRoute == nil {
////            updateRoute(progress: progress)
//        }
//
//        let status = !userIsOnRoute(location)
//        if status {
//            let route = routeProgress.route
//            self.navigationMapView.showRoutes([route])
//            self.navigationMapView.showWaypoints(route)
//            self.navigationMapController.navigationService.route = route
//        }
//
//        navigationInstructions.routeProgress = progress
//        navigationBottom.routeProgress = progress
//    }
//
//
//
//    func navigationService(_ service: NavigationService, didPassSpokenInstructionPoint instruction: SpokenInstruction, routeProgress: RouteProgress) {
//        var speak = instruction.text
//        speak = speak.replacingOccurrences(of: " finish", with: "your parking spot")
//        speak = speak.replacingOccurrences(of: " Finish", with: "your parking spot")
//
//        let utterance = AVSpeechUtterance(string: speak)
//        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Karen-compact")
//        service.router.reroutesProactively = true
//        navigationMapController.voiceController = nil
//
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(.playback, options: .duckOthers)
//        } catch {
//            //handle error
//            print(error)
//        }
//
//        if annotatesSpokenInstructions {
//            speechSynth.speak(utterance)
//        }
//    }
//
//    func navigationService(_ service: NavigationService, willArriveAt waypoint: Waypoint, after remainingTimeInterval: TimeInterval, distance: CLLocationDistance) {
//        if directionsRoute != nil {
//            navigationBottom.navigationStatus = .nearParking
//        } else {
////            navigationBottom.navigationStatus = .nearParking
//        }
//    }
//
//    func navigationService(_ service: NavigationService, didArriveAt waypoint: Waypoint) -> Bool {
////        let componentsWantAdvance = navigationService(service, didArriveAt: waypoint)
//
//        if directionsRoute != nil {
//            navigationBottom.navigationStatus = .parked
//        } else {
////            navigationBottom.navigationStatus = .parked
//        }
//
//        if navigationBottom.navigationStatus == .walking {
////            userArrivedAtDestination()
//        }
//
//        if service.routeProgress.isFinalLeg {
//            // END OF JOURNEY
//            print("FUCK ITS OVER")
//            return true
//        }
//        return false
//    }
//
//    func rebuildDataSourceIfNecessary() -> Bool {
//        let legIndex = routeProgress.legIndex
//        let stepIndex = routeProgress.currentLegProgress.stepIndex
//        let didProcessCurrentStep = previousLegIndex == legIndex && previousStepIndex == stepIndex
//
//        guard !didProcessCurrentStep else { return false }
//
//        sections.removeAll()
//
//        let currentLeg = routeProgress.currentLeg
//
//        // Add remaining steps for current leg
//        var section = [RouteStep]()
//        for (index, step) in currentLeg.steps.enumerated() {
//            guard index > stepIndex else { continue }
//            // Don't include the last step, it includes nothing
//            guard index < currentLeg.steps.count - 1 else { continue }
//            section.append(step)
//        }
//
//        if !section.isEmpty {
//            sections.append(section)
//        }
//
//        // Include all steps on any future legs
//        if !routeProgress.isFinalLeg {
//            routeProgress.route.legs.suffix(from: routeProgress.legIndex + 1).forEach {
//                var steps = $0.steps
//                // Don't include the last step, it includes nothing
//                _ = steps.popLast()
//                sections.append(steps)
//            }
//        }
//
//        previousStepIndex = stepIndex
//        previousLegIndex = legIndex
//
//        return true
//    }
    
}

// Handle the actual routing logic
//extension NavigationMapBox: NavigationViewControllerDelegate, NavigationMapViewCourseTrackingDelegate {
//
//    func navigationViewController(_ navigationViewController: NavigationViewController, mapViewUserAnchorPoint mapView: NavigationMapView) -> CGPoint {
//        let height = phoneHeight - lowestHeight - 64
//        return CGPoint(x: phoneWidth/2, y: height)
//
////        if directionsRoute != nil {
////            if mainBarTopAnchor != nil && mainBarTopAnchor.constant == self.minimizedHeight {
////                let height = phoneHeight - minimizedHeight - 64
////                return CGPoint(x: phoneWidth/2, y: height)
////            } else {
////                let height = phoneHeight - lowestHeight - 64
////                return CGPoint(x: phoneWidth/2, y: height)
////            }
////        } else {
////            let height = phoneHeight - lowestHeight - 64
////            return CGPoint(x: phoneWidth/2, y: height)
////        }
//    }
//
//    func updateMapOverlays(for routeProgress: RouteProgress) {
//        if routeProgress.currentLegProgress.followOnStep != nil {
//            navigationMapView.addArrow(route: routeProgress.route, legIndex: routeProgress.legIndex, stepIndex: routeProgress.currentLegProgress.stepIndex + 1)
//        } else {
//            navigationMapView.removeArrow()
//        }
//    }
//
//    public func update(for instruction: VisualInstructionBanner?) {
//        navigationMapView.recenterMap()
//    }
//
//}
//
//extension NavigationMapBox: CLLocationManagerDelegate, MGLMapViewDelegate {
//
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.showsBackgroundLocationIndicator = false
//        locationManager.allowsBackgroundLocationUpdates = false
//
//        locationManager.startUpdatingLocation()
//    }
//
//}

extension NavigationMapBox: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
    
}
