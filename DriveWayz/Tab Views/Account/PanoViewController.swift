//
//  PanoViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

var dot1: UIButton!
var dot2: UIButton!
var dot3: UIButton!
var dot4: UIButton!
var shapeLayer = CAShapeLayer()

class PanoViewController: UIViewController, GMSMapViewDelegate {
    
    var delegate: controlPano?
    
    var lastPoint = CGPoint(x: 50, y: -50)
    var screenShotView: UIImageView!
    var accountViewController: AccountViewController?
    
    lazy var exitButton: UIButton = {
        let exitButton = UIButton()
        let exitImage = UIImage(named: "exit")
        exitButton.setImage(exitImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(dismissPano), for: .touchUpInside)
        
        return exitButton
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.layer.cornerRadius = 15
        blurEffectView.clipsToBounds = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    lazy var fullBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    lazy var panoLabel: UILabel = {
        let panoLabel = UILabel()
        panoLabel.text = "Please pan around until you can clearly see the parking spot. Try to fit the entire view within the line on the left."
        panoLabel.textColor = UIColor.white
        panoLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        panoLabel.contentMode = .center
        panoLabel.numberOfLines = 4
        panoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLabel
    }()
    
    lazy var panoLine: UIView = {
       let panoLine = UIView()
        panoLine.backgroundColor = Theme.PRIMARY_COLOR
        panoLine.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
        panoLine.layer.borderWidth = 1
        panoLine.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLine
    }()
    
    lazy var screenShotButton: UIButton = {
        let screenShot = UIButton()
        screenShot.backgroundColor = Theme.PRIMARY_COLOR
        screenShot.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        screenShot.layer.shadowRadius = 3
        screenShot.layer.shadowOpacity = 0
        screenShot.translatesAutoresizingMaskIntoConstraints = false
        screenShot.setTitle("Press to Select", for: .normal)
        screenShot.tintColor = UIColor.white
        screenShot.layer.cornerRadius = 15
        screenShot.alpha = 1
        screenShot.addTarget(self, action: #selector(takeScreenShot(sender:)), for: .touchUpInside)
        
        return screenShot
    }()
    
    var overlay: UIView = {
        let overlay = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        overlay.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        overlay.layer.borderWidth = 2
        overlay.backgroundColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5)
        
        return overlay
    }()
    
    lazy var dotLabel: UILabel = {
        let panoLabel = UILabel()
        panoLabel.text = "Please move the dots to highlight the area for parking. Press confirm when the dots clearly indicate the spot."
        panoLabel.textColor = UIColor.white
        panoLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        panoLabel.contentMode = .center
        panoLabel.numberOfLines = 4
        panoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return panoLabel
    }()
    
    lazy var dotShotButton: UIButton = {
        let screenShot = UIButton()
        screenShot.backgroundColor = Theme.PRIMARY_COLOR
        screenShot.layer.shadowColor = Theme.PRIMARY_DARK_COLOR.cgColor
        screenShot.layer.shadowRadius = 3
        screenShot.layer.shadowOpacity = 0
        screenShot.translatesAutoresizingMaskIntoConstraints = false
        screenShot.setTitle("Confirm Parking Spot", for: .normal)
        screenShot.tintColor = UIColor.white
        screenShot.layer.cornerRadius = 15
        screenShot.alpha = 1
        screenShot.addTarget(self, action: #selector(finalScreenShot(sender:)), for: .touchUpInside)
        
        return screenShot
    }()
    
    let fullBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    var panoView: GMSPanoramaView!

    override func loadView() {
        super.viewDidLoad()
        
        panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lattitudeConstant, longitude: longitudeConstant))
        
        setupPano()
        
    }
    
    func setupPano() {
        
        view.addSubview(exitButton)
        
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(panoLabel)
        
        panoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        panoLabel.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: 4).isActive = true
        panoLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor).isActive = true
        panoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        
        view.addSubview(blurEffectView)
        view.bringSubview(toFront: panoLabel)
        view.bringSubview(toFront: exitButton)
        blurEffectView.leftAnchor.constraint(equalTo: panoLabel.leftAnchor, constant: -24).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: exitButton.rightAnchor, constant: -16).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: panoLabel.topAnchor, constant: 4).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: panoLabel.bottomAnchor, constant: -4).isActive = true
        
        view.addSubview(panoLine)
        panoLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 2).isActive = true
        panoLine.widthAnchor.constraint(equalToConstant: 4).isActive = true
        panoLine.topAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: 8).isActive = true
        panoLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        
        view.addSubview(screenShotButton)
        screenShotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        screenShotButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        screenShotButton.widthAnchor.constraint(equalToConstant: 215).isActive = true
        screenShotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        
    }
    
    var dot1View: UIView!
    var dot2View: UIView!
    var dot3View: UIView!
    var dot4View: UIView!
    
    func addOverlay() {
        
        dot1 = UIButton(frame: CGRect(x: 100, y: 300, width: 36, height: 36))
        dot1.layer.cornerRadius = 18
        dot1.layer.backgroundColor = UIColor.clear.cgColor
        dot1.translatesAutoresizingMaskIntoConstraints = false
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panButton1(sender:)))
        dot1.addGestureRecognizer(pan1)
        view.addSubview(dot1)
        
        dot1View = UIView()
        dot1View.layer.cornerRadius = 4
        dot1View.backgroundColor = Theme.PRIMARY_COLOR
        dot1View.center = dot1.center
        dot1View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot1View)
        
        dot1View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.centerXAnchor.constraint(equalTo: dot1.centerXAnchor).isActive = true
        dot1View.centerYAnchor.constraint(equalTo: dot1.centerYAnchor).isActive = true
        
        dot1.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot1.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        dot2 = UIButton(frame: CGRect(x: 200, y: 300, width: 36, height: 36))
        dot2.layer.cornerRadius = 18
        dot2.backgroundColor = UIColor.clear
        dot2.translatesAutoresizingMaskIntoConstraints = false
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(panButton2(sender:)))
        dot2.addGestureRecognizer(pan2)
        view.addSubview(dot2)
        
        dot2View = UIView()
        dot2View.layer.cornerRadius = 4
        dot2View.backgroundColor = Theme.PRIMARY_COLOR
        dot2View.center = dot1.center
        dot2View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot2View)
        
        dot2View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.centerXAnchor.constraint(equalTo: dot2.centerXAnchor).isActive = true
        dot2View.centerYAnchor.constraint(equalTo: dot2.centerYAnchor).isActive = true
        
        dot2.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot2.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        dot3 = UIButton(frame: CGRect(x: 200, y: 400, width: 36, height: 36))
        dot3.layer.cornerRadius = 18
        dot3.backgroundColor = UIColor.clear
        dot3.translatesAutoresizingMaskIntoConstraints = false
        let pan3 = UIPanGestureRecognizer(target: self, action: #selector(panButton3(sender:)))
        dot3.addGestureRecognizer(pan3)
        view.addSubview(dot3)
        
        dot3View = UIView()
        dot3View.layer.cornerRadius = 4
        dot3View.backgroundColor = Theme.PRIMARY_COLOR
        dot3View.center = dot1.center
        dot3View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot3View)
        
        dot3View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.centerXAnchor.constraint(equalTo: dot3.centerXAnchor).isActive = true
        dot3View.centerYAnchor.constraint(equalTo: dot3.centerYAnchor).isActive = true
        
        dot3.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot3.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        dot3.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        
        dot4 = UIButton(frame: CGRect(x: 100, y: 400, width: 36, height: 36))
        dot4.layer.cornerRadius = 18
        dot4.backgroundColor = UIColor.clear
        dot4.translatesAutoresizingMaskIntoConstraints = false
        let pan4 = UIPanGestureRecognizer(target: self, action: #selector(panButton4(sender:)))
        dot4.addGestureRecognizer(pan4)
        view.addSubview(dot4)
        
        dot4View = UIView()
        dot4View.layer.cornerRadius = 4
        dot4View.backgroundColor = Theme.PRIMARY_COLOR
        dot4View.center = dot1.center
        dot4View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot4View)
        
        dot4View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.centerXAnchor.constraint(equalTo: dot4.centerXAnchor).isActive = true
        dot4View.centerYAnchor.constraint(equalTo: dot4.centerYAnchor).isActive = true
        
        dot4.widthAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dot4.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        dot4.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        
        self.view.layer.addSublayer(shapeLayer)
        startPan()
        
    }
    
    @objc func takeScreenShot(sender: UIButton) {

        let contextImage = view?.snapshot
        let rect = CGRect(x: 0, y: 200, width: self.view.frame.width, height: self.view.frame.height + 80)
        let croppedImage = cropping(contextImage!, toRect: rect)
        
        self.view.addSubview(fullBlurView)
        fullBlurView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fullBlurView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fullBlurView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        fullBlurView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true

        screenShotView = UIImageView(image: croppedImage)
        screenShotView.contentMode = .scaleAspectFit
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenShotView)
        
        screenShotView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        screenShotView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        screenShotView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 120).isActive = true
        screenShotView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(dotLabel)
        dotLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        dotLabel.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: 4).isActive = true
        dotLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor).isActive = true
        dotLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        
        self.view.addSubview(dotShotButton)
        dotShotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dotShotButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dotShotButton.widthAnchor.constraint(equalToConstant: 215).isActive = true
        dotShotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        
        self.screenShotButton.removeFromSuperview()
        addOverlay()
    }
    
    @objc func finalScreenShot(sender: UIButton) {
        
        let contextImage = view?.snapshot
        let rect = CGRect(x: 0, y: 300, width: self.view.frame.width, height: self.view.frame.height + 80)
        let croppedImage = cropping(contextImage!, toRect: rect)
        parkingSpotImage = croppedImage
        parking = parking + 1
        startActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dismissPano()
            self.activityIndicatorView.stopAnimating()
            self.delegate?.endPano()
        })
    }
    
    func startActivityIndicator() {
        self.view.addSubview(self.fullBlur)
        
        self.fullBlur.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.fullBlur.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.fullBlur.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.fullBlur.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.activityIndicatorView.startAnimating()
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    @objc func dismissPano() {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cropping(_ inputImage: UIImage, toRect cropRect: CGRect) -> UIImage {
        
        let cropZone = CGRect(x:cropRect.origin.x,
                              y:cropRect.origin.y,
                              width:cropRect.size.width * 2,
                              height:cropRect.size.height)

        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return inputImage
        }

        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
        
    }
    
    func startPan() {
        let location1 = CGPoint(x: 100, y: 300)
        let location2 = CGPoint(x: 200, y: 300)
        let location3 = CGPoint(x: 200, y: 400)
        let location4 = CGPoint(x: 100, y: 400)
        dot1.center = location1
        dot1View.center = location1
        dot2.center = location2
        dot2View.center = location2
        dot3.center = location3
        dot3View.center = location3
        dot4.center = location4
        dot4View.center = location4
        moveOverlay()
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
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = Theme.PRIMARY_COLOR.cgColor
        shapeLayer.fillColor = Theme.PRIMARY_COLOR.withAlphaComponent(0.5).cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
    }
    
}


extension UIView {
    var snapshot: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}








