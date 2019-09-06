//
//  TestingMapBox.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/23/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation
import AVFoundation

class NavigationMapBox: UIViewController {
    
    let locationManager = CLLocationManager()
    var directionsRoute: Route?
    var walkingRoute: Route?
    var directionsLegs: RouteLeg?
    var directionsInstructions: [RouteStep]?
    let directions = Directions.shared
    
    var routeProgress: RouteProgress!
    typealias StepSection = [RouteStep]
    var sections = [StepSection]()
    
    var previousLegIndex: Int = NSNotFound
    var previousStepIndex: Int = NSNotFound
    let textDistanceFormatter = DistanceFormatter(approximate: true)
    
    lazy var speechSynth = AVSpeechSynthesizer()
    
    var mapView: MGLMapView = {
        let view = MGLMapView()
        view.showsScale = false
        view.showsHeading = false
        view.showsTraffic = true
        view.compassView.isHidden = true
        view.showsUserHeadingIndicator = true
        view.logoView.isHidden = true
        view.userTrackingMode = .follow
        view.logoView.isHidden = true
        view.attributionButton.isHidden = true
        
        return view
    }()
    
    var fullBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    lazy var navigationInstructions: NavigationInstructions = {
        let controller = NavigationInstructions()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        controller.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//        controller.delegate = self
        
        return controller
    }()
    
    lazy var navigationBottom: NavigationBottomView = {
        let controller = NavigationBottomView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        
        return controller
    }()
    
    var locatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.DARK_GRAY
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 28
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locatorButtonAction), for: .touchUpInside)
        
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
        button.addTarget(self, action: #selector(voiceGuidancePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var routeButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_route") {
            button.setImage(myImage, for: .normal)
        }
        button.tintColor = Theme.DARK_GRAY
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(routeButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    var walkingLocatorButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "my_location") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.DARK_GRAY
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 28
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(walkingLocatorPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainBarTopAnchor: NSLayoutConstraint!
    var mainBarPreviousPosition: CGFloat = 0.0
    var lowestHeight: CGFloat = 304
    var minimizedHeight: CGFloat = 192
    var mainBarHighest: Bool = false
    
    var navigationMapController: NavigationViewController!
    
    /**
     The navigation service that coordinates the view controller’s nonvisual components, tracking the user’s location as they proceed along the route.
     */
    var navigationService: NavigationService!
    var navigationMapView: NavigationMapView!
    
    var currentLegIndexMapped = 0
    var currentStepIndexMapped = 0
    
    /**
     A Boolean value that determines whether the map annotates the locations at which instructions are spoken for debugging purposes.
     */
    var annotatesSpokenInstructions = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechSynth.delegate = self

        setupLocationManager()
        setupViews()
    }
    
    func setupViews() {
        
        mapView.frame = view.frame
        view.addSubview(mapView)
        
        delayWithSeconds(0.1) {
            let parkingSpot = CLLocationCoordinate2D(latitude: 40.007229, longitude: -105.262077)
            let disneyland = CLLocationCoordinate2D(latitude: 40.0095, longitude: -105.2669)
            
            let annotation = MGLPointAnnotation()
            annotation.coordinate = disneyland
            self.mapView.addAnnotation(annotation)
            
            self.mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
            self.calculateRoute(from: self.mapView.userLocation!.coordinate, to: parkingSpot, method: .automobileAvoidingTraffic, completion: { (route, error) in
                if error != nil {
                    print("Error calculating route")
                }
                guard let route = route else { return }
                let options = NavigationOptions(styles: [CustomHiddenStyle()], navigationService: nil, voiceController: nil, topBanner: nil, bottomBanner: nil)
                let navigationController = NavigationViewController(for: route, options: options)
//                let navigationController = NavigationViewController(for: route)
                navigationController.delegate = self
                navigationController.showsReportFeedback = false
                navigationController.showsEndOfRouteFeedback = false
                navigationController.mapView!.logoView.isHidden = true
                navigationController.mapView!.attributionButton.isHidden = true
                
                self.navigationMapController = navigationController
                self.navigationService = navigationController.navigationService
                self.navigationMapView = navigationController.mapView
                
                self.navigationService.simulationSpeedMultiplier = 30
                
                self.navigationService.delegate = self
                self.navigationMapView.delegate = self
                self.navigationMapView.courseTrackingDelegate = self
                
                self.present(navigationController, animated: true, completion: {
                    self.setupNavigation()
                    
                    self.calculateRoute(from: parkingSpot, to: disneyland, method: .walking, completion: { (route, error) in
                        if error != nil {
                            print("Error calculating route")
                        }
                        guard let route = route else { return }
                        self.walkingRoute = route
                    
                        self.navigationBottom.durationController.expectedTravelTime = route.expectedTravelTime
                    })
                })
            })
        }
    }
    
    func calculateRoute(from originCoor: CLLocationCoordinate2D, to destinationCoor: CLLocationCoordinate2D, method: MBDirectionsProfileIdentifier, completion: @escaping (Route?, Error?) -> Void) {
        let origin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: method)
        
        Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            let legs = route.legs.first
            self.directionsLegs = legs
            self.directionsInstructions = legs?.steps
            
            self.directionsRoute = route
            self.drawRoute(route: route)
            
            // Set MapView region
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoor, ne: originCoor)
            let insets = UIEdgeInsets(top: statusHeight + 32, left: 32, bottom: phoneHeight/2 + 32, right: 32)
            let routeCamera = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCamera, animated: true)
            
            completion(route, error)
        })
    }
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            
            lineStyle.lineColor = NSExpression(forConstantValue: Theme.BLUE)
            lineStyle.lineWidth = NSExpression(forConstantValue: 4.0)
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
}

extension NavigationMapBox: NavigationServiceDelegate {
    
    func navigationViewController(_ navigationViewController: NavigationViewController, shouldRerouteFrom location: CLLocation) -> Bool {
        let shouldReroute = navigationService(navigationService, shouldRerouteFrom: location)
        return shouldReroute
    }
    
    func navigationService(_ service: NavigationService, didRerouteAlong route: Route, at location: CLLocation?, proactive: Bool) {
        let legs = route.legs.first
        directionsLegs = legs
        directionsInstructions = legs?.steps
    }
    
    func navigationService(_ service: NavigationService, didPassVisualInstructionPoint instruction: VisualInstructionBanner, routeProgress: RouteProgress) {
        
    }
    
    func navigationService(_ service: NavigationService, shouldRerouteFrom location: CLLocation) -> Bool {
        let componentsWantReroute = navigationService(service, shouldRerouteFrom: location)
        return componentsWantReroute
    }
    
    func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        routeProgress = progress
        navigationMapView.updateCourseTracking(location: location, animated: true)
        
        let route = progress.route
        let legIndex = progress.legIndex
        let stepIndex = progress.currentLegProgress.stepIndex
        
        guard let navMap = navigationMapView else { return }
        navMap.updatePreferredFrameRate(for: progress)
        if currentLegIndexMapped != legIndex {
            navMap.showWaypoints(route, legIndex: legIndex)
            navMap.showRoutes([route], legIndex: legIndex)
            
            currentLegIndexMapped = legIndex
        }
        
        if currentStepIndexMapped != stepIndex {
            updateMapOverlays(for: progress)
            currentStepIndexMapped = stepIndex
        }
        
        if directionsRoute == nil {
            updateRoute(progress: progress)
        }
        
        navigationInstructions.routeProgress = progress
        navigationBottom.routeProgress = progress
    }
    
    func navigationService(_ service: NavigationService, didPassSpokenInstructionPoint instruction: SpokenInstruction, routeProgress: RouteProgress) {
        var speak = instruction.text
        speak = speak.replacingOccurrences(of: " finish", with: "your parking spot")
        speak = speak.replacingOccurrences(of: " Finish", with: "your parking spot")
        
        let utterance = AVSpeechUtterance(string: speak)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Karen-compact")
        service.router.reroutesProactively = true
        navigationMapController.voiceController = nil
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, options: .duckOthers)
        } catch {
            //handle error
            print(error)
        }
        
        if annotatesSpokenInstructions {
//            navigationMapController.voiceController.speak(instruction)
            speechSynth.speak(utterance)
        }
    }
    
    func navigationService(_ service: NavigationService, willArriveAt waypoint: Waypoint, after remainingTimeInterval: TimeInterval, distance: CLLocationDistance) {
        if directionsRoute != nil {
            navigationBottom.navigationStatus = .nearParking
        } else {
//            navigationBottom.navigationStatus = .nearParking
        }
    }
    
    func navigationService(_ service: NavigationService, didArriveAt waypoint: Waypoint) -> Bool {
//        let componentsWantAdvance = navigationService(service, didArriveAt: waypoint)
        
        if directionsRoute != nil {
            navigationBottom.navigationStatus = .parked
        } else {
//            navigationBottom.navigationStatus = .parked
        }
        
        if navigationBottom.navigationStatus == .walking {
            userArrivedAtDestination()
        }
        
        if service.routeProgress.isFinalLeg {
            // END OF JOURNEY
            print("FUCK ITS OVER")
            return true
        }
        return false
    }
    
    func rebuildDataSourceIfNecessary() -> Bool {
        let legIndex = routeProgress.legIndex
        let stepIndex = routeProgress.currentLegProgress.stepIndex
        let didProcessCurrentStep = previousLegIndex == legIndex && previousStepIndex == stepIndex
        
        guard !didProcessCurrentStep else { return false }
        
        sections.removeAll()
        
        let currentLeg = routeProgress.currentLeg
        
        // Add remaining steps for current leg
        var section = [RouteStep]()
        for (index, step) in currentLeg.steps.enumerated() {
            guard index > stepIndex else { continue }
            // Don't include the last step, it includes nothing
            guard index < currentLeg.steps.count - 1 else { continue }
            section.append(step)
        }
        
        if !section.isEmpty {
            sections.append(section)
        }
        
        // Include all steps on any future legs
        if !routeProgress.isFinalLeg {
            routeProgress.route.legs.suffix(from: routeProgress.legIndex + 1).forEach {
                var steps = $0.steps
                // Don't include the last step, it includes nothing
                _ = steps.popLast()
                sections.append(steps)
            }
        }
        
        previousStepIndex = stepIndex
        previousLegIndex = legIndex
        
        return true
    }
    
}

// Handle the actual routing logic
extension NavigationMapBox: NavigationViewControllerDelegate, NavigationMapViewCourseTrackingDelegate {
    
    func navigationViewController(_ navigationViewController: NavigationViewController, mapViewUserAnchorPoint mapView: NavigationMapView) -> CGPoint {
        let height = phoneHeight - lowestHeight - 64
        return CGPoint(x: phoneWidth/2, y: height)
        
//        if directionsRoute != nil {
//            if mainBarTopAnchor != nil && mainBarTopAnchor.constant == self.minimizedHeight {
//                let height = phoneHeight - minimizedHeight - 64
//                return CGPoint(x: phoneWidth/2, y: height)
//            } else {
//                let height = phoneHeight - lowestHeight - 64
//                return CGPoint(x: phoneWidth/2, y: height)
//            }
//        } else {
//            let height = phoneHeight - lowestHeight - 64
//            return CGPoint(x: phoneWidth/2, y: height)
//        }
    }
    
    func updateMapOverlays(for routeProgress: RouteProgress) {
        if routeProgress.currentLegProgress.followOnStep != nil {
            navigationMapView.addArrow(route: routeProgress.route, legIndex: routeProgress.legIndex, stepIndex: routeProgress.currentLegProgress.stepIndex + 1)
        } else {
            navigationMapView.removeArrow()
        }
    }
    
    public func update(for instruction: VisualInstructionBanner?) {
        navigationMapView.recenterMap()
    }
    
}

extension NavigationMapBox: CLLocationManagerDelegate, MGLMapViewDelegate {
    
    func setupLocationManager() {
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.allowsBackgroundLocationUpdates = false
        
        locationManager.startUpdatingLocation()
    }
    
}

extension NavigationMapBox: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
    
}
