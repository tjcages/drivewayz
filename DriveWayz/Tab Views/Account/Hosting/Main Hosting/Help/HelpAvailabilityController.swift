//
//  HostHelpController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HelpAvailabilityController: UIViewController {
    
    var delegate: HostHelpDelegate?
    var mainColor: UIColor = Theme.PURPLE
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 2082
        controller.setExitButton()
        controller.scrollView.delegate = self
        controller.gradientContainer.backgroundColor = mainColor
        controller.gradientContainer.clipsToBounds = true
        controller.scrollView.alpha = 0
        
        return controller
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earn the way \nyou want"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH00
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Customize the availability of your \nspace or mark inactive whenever \nyou need it back."
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 3
        
        return label
    }()
    
    var learnButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 32
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var learnContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 201/255, green: 174/255, blue: 171/255, alpha: 1.0)
        
        return view
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "hostHelpAvailability")
        view.image = image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var informationController = HelpAvailabilityInformationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = mainColor
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gradientController.animateText(text: "Availability")
        delayWithSeconds(animationIn) {
            UIView.animate(withDuration: animationOut) {
                self.gradientController.scrollView.alpha = 1
            }
        }
    }
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        gradientController.scrollView.addSubview(mainLabel)
        gradientController.scrollView.addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: gradientController.scrollView.topAnchor, constant: 0).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        gradientController.scrollView.addSubview(learnContainer)
        learnContainer.anchor(top: nil, left: view.leftAnchor, bottom: gradientController.scrollView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -(phoneHeight - gradientController.gradientNewHeight), paddingRight: 0, width: 0, height: 132)
        
        learnContainer.addSubview(learnButton)
        learnContainer.addSubview(nextButton)

        learnButton.bottomAnchor.constraint(equalTo: learnContainer.bottomAnchor, constant: cancelBottomHeight + 16).isActive = true
        learnButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        learnButton.sizeToFit()

        nextButton.centerYAnchor.constraint(equalTo: learnButton.centerYAnchor).isActive = true
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 64, height: 64)
        
        gradientController.scrollView.addSubview(mainGraphic)
        mainGraphic.anchor(top: nil, left: view.leftAnchor, bottom: learnContainer.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -32, paddingRight: 0, width: 0, height: 0)
        mainGraphic.heightAnchor.constraint(equalTo: mainGraphic.widthAnchor, multiplier: 0.933).isActive = true
        
        gradientController.scrollView.addSubview(informationController.view)
        informationController.mainButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        informationController.view.anchor(top: learnContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: gradientController.scrollView.contentSize.height - phoneHeight + gradientController.gradientNewHeight)
        
    }
    
    @objc func nextButtonPressed() {
        gradientController.scrollView.setContentOffset(CGPoint(x: 0.0, y: phoneHeight - gradientController.gradientNewHeight), animated: true)
        scrollMinimized()
        UIView.animate(withDuration: animationOut) {
            self.gradientController.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.gradientController.mainLabel.textColor = Theme.WHITE
            self.gradientController.backButton.tintColor = Theme.WHITE
        }
    }
    
    @objc func backButtonPressed() {
        delegate?.removeDim()
        dismiss(animated: true) {
            
        }
    }

}

extension HelpAvailabilityController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientHeight - percent * 60
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            } else if translation <= -60 {
                gradientController.backButton.sendActions(for: .touchUpInside)
            } else if translation >= phoneHeight - gradientController.gradientNewHeight - 132 {
                if gradientController.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                    UIView.animate(withDuration: animationIn) {
                        self.gradientController.gradientContainer.backgroundColor = Theme.DARK_GRAY
                    }
                }
            } else {
                if gradientController.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                    UIView.animate(withDuration: animationIn) {
                        self.gradientController.gradientContainer.backgroundColor = self.mainColor
                    }
                }
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientHeight {
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
        gradientController.gradientHeightAnchor.constant = gradientHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gradientController.gradientContainer.backgroundColor = self.mainColor
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            if self.gradientController.scrollView.contentOffset.y >= phoneHeight - self.gradientController.gradientNewHeight - 132 {
                if self.gradientController.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                    self.gradientController.gradientContainer.backgroundColor = Theme.DARK_GRAY
                }
            } else {
                if self.gradientController.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                    self.gradientController.gradientContainer.backgroundColor = self.mainColor
                }
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
