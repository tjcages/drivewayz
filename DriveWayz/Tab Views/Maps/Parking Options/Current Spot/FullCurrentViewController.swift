//
//  FullCurrentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class FullCurrentViewController: UIViewController {
    
    var delegate: handleParkingImageHeight?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var hostMessage: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "A secure and affordable parking spot in the heart of downtown Boulder. A quick 5 minute walk to Pearl St. makes this a great location whether you are shopping for the day or have a meeting in the busy area."
        label.font = Fonts.SSPRegularH5
        label.backgroundColor = UIColor.clear
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    lazy var currentAmenitiesController: CurrentAmenitiesViewController = {
        let controller = CurrentAmenitiesViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self
        
        setupViews()
    }
    
    var blackViewHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 940)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(hostMessage)
        hostMessage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18).isActive = true
        hostMessage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        hostMessage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -22).isActive = true
        hostMessage.heightAnchor.constraint(equalToConstant: hostMessage.text.height(withConstrainedWidth: self.view.frame.width - 48, font: Fonts.SSPRegularH5) + 24).isActive = true
        
        scrollView.addSubview(currentAmenitiesController.view)
        currentAmenitiesController.view.topAnchor.constraint(equalTo: hostMessage.bottomAnchor, constant: 12).isActive = true
        currentAmenitiesController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentAmenitiesController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        currentAmenitiesController.view.heightAnchor.constraint(equalToConstant: 48).isActive = true

        scrollView.addSubview(spacerView)
        spacerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        spacerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        spacerView.topAnchor.constraint(equalTo: currentAmenitiesController.view.bottomAnchor, constant: 24).isActive = true
        spacerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
}

extension FullCurrentViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        let translation = scrollView.contentOffset.y
        if translation > 0 && translation <= 160 {
            self.delegate?.parkingImageScrolled(translation: translation)
        } else if translation > 160 {
            
        } else {
            self.delegate?.parkingImageScrolled(translation: 0)
        }
    }
    
}
