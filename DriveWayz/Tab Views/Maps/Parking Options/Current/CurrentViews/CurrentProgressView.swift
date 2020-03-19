//
//  CurrentProgressView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/4/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import AudioToolbox

class CurrentProgressView: UIView {
    
    var trackThickness: CGFloat = 0.4
    var borderThickness: CGFloat = 0.05

    var previousAngle: Double = 0.0
    let progressSize: CGFloat = phoneWidth - 64
    let progressChangeSize: CGFloat = phoneWidth - 144
    
    lazy var midViewX = progressSize/2
    lazy var midViewY = progressSize/2
    
    var previousX = phoneWidth/2
    var previousY = phoneWidth/2
    
    var currentQuadrant: Int = 1

    var pinPath = UIBezierPath()
    
    var pinView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE_DARK
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.layer.borderWidth = 3
        view.layer.borderColor = Theme.WHITE.cgColor
        view.layer.cornerRadius = 45/2
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.alpha = 0
        
        return view
    }()
    
    lazy var grayWhiteTrack: KDCircularProgress = {
        let progress = KDCircularProgress()
        progress.startAngle = -90
        progress.progressThickness = trackThickness + borderThickness
        progress.trackThickness = trackThickness
        progress.clockwise = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: Theme.WHITE)
        progress.trackColor = .clear
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    lazy var grayTrack: KDCircularProgress = {
        let progress = KDCircularProgress()
        progress.startAngle = -90
        progress.progressThickness = trackThickness
        progress.clockwise = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: Theme.LINE_GRAY)
        progress.trackColor = .clear
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    lazy var whiteTrack: KDCircularProgress = {
        let progress = KDCircularProgress()
        progress.startAngle = -90
        progress.progressThickness = trackThickness + borderThickness
        progress.trackThickness = trackThickness
        progress.clockwise = true
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: Theme.WHITE)
        progress.trackColor = Theme.LINE_GRAY
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    lazy var progressTrack: KDCircularProgress = {
        let progress = KDCircularProgress()
        progress.startAngle = -90
        progress.progressThickness = trackThickness
        progress.clockwise = true
        progress.gradientRotateSpeed = 1
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: Theme.BLUE_DARK, Theme.BLUE_MED)
        progress.trackColor = .clear
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    lazy var disc = Disc(width: progressChangeSize, numTicks: 48)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        buildPin()
    }
    
    var pinCenterXAnchor: NSLayoutConstraint!
    var pinCenterYAnchor: NSLayoutConstraint!
    
    var pinRightAnchor: NSLayoutConstraint!
    var pinLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(whiteTrack)
        addSubview(progressTrack)
        addSubview(grayWhiteTrack)
        addSubview(grayTrack)
        addSubview(disc)
        
        whiteTrack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whiteTrack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        whiteTrack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.2).isActive = true
        whiteTrack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.2).isActive = true
        
        progressTrack.anchor(top: whiteTrack.topAnchor, left: whiteTrack.leftAnchor, bottom: whiteTrack.bottomAnchor, right: whiteTrack.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        grayWhiteTrack.anchor(top: whiteTrack.topAnchor, left: whiteTrack.leftAnchor, bottom: whiteTrack.bottomAnchor, right: whiteTrack.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        grayTrack.anchor(top: whiteTrack.topAnchor, left: whiteTrack.leftAnchor, bottom: whiteTrack.bottomAnchor, right: whiteTrack.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        disc.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        disc.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        disc.widthAnchor.constraint(equalTo: disc.heightAnchor).isActive = true
        disc.heightAnchor.constraint(equalToConstant: progressChangeSize).isActive = true
        
        addSubview(pinView)
        pinView.widthAnchor.constraint(equalTo: pinView.heightAnchor).isActive = true
        pinView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        pinCenterXAnchor = pinView.centerXAnchor.constraint(equalTo: leftAnchor)
            pinCenterXAnchor.priority = UILayoutPriority.defaultLow
            pinCenterXAnchor.isActive = true
        pinCenterYAnchor = pinView.centerYAnchor.constraint(equalTo: topAnchor)
            pinCenterYAnchor.priority = UILayoutPriority.defaultLow
            pinCenterYAnchor.isActive = true
//        pinRightAnchor = pinView.rightAnchor.constraint(lessThanOrEqualTo: centerXAnchor)
//            pinRightAnchor.isActive = false
//        pinLeftAnchor = pinView.leftAnchor.constraint(greaterThanOrEqualTo: centerXAnchor)
//            pinLeftAnchor.isActive = true
        
    }
    
    func animateToRatio(ratio: Double, duration: Double) {
        let radians = 2 * .pi * ratio
        let angle = radiansToDegrees(radians: radians)
    
        whiteTrack.animate(toAngle: angle, duration: duration, completion: nil)
        grayWhiteTrack.animate(toAngle: (360 - angle - 35), duration: duration, completion: nil)
        grayTrack.animate(toAngle: (360 - angle - 20), duration: duration, completion: nil)
        progressTrack.animate(toAngle: angle, duration: duration, completion: nil)
        
        previousAngle = angle
    }
    
    func moveToRatio(ratio: Double) {
        let radians = 2 * .pi * ratio
        let angle = radiansToDegrees(radians: radians)
        
        whiteTrack.angle = angle
        grayWhiteTrack.angle = (360 - angle - 35)
        grayTrack.angle = (360 - angle - 20)
        progressTrack.angle = angle
        
        previousAngle = angle
    }
    
    func pauseAnimation() {
        whiteTrack.pauseAnimation()
        grayWhiteTrack.pauseAnimation()
        grayTrack.pauseAnimation()
        progressTrack.pauseAnimation()
    }
    
    func buildPin() {
        // Do any additional setup after loading the view, typically from a nib.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: midViewX,y: midViewY), radius: CGFloat(progressSize/2), startAngle: CGFloat(0), endAngle:CGFloat(CGFloat.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
        
        let earthX2 = midViewX + cos(CGFloat.pi/2) * CGFloat((progressSize - 40)/2)
        let earthY2 = midViewY + sin(CGFloat.pi/2) * CGFloat((progressSize - 40)/2)
        
        pinCenterXAnchor.constant = CGFloat(earthX2)
        pinCenterYAnchor.constant = CGFloat(earthY2)
        layoutIfNeeded()

        let drag = UIPanGestureRecognizer(target: self, action: #selector(dragPin(recognizer:)))
        pinView.addGestureRecognizer(drag)
    }
    
    @objc func dragPin(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self);
        let earthX = CGFloat(point.x)
        let earthY = CGFloat(point.y)
        let angleX = (earthX - midViewX)
        let angleY = (earthY - midViewY)
        let angle = atan2(angleY, angleX)
        
        var degrees = radiansToDegrees(radians: Double(angle)) + 90.0
        if degrees < 0 {
            degrees += 360
        }
        print("Degrees: \(degrees)")
        let ratio = degrees/360
        moveToRatio(ratio: ratio)
        
        let earthX2 = midViewX + cos(angle) * CGFloat((progressSize - 40)/2)
        let earthY2 = midViewY + sin(angle) * CGFloat((progressSize - 40)/2)

        let state = recognizer.state
        if state == .began {
            scaleShape(grow: true)
        } else if state == .ended {
            scaleShape(grow: false)
        }
    
        let padding: CGFloat = 20
        let center = frame.midX - padding
        if earthX < center && earthY < center {
            // Fourth quadrant
            currentQuadrant = 4
        } else if earthX < center && earthY > center {
            // Third quadrant
            currentQuadrant = 3
        } else if earthX > center && earthY > center {
            // Second quadrant
            currentQuadrant = 2
        } else if earthX > center && earthY < center {
            // First quadrant
            if currentQuadrant == 4 {
                pinCenterXAnchor.constant = CGFloat(center)
                pinCenterYAnchor.constant = CGFloat(20)
                return
            }
            currentQuadrant = 1
        }
        previousX = earthX2
        previousY = earthY2
        
        pinCenterXAnchor.constant = CGFloat(earthX2)
        pinCenterYAnchor.constant = CGFloat(earthY2)
        layoutIfNeeded()
    }
        
    func scaleShape(grow: Bool) {
        UIView.animateOut(withDuration: animationIn, animations: {
            if grow {
                self.pinView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } else {
                self.pinView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == pinView {
            scaleShape(grow: true)
            AudioServicesPlaySystemSound(1519) // Vibration feedback (weak boom)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == pinView {
            scaleShape(grow: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Disc: UIView {

    // Defaults.
    private var myOuterRadius: CGFloat = 100.0
    private var myInnerRadius: CGFloat = 90.0
    private var myNumberOfTicks: Int = 5

    override func draw(_ rect: CGRect) {
        let strokeColor = Theme.GRAY_WHITE_3
        
        let tickPath = UIBezierPath()
        for i in 0..<myNumberOfTicks {
            let angle = CGFloat(i) * CGFloat(2 * CGFloat.pi) / CGFloat(myNumberOfTicks)
            let centerX: CGFloat = myOuterRadius
            let centerY: CGFloat = myOuterRadius
            
            let inner = CGPoint(x: myInnerRadius * cos(angle) + centerX,
                y: myInnerRadius * sin(angle) + centerY)
            let outer = CGPoint(x: myOuterRadius * cos(angle) + centerX,
                y: myOuterRadius * sin(angle) + centerY)
            
            tickPath.move(to: inner)
            tickPath.addLine(to: outer)
        }
        tickPath.close()
        tickPath.lineCapStyle = .round
        strokeColor.setStroke()
        tickPath.lineWidth = 1
        tickPath.stroke()
    }

    init(width: CGFloat, numTicks: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: width))

        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.cornerRadius = CGFloat(width / 2)
        layer.masksToBounds = true
        
        myOuterRadius = width/2
        myInnerRadius = (width/2) - 8
        myNumberOfTicks = numTicks
    }
    
    func show() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    func hide() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.alpha = 0
        }, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
