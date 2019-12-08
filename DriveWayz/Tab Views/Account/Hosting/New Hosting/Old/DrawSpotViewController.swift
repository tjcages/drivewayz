//
//  DrawSpotViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/5/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DrawSpotViewController: UIViewController {
    
    var delegate: handlePanoImages?
    
    var parkingLabel: UILabel = {
        let label = UILabel()
        label.text = "Make sure the parking space is clearly shown then press the button below to highlight"
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 3
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        switch device {
        case .iphone8:
            view.frame = CGRect(x: 0, y: 84, width: self.view.frame.width, height: self.view.frame.width)
        case .iphoneX:
            view.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.width)
        }
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var realImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width))
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Highlight parking area", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLUE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(highlightImage), for: .touchUpInside)
        
        return button
    }()
    
    var moveDotsController: MoveDotsViewController = {
        let controller = MoveDotsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var panoView: GMSPanoramaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setData(image: UIImage, lattitude: Double, longitude: Double) {
        
        self.view.addSubview(parkingLabel)
        parkingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: (parkingLabel.text?.height(withConstrainedWidth: phoneWidth - 48, font: Fonts.SSPRegularH2))! + 12).isActive = true
        switch device {
        case .iphone8:
            parkingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20).isActive = true
        case .iphoneX:
            parkingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4).isActive = true
        }
        
        panoView = GMSPanoramaView(frame: .zero)
        panoView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addSubview(panoView)
        imageView.sendSubviewToBack(panoView)
        imageView.addSubview(realImageView)
        panoView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        panoView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        panoView.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        panoView.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
    
        self.realImageView.image = image
        self.panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
        
        imageView.addSubview(moveDotsController.view)
        moveDotsController.view.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        moveDotsController.view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        moveDotsController.view.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        moveDotsController.view.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        
    }
    
    func setupViews() {
        
        self.view.addSubview(imageView)
        self.view.addSubview(confirmButton)
        confirmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        confirmButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        switch device {
        case .iphone8:
            confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        case .iphoneX:
            confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        }
        
    }
    
    @objc func highlightImage() {
        self.confirmButton.removeTarget(self, action: #selector(highlightImage), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmButtonPressed(sender:)), for: .touchUpInside)
        UIView.transition(with: self.parkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.parkingLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            self.confirmButton.setTitle("Confirm image", for: .normal)
            UIView.transition(with: self.parkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.parkingLabel.text = "Drag the corners of the highlight to outline the parking space and confirm image"
                self.moveDotsController.view.alpha = 1
            }, completion: nil)
        }
    }
    
    func removeHighlight() {
        self.confirmButton.removeTarget(self, action: #selector(confirmButtonPressed(sender:)), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(highlightImage), for: .touchUpInside)
        UIView.transition(with: self.parkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
            self.parkingLabel.text = ""
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.transition(with: self.parkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.parkingLabel.text = "Make sure the parking space is clearly shown then press the button below to highlight"
                self.moveDotsController.view.alpha = 0
                self.confirmButton.setTitle("Highlight parking area", for: .normal)
            }, completion: nil)
        }
    }
    
    func useGoogleMaps() {
        self.panoView.alpha = 1
        self.realImageView.alpha = 0
    }
    
    func useRegularImage() {
        self.panoView.alpha = 0
        self.panoView.removeFromSuperview()
        self.realImageView.alpha = 1
    }
    
    @objc func confirmButtonPressed(sender: UIButton) {
        self.confirmButton.removeTarget(self, action: #selector(confirmButtonPressed(sender:)), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(highlightImage), for: .touchUpInside)
        let image = self.imageView.takeScreenshot()
        self.delegate?.confirmedImage(image: image)
        delayWithSeconds(1) {
            self.moveDotsController.startPan()
            UIView.transition(with: self.parkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.parkingLabel.text = ""
                self.view.layoutIfNeeded()
            }) { (success) in
                UIView.transition(with: self.parkingLabel, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.parkingLabel.text = "Make sure the parking space is clearly shown then press the button below to highlight"
                    self.moveDotsController.view.alpha = 0
                    self.confirmButton.setTitle("Highlight parking area", for: .normal)
                }, completion: nil)
            }
        }
    }

}
