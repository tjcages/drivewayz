//
//  HostSpacesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class OldHostSpacesViewController: UIViewController {
    
    var delegate: handleHostingControllers?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Spaces"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPBoldH1
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var hostContainer: MySpacesViewController = {
        let controller = MySpacesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var expandedController = HostingExpandedViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        setupViews()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        self.view.addSubview(gradientContainer)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 842)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
                gradientHeightAnchor.isActive = true
            self.scrollView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 180)
                gradientHeightAnchor.isActive = true
            self.scrollView.contentInset = UIEdgeInsets(top: 180, left: 0, bottom: 0, right: 0)
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        scrollView.addSubview(hostContainer.view)
        hostContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 4).isActive = true
        hostContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        hostContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        hostContainer.view.heightAnchor.constraint(equalToConstant: 192).isActive = true
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(hostingExpandedPressed))
        hostContainer.view.addGestureRecognizer(hostTap)
        
    }
    
    @objc func hostingExpandedPressed() {
        self.scrollView.setContentOffset(.zero, animated: true)
        let navigation = UINavigationController(rootViewController: expandedController)
        navigation.navigationBar.isHidden = true
        self.present(navigation, animated: true, completion: nil)
    }

}


extension OldHostSpacesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 160
        case .iphoneX:
            totalHeight = 180
        }
        if translation > 0 && translation < 80 {
            let percent = translation/80
            self.gradientHeightAnchor.constant = totalHeight - percent * 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            if self.gradientContainer.backgroundColor == Theme.DARK_GRAY {
                self.scrollExpanded()
                self.delegate?.defaultContentStatusBar()
            }
        } else if translation >= 80 {
            self.gradientHeightAnchor.constant = totalHeight - 80
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            if self.gradientContainer.backgroundColor != Theme.DARK_GRAY {
                self.scrollMinimized()
            }
        } else if translation <= 0 {
            if mainLabel.alpha == 1 {
                self.gradientHeightAnchor.constant = totalHeight
                self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 75 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        self.delegate?.defaultContentStatusBar()
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 160
        case .iphoneX:
            self.gradientHeightAnchor.constant = 180
        }
        self.resetScrolls()
        UIView.animate(withDuration: animationIn, animations: {
            self.gradientContainer.backgroundColor = UIColor.clear
            self.mainLabel.textColor = Theme.DARK_GRAY
            self.view.layoutIfNeeded()
        }) { (success) in
            self.resetScrolls()
        }
    }
    
    func resetScrolls() {
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func scrollMinimized() {
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationIn) {
            self.gradientContainer.backgroundColor = Theme.DARK_GRAY
            self.mainLabel.textColor = Theme.WHITE
        }
    }
    
}
