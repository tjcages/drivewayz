//
//  HostPriceView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HostPriceDelegate {
    func dimBackground()
    func removeDim()
}

var parkingCost: Double?

class HostPriceView: UIViewController {

    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = ""
        controller.setBackButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 900
        controller.scrollView.delegate = self
        
        return controller
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var sliderController: PriceSliderView = {
        let controller = PriceSliderView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var additionalController: PriceAdditionalView = {
        let controller = PriceAdditionalView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BACKGROUND_GRAY.withAlphaComponent(0), bottomColor: Theme.BACKGROUND_GRAY)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: abs(cancelBottomHeight * 2) + 16)
        background.zPosition = 10
        view.layer.addSublayer(background)
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    let paging: ProgressPagingDisplay = {
        let view = ProgressPagingDisplay()
        view.changeProgress(index: 3)
        view.alpha = 0
        
        return view
    }()
    
    // Rest of the Host Signup process
    var hostVerifyController = HostVerifyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(progressTapped))
        paging.addGestureRecognizer(tap)

        setupViews()
        setupControllers()
    }
    
    @objc func progressTapped() {
        let controller = HostProgressView()
        controller.shouldDismiss = true
        controller.progressController.fourthStep()
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gradientController.scrollView.scrollToTop(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text == "" {
             gradientController.animateText(text: "Select a price")
             delayWithSeconds(animationOut) {
                 self.gradientController.setSublabel(text: "Determine the hourly cost")
                 UIView.animate(withDuration: animationIn) {
                    self.paging.alpha = 1
                    self.view.layoutIfNeeded()
                 }
                 if self.nextButton.tintColor != Theme.WHITE {
                     self.showNextButton()
                 }
                 self.animate()
             }
         } else {
            removeDim()
            showNextButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gradientController.scrollView.scrollToTop(animated: true)
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        view.addSubview(gradientController.view)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.view.addSubview(paging)
        paging.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paging.centerYAnchor.constraint(equalTo: gradientController.backButton.centerYAnchor).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 86).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(blurView)
        blurView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: abs(cancelBottomHeight * 2) + 16)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
    }
    
    var sliderHeightAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        gradientController.scrollView.addSubview(sliderController.view)
        sliderController.view.anchor(top: gradientController.scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        sliderHeightAnchor = sliderController.view.heightAnchor.constraint(equalToConstant: 208)
            sliderHeightAnchor.isActive = true
        
        gradientController.scrollView.addSubview(additionalController.view)
        additionalController.view.anchor(top: sliderController.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        additionalController.informationController.delegate = self

        view.addSubview(dimView)
    }
    
    @objc func nextButtonPressed() {
        mainTypeState = .message
        hideNextButton(completion: {})
        delayWithSeconds(animationOut + animationIn/2) {
            self.dimBackground()
            
            if let price = self.sliderController.hourLabel.text {
                let number = Double(price.replacingOccurrences(of: "$", with: ""))
                parkingCost = number
            }
            
            self.navigationController?.pushViewController(self.hostVerifyController, animated: true)
        }
    }
    
    @objc func backButtonPressed() {
        mainTypeState = .availability
        navigationController?.popViewController(animated: true)
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
                if mainTypeState == .pictures {
                    self.nextButton.tintColor = Theme.BLACK
                } else {
                    self.nextButton.tintColor = Theme.WHITE
                }
            }) { (success) in
                self.nextButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideNextButton(completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.BLACK
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                completion()
            }
        }
    }
    
    func animate() {
        UIView.animate(withDuration: animationOut, animations: {
            self.sliderController.view.alpha = 1
            self.additionalController.view.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}

extension HostPriceView: HostPriceDelegate {
    
    func dimBackground() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0.7
        }
    }
    
    func removeDim() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0
        }
    }

    
}

extension HostPriceView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight - (gradientController.gradientNewHeight - gradientHeight + 60) * percent
                gradientController.subLabelBottom.constant = gradientController.subHeight * percent
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if percent >= 0 && percent <= 0.3 {
                    let percentage = percent/0.3
                    gradientController.subLabel.alpha = 1 - 1 * percentage
                    paging.alpha = 1 - 1 * percentage
                } else if percent >= 0 {
                    gradientController.subLabel.alpha = 0
                    paging.alpha = 0
                }
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientController.gradientNewHeight {
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
        gradientController.subLabelBottom.constant = 0
        gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gradientController.subLabel.alpha = 1
            self.paging.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.subLabelBottom.constant = gradientController.subHeight
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.gradientController.subLabel.alpha = 0
            self.paging.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
