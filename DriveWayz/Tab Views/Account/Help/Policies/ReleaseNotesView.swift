//
//  ReleaseNotesView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ReleaseNotesView: UIViewController {
    
    var notes: String? {
        didSet {
            if let notes = self.notes {
                let text = notes.replacingOccurrences(of: "$n$", with: "\n")
                subLabel.text = text
            }
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = "Drivewayz"
        controller.setBackButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 1200
        controller.scrollView.isHidden = true
        
        return controller
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY

        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Release Notes"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.numberOfLines = 100
        
        return label
    }()
    
    var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ver. 3.145"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        scrollView.delegate = self

        setupViews()
        getVersionNumber()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gradientController.animateBackButton()
    }
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(scrollView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1200)
        scrollView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(container)
        scrollView.addSubview(mainLabel)
        scrollView.addSubview(subLabel)
        scrollView.addSubview(versionLabel)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        mainLabel.sizeToFit()
        
        container.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: mainLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 0, width: 0, height: 0)
        
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 32).isActive = true
        subLabel.sizeToFit()
        
        versionLabel.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        versionLabel.sizeToFit()
        
    }
    
    func getVersionNumber() {
        //First get the nsObject by defining as an optional anyObject
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let build = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Ver. " + version + "." + build
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension ReleaseNotesView: UIScrollViewDelegate {
    
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
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
