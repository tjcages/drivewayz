//
//  CurrentParkingController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentParkingController: UIViewController {
    
    var bottomAnchor: CGFloat = -8
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        button.alpha = 0
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    lazy var imageView: ImageZoomView = {
        let image = UIImage(named: "photoTutorial3")
        let view = ImageZoomView(frame: CGRect(x: 0, y: 0, width: phoneWidth - 16, height: phoneWidth - 16), image: image!)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var profileIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookingProfile")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Special Instructions"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var instructionsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Directly off a major road in Point Loma! From this location…"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 2
        
        return label
    }()
    
    var moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See more", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var spotIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseArrive")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Spot Number"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var spotText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "#10"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var line2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var gateIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "purchaseLock")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var gateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gate Code"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var gateText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2345"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()
    
    var parkInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GRAY_WHITE.withAlphaComponent(0.6)
        button.layer.cornerRadius = 12
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.setTitle("Park within the blue square", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 178)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)

        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: animationOut) {
            self.exitButton.alpha = 1
            self.exitButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        exitButton.alpha = 0
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(exitButton)
        
        exitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        }
        
        view.addSubview(container)
        container.addSubview(gateIcon)
        container.addSubview(gateLabel)
        container.addSubview(gateText)
        
        gateIcon.anchor(top: nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 16, height: 16)
        
        gateLabel.leftAnchor.constraint(equalTo: gateIcon.rightAnchor, constant: 20).isActive = true
        gateLabel.centerYAnchor.constraint(equalTo: gateIcon.centerYAnchor).isActive = true
        gateLabel.sizeToFit()
        
        gateText.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        gateText.centerYAnchor.constraint(equalTo: gateIcon.centerYAnchor).isActive = true
        gateText.sizeToFit()
        
        container.addSubview(line2)
        line2.anchor(top: nil, left: gateLabel.leftAnchor, bottom: gateIcon.topAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        container.addSubview(spotIcon)
        container.addSubview(spotLabel)
        container.addSubview(spotText)
        
        spotIcon.anchor(top: nil, left: container.leftAnchor, bottom: line2.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 16, height: 16)
        
        spotLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 20).isActive = true
        spotLabel.centerYAnchor.constraint(equalTo: spotIcon.centerYAnchor).isActive = true
        spotLabel.sizeToFit()
        
        spotText.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        spotText.centerYAnchor.constraint(equalTo: spotIcon.centerYAnchor).isActive = true
        spotText.sizeToFit()
        
        container.addSubview(line)
        line.anchor(top: nil, left: spotLabel.leftAnchor, bottom: spotIcon.topAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 1)
        
        container.addSubview(profileIcon)
        container.addSubview(instructionsLabel)
        container.addSubview(instructionsText)
        container.addSubview(moreButton)
        
        moreButton.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -16).isActive = true
        moreButton.leftAnchor.constraint(equalTo: instructionsLabel.leftAnchor).isActive = true
        moreButton.sizeToFit()
        
        instructionsText.bottomAnchor.constraint(equalTo: moreButton.topAnchor, constant: -8).isActive = true
        instructionsText.leftAnchor.constraint(equalTo: instructionsLabel.leftAnchor).isActive = true
        instructionsText.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        instructionsText.sizeToFit()
        
        profileIcon.anchor(top: nil, left: container.leftAnchor, bottom: instructionsText.topAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 8, paddingRight: 0, width: 16, height: 16)
        
        instructionsLabel.leftAnchor.constraint(equalTo: profileIcon.rightAnchor, constant: 20).isActive = true
        instructionsLabel.centerYAnchor.constraint(equalTo: profileIcon.centerYAnchor).isActive = true
        instructionsLabel.sizeToFit()
        
        container.anchor(top: profileIcon.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        profitsBottomAnchor = container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            profitsBottomAnchor.isActive = true
        
        view.addSubview(imageView)
        view.addSubview(parkInfoButton)
        
        imageView.anchor(top: nil, left: view.leftAnchor, bottom: container.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        parkInfoButton.anchor(top: imageView.topAnchor, left: imageView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 24)
        
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
         let state = sender.state
         let translation = sender.translation(in: self.view).y
         if state == .changed {
             self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
             self.view.layoutIfNeeded()
             if translation >= 160 || translation <= -320 {
                 self.profitsBottomAnchor.constant = self.bottomAnchor
                 UIView.animate(withDuration: animationOut) {
                     self.view.layoutIfNeeded()
                 }
                 self.dismissView()
             }
         } else if state == .ended {
             self.view.endEditing(true)
             let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
             if difference >= 160 {
                 self.dismissView()
                 self.profitsBottomAnchor.constant = self.bottomAnchor
                 UIView.animate(withDuration: animationOut) {
                     self.view.layoutIfNeeded()
                 }
             } else {
                 self.profitsBottomAnchor.constant = self.bottomAnchor
                 UIView.animate(withDuration: animationOut) {
                     self.view.layoutIfNeeded()
                 }
             }
         }
     }
    
    @objc func dismissView() {
        UIView.animate(withDuration: animationOut) {
            tabDimmingView.alpha = 0
        }
        dismiss(animated: true, completion: nil)
    }

}

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    var gestureRecognizer: UITapGestureRecognizer!

    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)

        // Creates the image view and adds it as a subview to the scroll view
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        setupScrollView()
        setupGestureRecognizer()
    }
    
    // Sets the scroll view delegate and zoom scale limits
    func setupScrollView() {
        delegate = self
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    
    // Tell the scroll view delegate which view to use for zooming and scrolling
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // Sets up the gesture recognizer that receives double taps to auto-zoom
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    
    // Handles a double tap by either resetting the zoom or zooming to where was tapped
    @objc func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
}
