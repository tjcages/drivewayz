////
////  NavigationController.swift
////  DriveWayz
////
////  Created by Tyler J. Cagle on 2/18/20.
////  Copyright © 2020 COAD. All rights reserved.
////
//
//import UIKit
//import MapKit
//import GoogleMaps
//import AVFoundation
//
//class NavigationViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, NavigationKitDelegate {
//
//    var locationManager: CLLocationManager?
//    var navigationKit: NavigationKit?
//
//    lazy var mapView: GMSMapView = {
//        let camera = GMSCameraPosition.camera(withLatitude: 37.8249, longitude: -122.4194, zoom: 14.0)
//        let view = GMSMapView(frame: .zero, camera: camera)
//        view.delegate = self
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isMyLocationEnabled = true
//        view.settings.tiltGestures = true
//        view.settings.compassButton = false
//        view.settings.rotateGestures = false
//        view.padding = UIEdgeInsets(top: topSafeArea, left: horizontalPadding, bottom: bottomSafeArea, right: horizontalPadding)
//
//        return view
//    }()
//
//    var directionView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = Theme.BLACK
//
//        return view
//    }()
//
//    var maneuverImageView: UIImageView = {
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentMode = .scaleAspectFit
//
//        return view
//    }()
//
//    var distanceLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = Theme.WHITE
//        label.font = Fonts.SSPSemiBoldH4
//
//        return label
//    }()
//
//    var instructionLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = Theme.WHITE
//        label.font = Fonts.SSPSemiBoldH25
//        label.numberOfLines = 3
//
//        return label
//    }()
//
//    var cancelButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .yellow
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        mapView.delegate = self
//
//        setupLocationManager()
//        setupViews()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        // STANDARD START AND END COORDINATES
//        navigationKit = NavigationKit(source: hostLocation.coordinate, destination: testDestination.coordinate, transportType: MKDirectionsTransportType.automobile, directionsService: NavigationKitDirectionsServiceGoogleMaps)
//        navigationKit?.delegate = self
//        navigationKit?.calculateDirections()
//
//        CATransaction.begin()
//        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
////        CATransaction.setValue(3, forKey: kCATransactionAnimationTimingFunction)
//        if let userLocation = self.locationManager?.location {
//            let camera = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel - 1.5)
//            mapView.camera = camera
//            let camera2 = GMSCameraPosition(target: userLocation.coordinate, zoom: mapZoomLevel)
//            mapView.animate(to: camera2)
//        }
//        CATransaction.commit()
//    }
//
//    func setupViews() {
//
//        view.addSubview(mapView)
//        view.addSubview(directionView)
//        view.addSubview(maneuverImageView)
//        view.addSubview(distanceLabel)
//        view.addSubview(instructionLabel)
//        view.addSubview(cancelButton)
//
//        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        directionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
//
//        maneuverImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
//
//        distanceLabel.anchor(top: maneuverImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        distanceLabel.sizeToFit()
//
//        instructionLabel.anchor(top: maneuverImageView.topAnchor, left: maneuverImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
//        instructionLabel.sizeToFit()
//
//        cancelButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 32, paddingRight: 32, width: 0, height: 50)
//
//    }
//
//    func setupLocationManager() {
//        // Ask for User location
//        mapView.delegate = self
//
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.showsBackgroundLocationIndicator = false
//        locationManager?.allowsBackgroundLocationUpdates = true
//
//        locationManager?.requestWhenInUseAuthorization()
//        locationManager?.startUpdatingLocation()
//        locationManager?.startUpdatingHeading()
//
//        // Load the map style to be applied to Google Maps
//        if let path = Bundle.main.path(forResource: "GoogleMapStyle", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                do {
//                    // Set the map style by passing a valid JSON string.
//                    if let jsonString = jsonToString(json: jsonResult as AnyObject) {
//                        mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
//                    }
//                } catch {
//                    NSLog("One or more of the map styles failed to load. \(error)")
//                }
//            } catch {
//                // handle error
//                NSLog("One or more of the map styles failed to load. \(error)")
//            }
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
//
//    // MARK: - Navigation Methods
//    @IBAction func cancelNavigation(_ sender: Any) {
//        print("Cancel navigation")
//        navigationKit?.stopNavigation()
//    }
//
//    // MARK: - Helper Methods
//
//    // Round up a distance by multiple
//    func roundedDistance(_ distance: CLLocationDistance, multiple: Int) -> CLLocationDistance {
//        return CLLocationDistance(CLLocationDistance(multiple - Int(distance) % multiple) + distance)
//    }
//
//    func formatDistance(_ distance: CLLocationDistance, abbreviated: Bool) -> String? {
//
//        var roundedDistance = self.roundedDistance(distance, multiple: 100)
//
//        if distance < 100 {
//            roundedDistance = self.roundedDistance(distance, multiple: 50)
//        }
//
//        if distance < 50 {
//            roundedDistance = self.roundedDistance(distance, multiple: 10)
//        }
//
//        if roundedDistance < 1000 {
//            return "\(Int(roundedDistance)) \(abbreviated ? "m" : "meters")"
//        } else {
//            return String(format: "%.01f %@", roundedDistance / 1000, abbreviated ? "km" : "kilometers")
//        }
//    }
//
//    func sanitizedHTMLString(_ string: String?) -> String? {
//        if let data = string?.data(using: .utf8) {
//            return try? NSAttributedString(data: data, options: [
//            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
//            NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
//            ], documentAttributes: nil).string
//        }
//        return nil
//    }
//
//    func image(for maneuver: NKRouteStepManeuver) -> UIImage? {
//        // Default to straight
//        var image = UIImage(named: "straight")
//
//        switch maneuver {
//        case .turnSharpLeft:
//            image = UIImage(named: "turn-sharp-left")
//        case .uturnRight:
//            image = UIImage(named: "uturn-right")
//        case .turnSlightRight:
//            image = UIImage(named: "turn-slight-right")
//        case .merge:
//            image = UIImage(named: "merge")
//        case .roundaboutLeft:
//            image = UIImage(named: "roundabout-left")
//        case .roundaboutRight:
//            image = UIImage(named: "roundabout-right")
//        case .uturnLeft:
//            image = UIImage(named: "uturn-left")
//        case .turnSlightLeft:
//            image = UIImage(named: "turn-slight-left")
//        case .turnLeft:
//            image = UIImage(named: "turn-left")
//        case .rampRight:
//            image = UIImage(named: "ramp-right")
//        case .turnRight:
//            image = UIImage(named: "turn-right")
//        case .forkRight:
//            image = UIImage(named: "fork-right")
//        case .straight:
//            image = UIImage(named: "straight")
//        case .forkLeft:
//            image = UIImage(named: "fork-left")
//        case .turnSharpRight:
//                image = UIImage(named: "turn-sharp-right")
//        case .rampLeft:
//                image = UIImage(named: "ramp-left")
//        default:
//                break
//        }
//
//        return image
//    }
//
//    // MARK: - NavigationKitDelegate
//    func navigationKitError(_ error: Error?) {
//        print("NavigationKit Error: \(error?.localizedDescription ?? "")")
//    }
//
//    func navigationKitCalculatedRoute(_ route: NKRoute?) {
//        print(String(format: "NavigationKit Calculated Route with %lu steps", UInt(route?.steps.count ?? 0)))
//
//        DispatchQueue.main.async {
//            // Start location updates
//            self.locationManager?.startUpdatingLocation()
//
//            // Add Path to map
//            if let path = route?.path {
//                let polyline = GMSPolyline(path: path)
//                polyline.strokeColor = Theme.BLUE
//                polyline.strokeWidth = 8
//                polyline.map = self.mapView
//            }
//            if let bounding = route?.path {
//                let bounds = GMSCoordinateBounds(path: bounding)
//                let inset = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
//                let camera = GMSCameraUpdate.fit(bounds, with: inset)
//                self.mapView.animate(with: camera)
//            }
//
//            // Start navigation
//            self.navigationKit?.startNavigation()
//        }
//    }
//
//    func navigationKitStartedNavigation() {
//        print("NavigationKit Started Navigation")
//    }
//
//    func navigationKitStoppedNavigation() {
//        print("NavigationKit Stopped Navigation")
//
//        // Reset UI state
//        mapView.clear()
////        let overlays = mapView.overlays
////        mapView.removeOverlays(overlays)
//
//        instructionLabel.text = nil
//        distanceLabel.text = nil
//        maneuverImageView.image = nil
//    }
//
//    func navigationKitStartedRecalculation() {
//        print("NavigationKit Started Recalculating Route")
//
//        // Remove overlays
//        mapView.clear()
////        let overlays = mapView.overlays
////        mapView.removeOverlays(overlays)
//    }
//
//    func navigationKitEnteredRouteStep(_ step: NKRouteStep?, nextStep: NKRouteStep?) {
//        print("NavigationKit Entered New Step")
//        instructionLabel.text = sanitizedHTMLString(nextStep?.instructions)
//
//        // Set maneuver icon if available
//        if let nextStep = nextStep {
//            print("maneuver: \(nextStep.maneuver.rawValue)")
//            maneuverImageView.image = image(for: nextStep.maneuver)
//        }
//    }
//
//    func navigationKitCalculatedDistance(toEndOfPath distance: CLLocationDistance) {
//        let formattedDistance = formatDistance(distance, abbreviated: true)
//        distanceLabel.text = formattedDistance
//    }
//
//    func navigationKitCalculatedNotification(for step: NKRouteStep?, inDistance distance: CLLocationDistance) {
//        if let instructions = step?.instructions {
//            print("NavigationKit Calculated Notification \"\(instructions)\" (in \(distance) meters)")
//        }
//
//        let message = "In \(formatDistance(distance, abbreviated: false)!), \(sanitizedHTMLString(step?.instructions)!)"
//
//        let utterance = AVSpeechUtterance(string: message)
//        utterance.voice = AVSpeechSynthesisVoice(language: NSLocale.current.identifier)
////        utterance.rate = 0.10
//
//        let speechSynthesizer = AVSpeechSynthesizer()
//        speechSynthesizer.speak(utterance)
//    }
//
//    func navigationKitCalculatedCamera(_ camera: GMSCameraPosition!) {
//        if let camera = camera {
//            let update = GMSCameraUpdate.setCamera(camera)
//            mapView.animate(with: update)
//        }
//    }
//
//    func navigationKitCalculatedCamera(_ camera: MKMapCamera!) {
//        //
//    }
//
//    // MARK: - CLLocationManagerDelegate
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.first
//        navigationKit?.calculateAction(for: location)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        guard status == .authorizedWhenInUse else {
//            return
//        }
//        locationManager?.startUpdatingLocation()
//    }
//
//}
