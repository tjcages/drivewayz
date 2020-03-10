//
//  HostNotificationsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HandlePresentingNotifications {
    func presentingNotificationsDismissed()
    func moveToFinish()
}

class HostNotificationsView: UIViewController {

    var delegate: HandlePresentingNotifications?
    let center = UNUserNotificationCenter.current()
    var notificationsAllowed: Bool = false {
        didSet {
            if notificationsAllowed {
                bottomController.mainButton.backgroundColor = Theme.BLACK
                bottomController.mainButton.setTitleColor(Theme.WHITE, for: .normal)
                bottomController.mainButton.isUserInteractionEnabled = true
                bubbleArrow.alpha = 0
            } else {
                bottomController.mainButton.backgroundColor = Theme.LINE_GRAY
                bottomController.mainButton.setTitleColor(Theme.BLACK, for: .normal)
                bottomController.mainButton.isUserInteractionEnabled = false
                bubbleArrow.alpha = 1
            }
        }
    }
    
    lazy var gradientNewHeight: CGFloat = gradientHeight + 24
    lazy var minimizedHeight: CGFloat = 72
    var increaseMain: CGFloat = 52
    var width: CGFloat = 220
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()

    var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Allow notifications"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enable notifications to keep up \nto date with your spot"
        label.textColor = Theme.BLACK
        label.numberOfLines = 2
        label.font = Fonts.SSPRegularH3
        
        return label
    }()

    lazy var bottomController: HostOnboardingBottomView = {
        let controller = HostOnboardingBottomView()
        self.addChild(controller)
        controller.mainButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        controller.mainButton.setTitle("Finish Listing", for: .normal)
        controller.hostPoliciesLabel.text = "You can always change notification \npreferences from the host portal."
        
        return controller
    }()
    
    var hostGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "notificationGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz will only send necessary and important notifications."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 4
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.message = "You must enable notifications in settings to list."
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.verticalTriangle()
        view.centerTriangle()
        
        let string = "You must enable notifications in settings to list."
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        let settingsRange = (string as NSString).range(of: "settings")
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPSemiBoldH4, range: settingsRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.WHITE, range: settingsRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: Theme.WHITE, range: settingsRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: settingsRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.SSPRegularH4, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.WHITE, range: range)
        
        let settingsAttribute = [NSAttributedString.Key.myAttributeName: "Settings"]
        attributedString.addAttributes(settingsAttribute, range: settingsRange)
        
        view.label.attributedText = attributedString
//        view.alpha = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = false
        }
        
        view.clipsToBounds = false
        view.backgroundColor = Theme.WHITE
        
        NotificationCenter.default.addObserver(self, selector: #selector(openForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(textViewMethodToHandleTap(_:)))
        tap.delegate = self
        bubbleArrow.label.addGestureRecognizer(tap)

        setupViews()
        setupControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        openForeground()
    }
    
    var mainLabelBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        view.addSubview(backButton)
        
        switch device {
        case .iphone8:
            increaseMain += 6
            backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        case .iphoneX:
            backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        }

        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        container.topAnchor.constraint(equalTo: view.topAnchor, constant: gradientNewHeight).isActive = true
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        subLabel.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        subLabel.sizeToFit()
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        mainLabelBottomAnchor = mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -4)
            mainLabelBottomAnchor.isActive = true
        mainLabel.sizeToFit()
        
    }
    
    func setupControllers() {
        
        view.addSubview(bottomController.view)
        bottomController.view.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bottomController.view.heightAnchor.constraint(equalToConstant: bottomController.bottomHeight).isActive = true
        
        view.addSubview(hostGraphic)
        view.addSubview(informationLabel)
        
        hostGraphic.topAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        hostGraphic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hostGraphic.widthAnchor.constraint(equalToConstant: width).isActive = true
        if let image = hostGraphic.image {
            let scale = image.size.height/image.size.width
            hostGraphic.heightAnchor.constraint(equalToConstant: width * scale).isActive = true
        }
        
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        informationLabel.topAnchor.constraint(equalTo: hostGraphic.bottomAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(bubbleArrow)
        bubbleArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bubbleArrow.bottomAnchor.constraint(equalTo: bottomController.view.topAnchor, constant: 8).isActive = true
        bubbleArrow.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
    @objc func nextButtonPressed() {
        checkNotificationPreferences()
    }
    
    @objc func dismissController() {
        mainTypeState = .email
        delegate?.presentingNotificationsDismissed()
        dismiss(animated: true, completion: nil)
    }

}

extension HostNotificationsView {
    
    func checkNotificationPreferences() {
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async {
                    self.moveToSettings(message: "Please allow notifications to list your parking space. Drivewayz may need to contact you if there is an issue.")
                }
            } else {
                self.center.getNotificationSettings { (settings) in
                    if settings.authorizationStatus != .authorized {
                        DispatchQueue.main.async {
                            self.moveToSettings(message: "Please allow notifications to list your parking space. Drivewayz may need to contact you if there is an issue.")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.dismissController()
                            self.delegate?.moveToFinish()
                        }
                    }
                }
            }
        }
    }
    
    @objc func openForeground() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    self.notificationsAllowed = false
                }
            } else {
                DispatchQueue.main.async {
                    self.notificationsAllowed = true
                }
            }
        }
    }
    
}

extension HostNotificationsView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        mainTypeState = .email
        delegate?.presentingNotificationsDismissed()
    }
}

extension HostNotificationsView: UIGestureRecognizerDelegate {
    
    func moveToSettings(message: String) {
        let alertController = UIAlertController (title: "Enable notifications", message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @objc func textViewMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            // check if the tap location has a certain attribute
            let attributeName = NSAttributedString.Key.myAttributeName
            let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil)
            if let value = attributeValue as? String {
                if value == "Settings" {
                    moveToSettings(message: "Go to Settings to turn on notifications?")
                }
            }
        }
    }
    
}
