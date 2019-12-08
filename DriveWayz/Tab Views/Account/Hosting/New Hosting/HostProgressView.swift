//
//  HostProgressView=.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

enum MainTypeState {
    case main
    case secondary
    case numbers
    case amenities
    case location
    case map
    case pictures
    case availability
    case price
    case message
    case email
    case notifications
    case finish
}

var mainTypeState: MainTypeState = .main

class HostProgressView: UIViewController {
    
    lazy var gradientNewHeight: CGFloat = gradientHeight + 24
    lazy var minimizedHeight: CGFloat = 72
    var increaseMain: CGFloat = 52
    
    var shouldDismiss: Bool = false
    
    let dim = DimmingView()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()

    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "List your spot"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Follow these easy steps to list \nyour parking space"
        label.textColor = Theme.DARK_GRAY
        label.numberOfLines = 2
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var progressController: ProgressBarView = {
        let controller = ProgressBarView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.detailsController.mainButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return controller
    }()
    
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(exitNewHost), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = false
        }
        
        view.clipsToBounds = false
        view.backgroundColor = Theme.WHITE
        
        scrollView.delegate = self

        setupViews()
        setupControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if nextButton.tintColor != Theme.WHITE {
            showNextButton()
        }
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var mainLabelBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(exitButton)
        
        switch device {
        case .iphone8:
            increaseMain += 6
            backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        case .iphoneX:
            backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        }
        
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerHeightAnchor = container.topAnchor.constraint(equalTo: view.topAnchor, constant: gradientNewHeight)
            containerHeightAnchor.isActive = true
        
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
    
    var nextButtonRightAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(progressController.view)
        progressController.view.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 70, height: 70)
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
    }
    
    @objc func nextButtonPressed() {
        hideNextButton {
            if !self.shouldDismiss {
                let controller = HostListingController()
                let navigation = UINavigationController(rootViewController: controller)
                navigation.modalPresentationStyle = .overFullScreen
                navigation.navigationBar.isHidden = true
                navigation.interactivePopGestureRecognizer?.isEnabled = false
                self.dim.present(navigation, animated: true) {
                    controller.onDoneBlock = { result in
                        self.dismiss(animated: true, completion: nil)
                        self.showNextButton()
                    }
                }
            } else {
                self.dismissController()
            }
        }
    }
    
    func showNextButton() {
        nextButton.alpha = 1
        nextButtonRightAnchor.constant = phoneWidth/2
        view.layoutIfNeeded()
        
        nextButtonRightAnchor.constant = -20
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.nextButton.tintColor = Theme.WHITE
                self.exitButton.alpha = 1
            }) { (success) in
                //
            }
        }
    }
    
    func hideNextButton(completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.DARK_GRAY
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                if !self.shouldDismiss {
                    self.presentDim()
                }
                completion()
            }
        }
    }
    
    func presentDim() {
        self.dim.modalTransitionStyle = .crossDissolve
        self.dim.modalPresentationStyle = .overFullScreen
        self.present(self.dim, animated: true, completion: nil)
    }
    
    @objc func dismissController() {
        hideNextButton(completion: {})
        dismiss(animated: true, completion: nil)
    }

}

extension HostProgressView: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        scrollExpanded()
        scrollView.setContentOffset(.zero, animated: true)
        hideNextButton(completion: {})
    }
}

extension HostProgressView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < (gradientNewHeight - minimizedHeight) {
                let percent = translation/(gradientNewHeight - minimizedHeight)
                containerHeightAnchor.constant = gradientNewHeight - percent * (gradientNewHeight - minimizedHeight)
                mainLabelBottomAnchor.constant = -4 + increaseMain * percent
                mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if percent >= 0 && percent <= 0.3 {
                    let percentage = percent/0.3
                    subLabel.alpha = 1 - 1 * percentage
                } else if percent >= 0 {
                    subLabel.alpha = 0
                }
            } else if translation <= -60 {
                backButton.sendActions(for: .touchUpInside)
            }
        } else {
            if translation < 0 && self.containerHeightAnchor.constant != gradientNewHeight {
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
        containerHeightAnchor.constant = gradientNewHeight
        mainLabelBottomAnchor.constant = -4
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.subLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        containerHeightAnchor.constant = gradientNewHeight - (gradientNewHeight - minimizedHeight)
        mainLabelBottomAnchor.constant = increaseMain - 4
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.subLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    @objc func exitNewHost() {
        let alert = UIAlertController(title: "Are you sure you want to exit?", message: "Your information will not be saved.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (success) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "exitNewListing"), object: nil)
            mainTypeState = .main
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}

class DimmingView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.DARK_GRAY
    }
}
