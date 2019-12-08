//
//  HostPortalController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HandleHostPortal {
    func controllerDismissed()
}

protocol HostHelpDelegate {
    func removeDim()
    func changeDimLevel(amount: CGFloat)
}

class HostPortalController: UIViewController {
    
    var delegate: moveControllers?
    var hostListing: ParkingSpots? {
        didSet {
            if let parking = hostListing {
                notifications += parking.Notifications
            }
        }
    }
    
    let gradientNewHeight: CGFloat = gradientHeight + 196
    
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 72
    
    // Notification variable to hold all data and string to specify section
    var notifications: [HostNotifications] = [] {
        didSet {
            self.notifications = self.notifications.sorted { $0.timestamp! > $1.timestamp! }
            
            // Reload data each time our observer appends a new Notification value
            self.notificationsTable.reloadData()
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 1200
        controller.scrollView.isHidden = true
        controller.setExitButton()
        controller.gradientNewHeight += 80
        
        return controller
    }()
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Good morning"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.alpha = 0
        
        return label
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Host Portal"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH1
        label.alpha = 0
        
        return label
    }()
    
    var tabView: PortalTabsView = {
        let view = PortalTabsView()
        view.availabilityButton.addTarget(self, action: #selector(availabilityPressed), for: .touchUpInside)
        view.availabilityLabel.addTarget(self, action: #selector(availabilityPressed), for: .touchUpInside)
        view.earningsButton.addTarget(self, action: #selector(earningsPressed), for: .touchUpInside)
        view.earningsLabel.addTarget(self, action: #selector(earningsPressed), for: .touchUpInside)
        view.accountButton.addTarget(self, action: #selector(accountPressed), for: .touchUpInside)
        view.accountLabel.addTarget(self, action: #selector(accountPressed), for: .touchUpInside)
        
        return view
    }()
    
    var helpIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "filledHelpIcon")
        button.setImage(image, for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(informationPressed), for: .touchUpInside)
        
        return button
    }()
    
    var helpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Help", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.alpha = 0
        button.addTarget(self, action: #selector(helpPressed), for: .touchUpInside)
        
        return button
    }()
    
    var bannerView: PortalBannerView = {
        let view = PortalBannerView()
        view.alpha = 0
        
        return view
    }()
    
    lazy var notificationsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(NotificationsCell.self, forCellReuseIdentifier: "cellId")
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: gradientNewHeight, right: 0)
        view.separatorStyle = .none
        view.alpha = 0
        
        
        return view
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
        return view
    }()
    
    // Observe Notifications data
    func observeData() {
        gradientController.loadingLine.startAnimating()
        notifications = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("Hosting Spots")
        ref.observe(.childAdded) { (snapshot) in
            if let key = snapshot.value as? String {
                let hostRef = Database.database().reference().child("ParkingSpots").child(key)
                hostRef.observe(.value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let parking = ParkingSpots(dictionary: dictionary)
                        
                        self.hostListing = parking
                        self.gradientController.loadingLine.endAnimating()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTable.delegate = self
        notificationsTable.dataSource = self
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(setData), name: UIApplication.significantTimeChangeNotification, object: nil)
        
        setupViews()
        setupControllers()
        
        observeData()
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controllerDismissed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabView.dismiss()
        UIView.animate(withDuration: animationIn) {
            self.gradientController.backButton.alpha = 0
            self.helpIcon.alpha = 0
            self.helpButton.alpha = 0
            self.bannerView.alpha = 0
            self.notificationsTable.alpha = 0
            self.greetingLabel.alpha = 0
            self.mainLabel.alpha = 0
        }
    }
    
    var paymentHeightAnchor: NSLayoutConstraint!
    var vehicleHeightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(mainLabel)
        gradientController.view.addSubview(greetingLabel)
        gradientController.view.addSubview(tabView)
        
        greetingLabel.topAnchor.constraint(equalTo: gradientController.backButton.bottomAnchor, constant: 24).isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        greetingLabel.sizeToFit()
        
        mainLabel.bottomAnchor.constraint(equalTo: tabView.topAnchor, constant: -20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        tabView.anchor(top: greetingLabel.bottomAnchor, left: gradientController.view.leftAnchor, bottom: gradientController.gradientContainer.bottomAnchor, right: gradientController.view.rightAnchor, paddingTop: 56, paddingLeft: 0, paddingBottom: -8, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(helpIcon)
        view.addSubview(helpButton)
        
        helpIcon.anchor(top: nil, left: nil, bottom: greetingLabel.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 20, width: 32, height: 32)
        
        helpButton.rightAnchor.constraint(equalTo: helpIcon.leftAnchor, constant: -12).isActive = true
        helpButton.bottomAnchor.constraint(equalTo: helpIcon.bottomAnchor).isActive = true
        helpButton.sizeToFit()
        
    }
    
    func setupControllers() {
        
        view.addSubview(bannerView)
        bannerView.topAnchor.constraint(equalTo: gradientController.gradientContainer.bottomAnchor).isActive = true
        bannerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bannerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(notificationsTable)
        notificationsTable.anchor(top: bannerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(dimView)
        
    }
    
    @objc func helpPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimView.alpha = 0.7
        }) { (success) in
            let controller = HelpMenuController()
            controller.optionIndex = 0
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func informationPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            self.dimView.alpha = 0.7
        }) { (success) in
            let controller = HelpPortalController()
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.presentationController?.delegate = controller
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    @objc func availabilityPressed() {
        let controller = HostAvailabilityController()
        controller.delegate = self
        controller.hostListing = hostListing
        expandController(controller: controller)
    }
    
    @objc func earningsPressed() {
        let controller = HostEarningsController()
        controller.delegate = self
        controller.hostListing = hostListing
        expandController(controller: controller)
    }
    
    @objc func accountPressed() {
        let controller = HostAccountController()
        controller.delegate = self
        controller.hostListing = hostListing
        expandController(controller: controller)
    }
    
    func expandController(controller: UIViewController) {
        tabView.dismiss()
        gradientController.gradientHeightAnchor.constant = gradientHeight
        UIView.animate(withDuration: animationIn, animations: {
            self.bannerView.alpha = 0
            self.notificationsTable.alpha = 0
            self.gradientController.backButton.alpha = 0
            self.greetingLabel.alpha = 0
            self.mainLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            let navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            navigation.modalTransitionStyle = .crossDissolve
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
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
    
    func check(time: Date) -> String {
        let hour = Calendar.current.component(.hour, from: time)
        
        switch hour {
        case 6..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
        }
    }
    
    @objc func backButtonPressed() {
        self.delegate?.dismissActiveController()
        self.dismiss(animated: true) {
            
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension HostPortalController: HandleHostPortal, HostHelpDelegate {
    
    func controllerDismissed() {
        gradientController.animateBackButton()
        tabView.animate()
        gradientController.gradientHeightAnchor.constant = gradientNewHeight
        UIView.animate(withDuration: animationIn) {
            self.helpIcon.alpha = 1
            self.helpButton.alpha = 1
            self.bannerView.alpha = 1
            self.notificationsTable.alpha = 1
            self.greetingLabel.alpha = 1
            self.mainLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func removeDim() {
        UIView.animate(withDuration: animationOut) {
            self.dimView.alpha = 0
        }
    }
    
    func changeDimLevel(amount: CGFloat) {
        UIView.animate(withDuration: animationOut) {
            self.dimView.alpha = amount
        }
    }
    
}

extension HostPortalController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NotificationsHeader()
        view.backgroundColor = Theme.WHITE
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if notifications.count <= 4 {
            return notifications.count
//        } else {
//            return 5
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotificationsCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        if indexPath.row == 0 || indexPath.row == 1 {
            cell.backgroundColor = Theme.HOST_BLUE.withAlphaComponent(0.5)
        } else {
            cell.backgroundColor = Theme.WHITE
        }
        
        if notifications.count > indexPath.row {
            let notification = notifications[indexPath.row]
            cell.notification = notification
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension HostPortalController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 260 {
                let percent = translation/260
                gradientController.gradientHeightAnchor.constant = gradientNewHeight - percent * 260
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if percent >= 0 && percent <= 0.3 {
                    let percentage = percent/0.3
                    tabView.minimize(percent: percentage)
                } else if percent > 0.3 {
                    if tabView.alpha == 1 {
                        tabView.dismiss()
                    }
                }
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientNewHeight {
                scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        tabView.animate()
        gradientController.gradientHeightAnchor.constant = gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        tabView.dismiss()
        gradientController.gradientHeightAnchor.constant = gradientNewHeight - 260
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
