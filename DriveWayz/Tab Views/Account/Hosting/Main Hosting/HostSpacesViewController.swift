//
//  HostSpacesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostSpacesViewController: UIViewController {
    
    var delegate: handleHostingControllers?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var hostContainer: MySpacesViewController = {
        let controller = MySpacesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    lazy var hostingExpandedContainer: HostingExpandedViewController = {
        let controller = HostingExpandedViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.alpha = 0
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2

        setupViews()
    }
    
    var hostingExpandedTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 842)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(hostContainer.view)
        hostContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        hostContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        hostContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        hostContainer.view.heightAnchor.constraint(equalToConstant: 192).isActive = true
        let hostTap = UITapGestureRecognizer(target: self, action: #selector(hostingExpandedPressed))
        hostContainer.view.addGestureRecognizer(hostTap)
        
        self.view.addSubview(hostingExpandedContainer.view)
        hostingExpandedTopAnchor = hostingExpandedContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: phoneHeight)
            hostingExpandedTopAnchor.isActive = true
        hostingExpandedContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hostingExpandedContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        hostingExpandedContainer.view.heightAnchor.constraint(equalToConstant: phoneHeight + statusHeight).isActive = true
        hostingExpandedContainer.backButton.addTarget(self, action: #selector(returnExpandedPressed), for: .touchUpInside)
        
    }
    
    @objc func hostingExpandedPressed() {
        self.hostingExpandedTopAnchor.constant = -statusHeight
        self.delegate?.hideExitButton()
        self.delegate?.lightContentStatusBar()
        UIView.animate(withDuration: animationOut) {
            self.hostContainer.view.alpha = 0
            self.hostingExpandedContainer.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func returnExpandedPressed() {
        self.hostingExpandedTopAnchor.constant = phoneHeight
        self.scrollView.setContentOffset(.zero, animated: false)
        self.delegate?.bringExitButton()
        UIView.animate(withDuration: animationOut, animations: {
            self.hostContainer.view.alpha = 1
            self.hostingExpandedContainer.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.defaultContentStatusBar()
        }
    }

}


extension HostSpacesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        self.delegate?.handleScrollView(translation: translation)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        self.delegate?.handleEndDragging(translation: translation)
    }
    
}
