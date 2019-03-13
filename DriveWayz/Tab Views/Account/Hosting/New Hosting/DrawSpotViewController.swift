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
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width))
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONFIRM IMAGE", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 48, height: 60)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var hideDotsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hide square", for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 1
        button.addTarget(self, action: #selector(hideButtons(sender:)), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    var panoView: GMSPanoramaView = {
        let view = GMSPanoramaView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BLACK
        
        setupViews()
        addOverlay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startPan()
    }
    
    func setData(image: UIImage, lattitude: Double, longitude: Double) {
        self.imageView.image = image
        self.panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
    }
    
    func setupViews() {
        
        self.view.addSubview(imageView)
        
        imageView.addSubview(panoView)
        panoView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        panoView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        panoView.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        panoView.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        
        self.view.addSubview(confirmButton)
        confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 48).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(hideDotsButton)
        hideDotsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        hideDotsButton.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -15).isActive = true
        hideDotsButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        hideDotsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    var dot1View: UIView!
    var dot2View: UIView!
    var dot3View: UIView!
    var dot4View: UIView!
    var panView: UIView!
    
    func addOverlay() {
        
        imageView.layer.addSublayer(shapeLayer)
        
        panView = UIView(frame: CGRect(x: 125, y: 125, width: 100, height: 100))
        panView.backgroundColor = UIColor.clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(shapeLayerPanned(sender:)))
        panView.addGestureRecognizer(panGesture)
        imageView.addSubview(panView)
        
        dot1 = UIButton(frame: CGRect(x: 100, y: 300, width: 36, height: 36))
        dot1.layer.cornerRadius = 18
        dot1.layer.backgroundColor = UIColor.clear.cgColor
        dot1.translatesAutoresizingMaskIntoConstraints = false
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panButton1(sender:)))
        dot1.addGestureRecognizer(pan1)
        
        dot1View = UIView()
        dot1View.layer.cornerRadius = 4
        dot1View.backgroundColor = Theme.PACIFIC_BLUE
        dot1View.center = dot1.center
        dot1View.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(dot1View)
        imageView.addSubview(dot1)
        
        dot1View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.centerXAnchor.constraint(equalTo: dot1.centerXAnchor).isActive = true
        dot1View.centerYAnchor.constraint(equalTo: dot1.centerYAnchor).isActive = true
        
        dot1.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        dot2 = UIButton(frame: CGRect(x: 200, y: 300, width: 36, height: 36))
        dot2.layer.cornerRadius = 18
        dot2.backgroundColor = UIColor.clear
        dot2.translatesAutoresizingMaskIntoConstraints = false
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(panButton2(sender:)))
        dot2.addGestureRecognizer(pan2)
        
        dot2View = UIView()
        dot2View.layer.cornerRadius = 4
        dot2View.backgroundColor = Theme.PACIFIC_BLUE
        dot2View.center = dot1.center
        dot2View.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(dot2View)
        imageView.addSubview(dot2)
        
        dot2View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.centerXAnchor.constraint(equalTo: dot2.centerXAnchor).isActive = true
        dot2View.centerYAnchor.constraint(equalTo: dot2.centerYAnchor).isActive = true
        
        dot2.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        dot3 = UIButton(frame: CGRect(x: 200, y: 400, width: 36, height: 36))
        dot3.layer.cornerRadius = 18
        dot3.backgroundColor = UIColor.clear
        dot3.translatesAutoresizingMaskIntoConstraints = false
        let pan3 = UIPanGestureRecognizer(target: self, action: #selector(panButton3(sender:)))
        dot3.addGestureRecognizer(pan3)
        
        dot3View = UIView()
        dot3View.layer.cornerRadius = 4
        dot3View.backgroundColor = Theme.PACIFIC_BLUE
        dot3View.center = dot1.center
        dot3View.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(dot3View)
        imageView.addSubview(dot3)
        
        dot3View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.centerXAnchor.constraint(equalTo: dot3.centerXAnchor).isActive = true
        dot3View.centerYAnchor.constraint(equalTo: dot3.centerYAnchor).isActive = true
        
        dot3.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot3.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        dot4 = UIButton(frame: CGRect(x: 100, y: 400, width: 36, height: 36))
        dot4.layer.cornerRadius = 18
        dot4.backgroundColor = UIColor.clear
        dot4.translatesAutoresizingMaskIntoConstraints = false
        let pan4 = UIPanGestureRecognizer(target: self, action: #selector(panButton4(sender:)))
        dot4.addGestureRecognizer(pan4)
        
        dot4View = UIView()
        dot4View.layer.cornerRadius = 4
        dot4View.backgroundColor = Theme.PACIFIC_BLUE
        dot4View.center = dot1.center
        dot4View.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(dot4View)
        imageView.addSubview(dot4)
        
        dot4View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.centerXAnchor.constraint(equalTo: dot4.centerXAnchor).isActive = true
        dot4View.centerYAnchor.constraint(equalTo: dot4.centerYAnchor).isActive = true
        
        dot4.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot4.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        startPan()
        
    }
    
    func useGoogleMaps() {
        self.panoView.alpha = 1
    }
    
    func useRegularImage() {
        self.panoView.alpha = 0
    }
    
    var toColor: Bool = true
    
    @objc func hideButtons(sender: UIButton) {
        if self.dot1View.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.dot1View.alpha = 0
                self.dot2View.alpha = 0
                self.dot3View.alpha = 0
                self.dot4View.alpha = 0
                self.shapeLayer.fillColor = UIColor.clear.cgColor
            }
            self.toColor = false
            self.hideDotsButton.setTitle("Bring square", for: .normal)
            self.panView.isUserInteractionEnabled = false
        } else {
            UIView.animate(withDuration: animationIn) {
                self.dot1View.alpha = 1
                self.dot2View.alpha = 1
                self.dot3View.alpha = 1
                self.dot4View.alpha = 1
                self.shapeLayer.fillColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.5).cgColor
            }
            self.startPan()
            self.toColor = true
            self.hideDotsButton.setTitle("Hide square", for: .normal)
            self.panView.isUserInteractionEnabled = true
        }
        self.moveOverlay()
    }
    
    @objc func confirmButtonPressed(sender: UIButton) {
        let image = self.imageView.takeScreenshot()
        self.delegate?.confirmedImage(image: image)
    }
    
    var previousPan: CGPoint?
    
    @objc func shapeLayerPanned(sender: UIPanGestureRecognizer) {
        let panx = sender.location(in: view).x
        let pany = sender.location(in: view).y
        if let pan = self.previousPan {
            dot1.center.x = dot1.center.x + panx - pan.x
            dot2.center.x = dot2.center.x + panx - pan.x
            dot3.center.x = dot3.center.x + panx - pan.x
            dot4.center.x = dot4.center.x + panx - pan.x
            dot1.center.y = dot1.center.y + pany - pan.y
            dot2.center.y = dot2.center.y + pany - pan.y
            dot3.center.y = dot3.center.y + pany - pan.y
            dot4.center.y = dot4.center.y + pany - pan.y
            self.dot1View.center = dot1.center
            self.dot2View.center = dot2.center
            self.dot3View.center = dot3.center
            self.dot4View.center = dot4.center
            self.moveOverlay()
        }
        self.previousPan = sender.view?.center
    }
    
    func shapeLayerMoved() {
        let x = (dot1.center.x + dot2.center.x + dot3.center.x + dot4.center.x) / 4
        let y = (dot1.center.y + dot2.center.y + dot3.center.y + dot4.center.y) / 4
        panView.center = CGPoint(x: x, y: y)
    }
    
    func startPan() {
        let location1 = CGPoint(x: 100, y: 100)
        let location2 = CGPoint(x: 200, y: 100)
        let location3 = CGPoint(x: 200, y: 200)
        let location4 = CGPoint(x: 100, y: 200)
        dot1.center = location1
        dot1View.center = location1
        dot2.center = location2
        dot2View.center = location2
        dot3.center = location3
        dot3View.center = location3
        dot4.center = location4
        dot4View.center = location4
        moveOverlay()
        
        UIView.animate(withDuration: animationIn) {
            self.dot1View.alpha = 1
            self.dot2View.alpha = 1
            self.dot3View.alpha = 1
            self.dot4View.alpha = 1
            self.shapeLayer.fillColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.5).cgColor
        }
        self.toColor = true
        self.hideDotsButton.setTitle("Hide square", for: .normal)
        self.panView.isUserInteractionEnabled = true
    }
    
    @objc func panButton1(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot1.center = location // set button to where finger is
            dot1View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton2(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot2.center = location // set button to where finger is
            dot2View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton3(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot3.center = location // set button to where finger is
            dot3View.center = location
        }
        moveOverlay()
    }
    
    @objc func panButton4(sender: UIPanGestureRecognizer){
        if sender.state == .began {
            //wordButtonCenter = button.center // store old button center
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            //button.center = wordButtonCenter // restore button center
        } else {
            let location = sender.location(in: view) // get pan location
            dot4.center = location // set button to where finger is
            dot4View.center = location
        }
        moveOverlay()
    }
    
    let shapeLayer = CAShapeLayer()
    
    func moveOverlay() {
        //        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let width: CGFloat = 640
        let height: CGFloat = 640
        
        shapeLayer.frame = CGRect(x: 0, y: 0,
                                  width: width, height: height)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: dot1.center.x, y: dot1.center.y))
        path.addLine(to: CGPoint(x: dot2.center.x, y: dot2.center.y))
        path.addLine(to: CGPoint(x: dot3.center.x, y: dot3.center.y))
        path.addLine(to: CGPoint(x: dot4.center.x, y: dot4.center.y))
        path.close()
        
        if self.toColor == true {
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = Theme.PACIFIC_BLUE.cgColor
            shapeLayer.fillColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.5).cgColor
            shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
        } else {
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }
        
        shapeLayerMoved()
    }
    

}
