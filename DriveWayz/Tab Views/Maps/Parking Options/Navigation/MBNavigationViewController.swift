//
//  MBNavigationViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import Mapbox
import CoreLocation
import AVFoundation
import MapboxDirections
import Turf

class MBNavigationViewController: UIViewController, MGLMapViewDelegate {
    
    var delegate: NavigationProtocol?
    
    var destination: MGLPointAnnotation!
    let directions = Directions.shared
    var navigationService: NavigationService!
    var simulateLocation = false
    
    // Zoom, pitch, and inset constants
    let defaultAltitude: CLLocationDistance = 1000
    let defaultHighAltitude: CLLocationDistance = 2000
    let defaultLowAltitude: CLLocationDistance = 1200
    let zoomedOutMotorwayAltitude: CLLocationDistance = 3000
    
    let defaultHighPitch: CGFloat = 53
    let defaultLowPitch: CGFloat = 0
    let pitchTransitionDistance: CLLocationDistance = 420
    
    let defaultXInset: CGFloat = 0
    lazy var defaultMaxXInset: CGFloat = phoneWidth/2
    let defaultYInset: CGFloat = 0
    lazy var defaultMaxYInset: CGFloat = 64
    
    var startLocation: CLLocation? {
        didSet {
            if let location = startLocation {
                mapView.setCenter(location.coordinate, zoomLevel: 15, animated: false)
            }
        }
    }

    var router: Router { return navigationService.router }
    
    var userRoute: Route? {
        didSet {
            // Begin setting up the navigation service and listening for notifications
            let locationManager = simulateLocation ? SimulatedLocationManager(route: userRoute!) : NavigationLocationManager()
            navigationService = MapboxNavigationService(route: userRoute!, locationSource: locationManager, simulating: simulateLocation ? .always : .onPoorGPS)
            navigationService.simulationSpeedMultiplier = 3.0 // Speed up testing
            voiceController = MapboxVoiceController(navigationService: navigationService)
            
            mapView.delegate = self
            mapView.navigationMapViewDelegate = self
            mapView.show([userRoute!])
    //        NavigationSettings.shared.voiceMuted = true // NEED TO IMPLEMENT VOICE CONTROLS
            router.reroutesProactively = true
            
            // Add listeners for progress updates
            resumeNotifications()

            // Start navigation
            navigationService.start()
            navigationService.delegate = self
            
            // Center map above route
            tracksUserCourse = true
            
            UIView.animateOut(withDuration: animationOut, animations: {
                self.view.alpha = 1
            }) { (success) in
                self.bottomView.showContainer()
                self.instructionsBannerView.showInstructionBanner()
            }
        }
    }
    
    var isInOverviewMode = false
    
    var defaultAnchorPoint: CGPoint = .zero
    var userAnchorPoint: CGPoint {
        if let anchorPoint = mapView.navigationMapViewDelegate?.navigationMapViewUserAnchorPoint(mapView), anchorPoint != .zero {
            defaultAnchorPoint = anchorPoint
            return anchorPoint
        }
        let contentFrame = mapView.bounds.inset(by: mapView.contentInset)
        return CGPoint(x: contentFrame.midX, y: contentFrame.midY)
    }
    
    var previousProgress: RouteProgress?
    var timer: DispatchTimer?
    
    var destinationTimer: Timer?
    var showDestinationCheck: Bool = false
    
    let dateFormatter = DateFormatter()
    let dateComponentsFormatter = DateComponentsFormatter()
    let distanceFormatter = DistanceFormatter()
    
    // The minimum default insets from the content frame to the edges of the user course view
    let courseViewMinimumInsets: CGFloat = 20
    
    @objc public dynamic var tracksUserCourse: Bool {
        get {
            return mapView.tracksUserCourse
        }
        set {
            let progress = navigationService.routeProgress
            if !tracksUserCourse && newValue {
                isOverviewingRoutes = false
                mapView.recenterMap()
                mapView.addArrow(route: progress.route,
                                  legIndex: progress.legIndex,
                                  stepIndex: progress.currentLegProgress.stepIndex + 1)
                mapView.setContentInset(contentInset(forOverviewing: false), animated: true, completionHandler: nil)
                bottomView.locatorButton.alpha = 1
            } else if tracksUserCourse && !newValue {
                isOverviewingRoutes = !isPanningAway
                guard let userLocation = self.navigationService.router.location?.coordinate,
                    let shape = navigationService.route.shape else {
                    return
                }
                bottomView.locatorButton.alpha = 0
                mapView.enableFrameByFrameCourseViewTracking(for: 1)
                mapView.contentInset = contentInset(forOverviewing: isOverviewingRoutes)
                if (isOverviewingRoutes) {
                    mapView.setOverheadCameraView(from: userLocation, along: shape.coordinates, for: contentInset(forOverviewing: true))
                }
            }
        }
    }
    
    // Tracks if tracksUserCourse was set to false from overview button
    // or panned away.
    var isPanningAway = false
    var isOverviewingRoutes = false
    
    // Start voice instructions
    var voiceController: MapboxVoiceController!
    
    var stepsViewController: StepsViewController?

    // Preview index of step, this will be nil if we are not previewing an instruction
    var previewStepIndex: Int?
    
    // View that is placed over the instructions banner while we are previewing
    var previewInstructionsView: StepInstructionsView?
    
    var userCourseView = NavigationUserPuckView(frame: CGRect(origin: .zero, size: CGSize(size: 64)))
    
    lazy var mapView: NavigationMapView = {
        let view = NavigationMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsUserLocation = true
        view.logoView.isHidden = true
        view.compassView.isHidden = true
        view.isPitchEnabled = true
        view.defaultAltitude = defaultHighAltitude
        view.userCourseView = userCourseView
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }()
    
    lazy var instructionsBannerView: NavigationInstructionsView = {
        let view = NavigationInstructionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var bottomView: NavigationBottomView = {
        let view = NavigationBottomView()
        view.checkInButton.addTarget(self, action: #selector(checkInButtonPressed), for: .touchUpInside)
        view.exitButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        view.locatorButton.addTarget(self, action: #selector(recenterMap), for: .touchUpInside)
        
        return view
    }()
    
    lazy var feedbackViewController: FeedbackViewController = {
        return FeedbackViewController(eventsManager: navigationService.eventsManager)
    }()
    
    var navigationView = NavigationPopupView()
    
    var routeParkingPin: UIImageView = {
        let image = UIImage(named: "routeSelectedPin")
        let view = UIImageView(image: image)
        view.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        view.contentMode = .scaleAspectFill
        view.alpha = 0
        
        return view
    }()

    var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateComponentsFormatter.allowedUnits = [.hour, .minute]
        dateComponentsFormatter.unitsStyle = .abbreviated
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        view.alpha = 0
        
        mapView.styleURL = NavigationStyling().mapStyleURL
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lightContentStatusBar()
//        tracksUserCourse = false
        delayWithSeconds(animationIn) {
//            self.tracksUserCourse = true
            self.defaultAnchorPoint = self.userAnchorPoint
        }
    }
    
    func setupViews() {
        
        view.addSubview(mapView)
        view.addSubview(instructionsBannerView)
        view.addSubview(bottomView)
        
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -100, paddingRight: 0, width: 0, height: 0)
        
        instructionsBannerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 240)
        
        bottomView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 208)
        
        mapView.addSubview(navigationView)
        mapView.addSubview(routeParkingPin)
        
        navigationView.widthAnchor.constraint(equalToConstant: 182).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(dimmingView)
        dimmingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

    deinit {
        suspendNotifications()
    }

    func resumeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(progressDidChange(_ :)), name: .routeControllerProgressDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rerouted(_:)), name: .routeControllerDidReroute, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInstructionsBanner(notification:)), name: .routeControllerDidPassVisualInstructionPoint, object: navigationService.router)
    }

    func suspendNotifications() {
        NotificationCenter.default.removeObserver(self, name: .routeControllerProgressDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .routeControllerWillReroute, object: nil)
        NotificationCenter.default.removeObserver(self, name: .routeControllerDidPassVisualInstructionPoint, object: nil)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        UIView.animateOut(withDuration: animationOut, animations: {
//            self.view.alpha = 1
//        }, completion: nil)
    }
    
    // Notifications sent on all location updates
    @objc func progressDidChange(_ notification: NSNotification) {
        // do not update if we are previewing instruction steps
        guard previewInstructionsView == nil else { return }
        
        let routeProgress = notification.userInfo![RouteController.NotificationUserInfoKey.routeProgressKey] as! RouteProgress
        let location = notification.userInfo![RouteController.NotificationUserInfoKey.locationKey] as! CLLocation
        
        // Add maneuver arrow
        if routeProgress.currentLegProgress.followOnStep != nil {
            mapView.addArrow(route: routeProgress.route, legIndex: routeProgress.legIndex, stepIndex: routeProgress.currentLegProgress.stepIndex + 1)
        } else {
            mapView.removeArrow()
        }
        
        // Update the top banner with progress updates
        instructionsBannerView.updateDistance(for: routeProgress.currentLegProgress.currentStepProgress)
        instructionsBannerView.monitorSpeedLimit(routeProgress: routeProgress)
        instructionsBannerView.isHidden = false
        
        handleMapCamera(routeProgress: routeProgress, location: location)
        
        resetETATimer()
        updateETA(routeProgress: routeProgress)
        previousProgress = routeProgress
    }
    
    @objc func removeTimer() {
        timer?.disarm()
        timer = nil
    }
    
    @objc func resetETATimer() {
        removeTimer()
        timer = MapboxCoreNavigation.DispatchTimer(countdown: .seconds(30), repeating: .seconds(30)) { [weak self] in
            self?.refreshETA()
        }
        timer?.arm()
    }
    
    func refreshETA() {
        guard let progress = previousProgress else { return }
        updateETA(routeProgress: progress)
    }
    
    func updateETA(routeProgress: RouteProgress) {
        guard let arrivalDate = NSCalendar.current.date(byAdding: .second, value: Int(routeProgress.durationRemaining), to: Date()) else { return }
        let arrivalTime = dateFormatter.string(from: arrivalDate)
        dateComponentsFormatter.unitsStyle = routeProgress.durationRemaining < 3600 ? .short : .abbreviated

        if routeProgress.durationRemaining < 60 {
            bottomView.mainLabel.text = "Arrived"
            let side = routeProgress.currentLegProgress.currentStep.maneuverDirection
            if side == .left {
                bottomView.subLabel.text = "On the left"
            } else if side == .right {
                bottomView.subLabel.text = "On the right"
            }
            return
        } else {
            bottomView.mainLabel.text = dateComponentsFormatter.string(from: routeProgress.durationRemaining)
            
            if routeProgress.durationRemaining < 5 {
                bottomView.subLabel.text = arrivalTime
            } else {
                let distance = distanceFormatter.string(from: routeProgress.distanceRemaining)
                bottomView.subLabel.text = "\(distance) • \(arrivalTime)"
            }
        }
    }
    
    func showTripView() {
        bottomView.expandContainer()

        if let waypoint = self.router.route.routeOptions.waypoints.last {
            self.instructionsBannerView.showEndDestination(waypoint: waypoint)
        }
    }
    
    @objc func updateInstructionsBanner(notification: NSNotification) {
        guard let routeProgress = notification.userInfo?[RouteController.NotificationUserInfoKey.routeProgressKey] as? RouteProgress else { return }
        instructionsBannerView.update(for: routeProgress.currentLegProgress.currentStepProgress.currentVisualInstruction)
    }

    // Fired when the user is no longer on the route.
    // Update the route on the map.
    @objc func rerouted(_ notification: NSNotification) {
        self.mapView.show([navigationService.route])
    }

    @objc func cancelButtonPressed() {
        delegate?.pushCheckController()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func checkInButtonPressed() {
        delegate?.startBooking()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func recenterMap(sender: UIButton) {
        tracksUserCourse = true
    }
    
    func contentInset(forOverviewing overviewing: Bool) -> UIEdgeInsets {
        let instructionBannerHeight: CGFloat = 300
        let bottomBannerHeight: CGFloat = 200
        
        // Inset by the safe area to avoid notches.
        var insets = mapView.safeAreaInsets
        insets.top += instructionBannerHeight
        insets.bottom += bottomBannerHeight
        
        if overviewing {
            insets = UIEdgeInsets(top: (insets.top + courseViewMinimumInsets), left: (insets.left + courseViewMinimumInsets), bottom: (insets.bottom + courseViewMinimumInsets), right: (insets.right + courseViewMinimumInsets))
            
            let routeLineWidths = MBRouteLineWidthByZoomLevel.compactMap { $0.value.constantValue as? Int }
            let width = CGFloat(routeLineWidths.max() ?? 0)
            insets = UIEdgeInsets(top: (insets.top + width), left: (insets.left + width), bottom: (insets.bottom + width), right: (insets.right + width))
        } else if mapView.tracksUserCourse {
            // Puck position calculation - position it just above the bottom of the content area.
            var contentFrame = mapView.bounds.inset(by: insets)

            // Avoid letting the puck go partially off-screen, and add a comfortable padding beyond that.
            let courseViewBounds = mapView.userCourseView.bounds
            // If it is not possible to position it right above the content area, center it at the remaining space.
            contentFrame = contentFrame.insetBy(dx: min(courseViewMinimumInsets + courseViewBounds.width / 2.0, contentFrame.width / 2.0),
                                                dy: min(courseViewMinimumInsets + courseViewBounds.height / 2.0, contentFrame.height / 2.0))
            assert(!contentFrame.isInfinite)

            let y = contentFrame.maxY
            let height = mapView.bounds.height
            insets.top = height - insets.bottom - 2 * (height - insets.bottom - y)
        }
        
        return insets
    }
    
    func addPreviewInstructions(step: RouteStep) {
        let route = navigationService.route
        
        // find the leg that contains the step, legIndex, and stepIndex
        guard let leg = route.legs.first(where: { $0.steps.contains(step) }),
            let legIndex = route.legs.firstIndex(of: leg),
            let stepIndex = leg.steps.firstIndex(of: step) else {
            return
        }
        
        // find the upcoming manuever step, and update instructions banner to show preview
        guard stepIndex + 1 < leg.steps.endIndex else { return }
        let maneuverStep = leg.steps[stepIndex + 1]
        updatePreviewBannerWith(step: step, maneuverStep: maneuverStep)
        
        // stop tracking user, and move camera to step location
        mapView.tracksUserCourse = false
        mapView.userTrackingMode = .none
        mapView.enableFrameByFrameCourseViewTracking(for: 1)
        mapView.setCenter(maneuverStep.maneuverLocation, zoomLevel: mapView.zoomLevel, direction: maneuverStep.initialHeading!, animated: true, completionHandler: nil)
        
        // add arrow to map for preview instruction
        mapView.addArrow(route: route, legIndex: legIndex, stepIndex: stepIndex + 1)
    }
    
    func updatePreviewBannerWith(step: RouteStep, maneuverStep: RouteStep) {
        // remove preview banner if it exists
        removePreviewInstruction()
        
        // grab the last instruction for step
        guard let instructions = step.instructionsDisplayedAlongStep?.last else { return }
        
        // create a StepInstructionsView and display that over the current instructions banner
        let previewInstructionsView = StepInstructionsView(frame: instructionsBannerView.frame)
//        previewInstructionsView.delegate = self
        previewInstructionsView.swipeable = true
        previewInstructionsView.backgroundColor = instructionsBannerView.backgroundColor
        view.addSubview(previewInstructionsView)
        
        // update instructions banner to show all information about this step
        previewInstructionsView.updateDistance(for: RouteStepProgress(step: step))
        previewInstructionsView.update(for: instructions)
        
        self.previewInstructionsView = previewInstructionsView
    }
    
    func removePreviewInstruction() {
        guard let view = previewInstructionsView else { return }
        view.removeFromSuperview()
        
        // reclaim the delegate, from the preview banner
//        instructionsBannerView.delegate = self
        
        // nil out both the view and index
        previewInstructionsView = nil
        previewStepIndex = nil
    }
}

extension MBNavigationViewController: StepsViewControllerDelegate {
    func didDismissStepsViewController(_ viewController: StepsViewController) {
        viewController.dismiss { [weak self] in
            self?.stepsViewController = nil
        }
    }
    
    func stepsViewController(_ viewController: StepsViewController, didSelect legIndex: Int, stepIndex: Int, cell: StepTableViewCell) {
        viewController.dismiss { [weak self] in
            self?.stepsViewController = nil
        }
    }
}
