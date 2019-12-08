//
//  HelpPortalController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/19/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HelpPortalController: UIViewController {
    
    var delegate: HostHelpDelegate?
    lazy var gradientNewHeight: CGFloat = gradientHeight + 24
        
    var firstBackground: UIColor = Theme.PURPLE
    var secondBackground: UIColor = UIColor(red: 66/255, green: 67/255, blue: 106/255, alpha: 1.0)
    var thirdBackground: UIColor = Theme.HOST_RED
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var pagingView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.decelerationRate = .fast
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    let firstController: HostOnboardingView = {
        let controller = HostOnboardingView()
        controller.index = 0
        
        return controller
    }()
    
    let secondController: HostOnboardingView = {
        let controller = HostOnboardingView()
        controller.index = 1
        
        return controller
    }()
    
    let thirdController: HostOnboardingView = {
        let controller = HostOnboardingView()
        controller.index = 2
        controller.mainLabel.textColor = Theme.DARK_GRAY
        controller.subLabel.textColor = Theme.DARK_GRAY
        
        return controller
    }()
    
    let paging: HorizontalPagingDisplay = {
        let view = HorizontalPagingDisplay()
        view.leftSelectionLine.backgroundColor = Theme.WHITE
        view.centerSelectionLine.backgroundColor = Theme.WHITE
        view.rightSelectionLine.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var bottomController: HostOnboardingBottomView = {
        let controller = HostOnboardingBottomView()
        self.addChild(controller)
        controller.mainButton.setTitle("Let's Get Started", for: .normal)
        controller.mainButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        
        view.backgroundColor = Theme.PURPLE
        
        pagingView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(exitNewListing), name: NSNotification.Name(rawValue: "exitNewListing"), object: nil)

        setupViews()
        setupScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: animationIn) {
            self.exitButton.alpha = 1
        }
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(container)
        container.addSubview(pagingView)
        
        container.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(exitButton)
        switch device {
        case .iphone8:
            exitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        case .iphoneX:
            exitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        }
        
        container.addSubview(paging)
        paging.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paging.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 53).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        view.addSubview(bottomController.view)
        bottomController.view.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bottomController.view.heightAnchor.constraint(equalToConstant: bottomController.bottomHeight).isActive = true
        
    }
    
    func setupScroll() {
        
        pagingView.contentSize = CGSize(width: phoneWidth * 3, height: 100)
        pagingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        pagingView.addSubview(firstController.view)
        pagingView.addSubview(secondController.view)
        pagingView.addSubview(thirdController.view)
    
        firstController.view.anchor(top: view.topAnchor, left: pagingView.leftAnchor, bottom: bottomController.view.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth, height: 0)
        
        secondController.view.anchor(top: view.topAnchor, left: firstController.view.rightAnchor, bottom: bottomController.view.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth, height: 0)
        
        thirdController.view.anchor(top: view.topAnchor, left: secondController.view.rightAnchor, bottom: bottomController.view.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth, height: 0)
        
    }
    
    @objc func mainButtonPressed() {
        dismissController()
    }
    
    @objc func dismissController() {
        delegate?.removeDim()
        dismiss(animated: true) {
            
        }
    }
    
    @objc func exitNewListing() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension HelpPortalController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismissController()
    }
}

// Change the Paging control as user scrolls
extension HelpPortalController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        var percentage = translation/phoneWidth
        paging.changeScroll(percentage: percentage)
        
        if percentage < 0 {
            firstController.view.alpha = 1
        } else if percentage >= 0 && percentage <= 1.0 {
            firstController.view.alpha = 1 - 1 * percentage
            secondController.view.alpha = 0 + 1 * percentage
            
            let color = fadeFromColor(fromColor: firstBackground, toColor: secondBackground, withPercentage: percentage)
            view.backgroundColor = color
            
            if percentage == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.view.backgroundColor = self.firstBackground
                    self.exitButton.tintColor = Theme.WHITE
                    self.paging.lightPaging()
                }
            } else if percentage == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.view.backgroundColor = self.secondBackground
                    self.exitButton.tintColor = Theme.WHITE
                    self.paging.lightPaging()
                }
            }
        } else if percentage > 1.0 && percentage <= 2.0 {
            percentage -= 1.0
            secondController.view.alpha = 1 - 1 * percentage
            thirdController.view.alpha = 0 + 1 * percentage
            
            let color = fadeFromColor(fromColor: secondBackground, toColor: thirdBackground, withPercentage: percentage)
            view.backgroundColor = color
            let tint = fadeFromColor(fromColor: Theme.WHITE, toColor: Theme.DARK_GRAY, withPercentage: percentage)
            exitButton.tintColor = tint
            paging.changeTint(color: tint)
            
            if percentage == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.view.backgroundColor = self.thirdBackground
                    self.exitButton.tintColor = Theme.DARK_GRAY
                    self.paging.darkPaging()
                }
            }
        } else if percentage >= 2.0 {
            thirdController.view.alpha = 1
        }
    }
    
    func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0

        // Get the RGBA values from the colours
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)

        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0

        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        // Calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed;
        let green = (toGreen - fromGreen) * withPercentage + fromGreen;
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue;
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha;

        // Return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

