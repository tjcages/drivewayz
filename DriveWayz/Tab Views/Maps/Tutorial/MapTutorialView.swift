//
//  MapTutorialView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class MapTutorialView: UIViewController {
    
    var delegate: handleMapTutorial?
    
    var dimViewHeight: CGFloat = 100.0
    var searchViewHeight: CGFloat = 100.0
    lazy var bottomHeight: CGFloat = -cancelBottomHeight + durationBottomController.buttonHeight + 16
    
    lazy var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.8)
        
        return view
    }()
    
    lazy var lightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search to start"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap the search bar and enter your destination to find the best private parking."
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 3
        
        return label
    }()
    
    var skipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to skip"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var recommendationButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(Theme.BLUE.withAlphaComponent(0.8), for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH3
        label.contentHorizontalAlignment = .left
        label.addTarget(self, action: #selector(recommendationPressed), for: .touchUpInside)
        
        return label
    }()
    
    var searchView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Parking near "
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Search")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        
        return view
    }()
    
    lazy var durationBottomController: DurationBottomView = {
        let controller = DurationBottomView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.parkNowButton.addTarget(self, action: #selector(parkNowPressed), for: .touchUpInside)
        controller.reserveSpotButton.addTarget(self, action: #selector(reservePressed), for: .touchUpInside)
        controller.view.alpha = 0
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: animationOut, animations: {
            self.skipLabel.alpha = 0
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delayWithSeconds(1) {
            UIView.animate(withDuration: animationOut, animations: {
                self.skipLabel.alpha = 1
            })
            delayWithSeconds(5) {
                if self.searchView.alpha == 1 {
                    self.animate()
                }
            }
        }
    }
    
    func setupViews() {
        
        view.addSubview(dimView)
        dimView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dimView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dimView.heightAnchor.constraint(equalToConstant: self.dimViewHeight).isActive = true
        
        view.addSubview(lightView)
        lightView.topAnchor.constraint(equalTo: dimView.topAnchor).isActive = true
        lightView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        subLabel.bottomAnchor.constraint(equalTo: dimView.bottomAnchor, constant: -32).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -8).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
    }
  
    func setupSearch() {
        
        view.addSubview(searchView)
        switch device {
        case .iphone8:
            searchView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: searchViewHeight - 8, paddingRight: 20, width: 0, height: 56)
        case .iphoneX:
            searchView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: searchViewHeight, paddingRight: 20, width: 0, height: 56)
        }
        
        searchView.addSubview(searchLabel)
        view.addSubview(recommendationButton)
        
        searchLabel.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        recommendationButton.leftAnchor.constraint(equalTo: searchLabel.rightAnchor, constant: 4).isActive = true
        recommendationButton.centerYAnchor.constraint(equalTo: searchLabel.centerYAnchor).isActive = true
        recommendationButton.sizeToFit()
        
        searchView.addSubview(searchButton)
        searchButton.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -8).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 10).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        
        searchView.addSubview(loadingLine)
        loadingLine.anchor(top: nil, left: searchView.leftAnchor, bottom: searchView.bottomAnchor, right: searchView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 3)
        
        view.addSubview(durationBottomController.view)
        switch device {
        case .iphone8:
            durationBottomController.view.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -4, paddingRight: 0, width: 0, height: bottomHeight)
        case .iphoneX:
            durationBottomController.view.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 0, height: bottomHeight)
        }
        
        view.addSubview(skipLabel)
        skipLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        skipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipLabel.sizeToFit()
        
    }
    
    func animate() {
        UIView.animate(withDuration: animationIn, animations: {
            self.view.alpha = 0
        }) { (success) in
            self.mainLabel.text = "Set your time"
            self.subLabel.text = "Park now or reserve your private spot. \nYou can always entend time later."
            self.searchView.alpha = 0
            self.recommendationButton.alpha = 0
            self.durationBottomController.view.alpha = 1
            delayWithSeconds(animationIn, completion: {
                UIView.animate(withDuration: animationIn, animations: {
                    self.view.alpha = 1
                }, completion: { (success) in
                    delayWithSeconds(1, completion: {
                        UIView.animate(withDuration: animationOut, animations: {
                            self.skipLabel.alpha = 1
                        })
                        delayWithSeconds(5) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                })
            })
        }
    }
    
    @objc func searchPressed() {
        delegate?.searchPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func recommendationPressed() {
        delegate?.recommendationPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func parkNowPressed() {
        delegate?.parkNowPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reservePressed() {
        delegate?.reservePressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchView.alpha == 1 {
            animate()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
