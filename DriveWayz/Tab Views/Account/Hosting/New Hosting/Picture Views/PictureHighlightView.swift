//
//  PictureHighlightView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PictureHighlightView: UIViewController {

   override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0
        
        addOverlay()
    }
    
    var dot1: UIButton!
    var dot2: UIButton!
    var dot3: UIButton!
    var dot4: UIButton!
    
    var dot1View: UIView!
    var dot2View: UIView!
    var dot3View: UIView!
    var dot4View: UIView!
    var panView: UIView!
    
    let dotSize: CGFloat = 8.0
    lazy var dotView1 = UIView(frame: CGRect(x: 30 - dotSize/2, y: 30 - dotSize/2, width: dotSize, height: dotSize))
    lazy var dotView2 = UIView(frame: CGRect(x: 30 - dotSize/2, y: 30 - dotSize/2, width: dotSize, height: dotSize))
    lazy var dotView3 = UIView(frame: CGRect(x: 30 - dotSize/2, y: 30 - dotSize/2, width: dotSize, height: dotSize))
    lazy var dotView4 = UIView(frame: CGRect(x: 30 - dotSize/2, y: 30 - dotSize/2, width: dotSize, height: dotSize))
    
    func addOverlay() {
        
        view.layer.addSublayer(shapeLayer)
        
        panView = UIView(frame: CGRect(x: 125, y: 125, width: 100, height: 100))
        panView.backgroundColor = UIColor.clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(shapeLayerPanned(sender:)))
        panView.addGestureRecognizer(panGesture)
        view.addSubview(panView)
        
        dot1 = UIButton(frame: CGRect(x: 100, y: 300, width: 60, height: 60))
        dot1.layer.cornerRadius = 6
        dot1.backgroundColor = UIColor.clear
        dot1.clipsToBounds = true
        dot1.translatesAutoresizingMaskIntoConstraints = false
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panButton1(sender:)))
        dot1.addGestureRecognizer(pan1)
        
        dot1View = UIView()
        dot1View.layer.cornerRadius = 4
        dot1View.backgroundColor = Theme.DarkRed
        dot1View.center = dot1.center
        
        view.addSubview(dot1View)
        view.addSubview(dot1)
        
        dot1View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot1View.centerXAnchor.constraint(equalTo: dot1.centerXAnchor).isActive = true
        dot1View.centerYAnchor.constraint(equalTo: dot1.centerYAnchor).isActive = true
        
        dot1.widthAnchor.constraint(equalToConstant: 60).isActive = true
        dot1.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        dot2 = UIButton(frame: CGRect(x: 200, y: 300, width: 60, height: 60))
        dot2.layer.cornerRadius = 6
        dot2.backgroundColor = UIColor.clear
        dot2.translatesAutoresizingMaskIntoConstraints = false
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(panButton2(sender:)))
        dot2.addGestureRecognizer(pan2)
        
        dot2View = UIView()
        dot2View.layer.cornerRadius = 4
        dot2View.backgroundColor = Theme.BLUE
        dot2View.center = dot1.center
        
        view.addSubview(dot2View)
        view.addSubview(dot2)
        
        dot2View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot2View.centerXAnchor.constraint(equalTo: dot2.centerXAnchor).isActive = true
        dot2View.centerYAnchor.constraint(equalTo: dot2.centerYAnchor).isActive = true
        
        dot2.widthAnchor.constraint(equalToConstant: 60).isActive = true
        dot2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        dot3 = UIButton(frame: CGRect(x: 200, y: 400, width: 60, height: 60))
        dot3.layer.cornerRadius = 6
        dot3.backgroundColor = UIColor.clear
        dot3.translatesAutoresizingMaskIntoConstraints = false
        let pan3 = UIPanGestureRecognizer(target: self, action: #selector(panButton3(sender:)))
        dot3.addGestureRecognizer(pan3)
        
        dot3View = UIView()
        dot3View.layer.cornerRadius = 4
        dot3View.backgroundColor = Theme.BLUE
        dot3View.center = dot3.center
        
        view.addSubview(dot3View)
        view.addSubview(dot3)
        
        dot3View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot3View.centerXAnchor.constraint(equalTo: dot3.centerXAnchor).isActive = true
        dot3View.centerYAnchor.constraint(equalTo: dot3.centerYAnchor).isActive = true
        
        dot3.widthAnchor.constraint(equalToConstant: 60).isActive = true
        dot3.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        dot4 = UIButton(frame: CGRect(x: 100, y: 400, width: 60, height: 60))
        dot4.layer.cornerRadius = 6
        dot4.backgroundColor = UIColor.clear
        dot4.layer.borderColor = UIColor.clear.cgColor
        dot4.layer.borderWidth = 4
        dot4.translatesAutoresizingMaskIntoConstraints = false
        let pan4 = UIPanGestureRecognizer(target: self, action: #selector(panButton4(sender:)))
        dot4.addGestureRecognizer(pan4)
        
        dot4View = UIView()
        dot4View.layer.cornerRadius = 4
        dot4View.backgroundColor = Theme.BLUE
        dot4View.center = dot4.center
        
        view.addSubview(dot4View)
        view.addSubview(dot4)
        
        dot4View.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dot4View.centerXAnchor.constraint(equalTo: dot4.centerXAnchor).isActive = true
        dot4View.centerYAnchor.constraint(equalTo: dot4.centerYAnchor).isActive = true
        
        dot4.widthAnchor.constraint(equalToConstant: 60).isActive = true
        dot4.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        dotView1.backgroundColor = Theme.BLUE
        dotView1.isUserInteractionEnabled = false
        dotView1.layer.cornerRadius = dotSize/2
        dot1.addSubview(dotView1)
        dotView2.backgroundColor = Theme.BLUE
        dotView2.isUserInteractionEnabled = false
        dotView2.layer.cornerRadius = dotSize/2
        dot2.addSubview(dotView2)
        dotView3.backgroundColor = Theme.BLUE
        dotView3.isUserInteractionEnabled = false
        dotView3.layer.cornerRadius = dotSize/2
        dot3.addSubview(dotView3)
        dotView4.backgroundColor = Theme.BLUE
        dotView4.isUserInteractionEnabled = false
        dotView4.layer.cornerRadius = dotSize/2
        dot4.addSubview(dotView4)
        
        startPan()
    }
    
    func takeScreenshot() {
        dotView1.isHidden = true
        dotView2.isHidden = true
        dotView3.isHidden = true
        dotView4.isHidden = true
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
        dot1.center = dot1View.center
        dot2.center = dot2View.center
        dot3.center = dot3View.center
        dot4.center = dot4View.center
        self.view.layoutIfNeeded()
    }
    
    func startPan() {
        let location1 = CGPoint(x: phoneWidth/4, y: 300)
        let location2 = CGPoint(x: phoneWidth/3, y: 200)
        let location3 = CGPoint(x: phoneWidth - phoneWidth/3, y: 200)
        let location4 = CGPoint(x: phoneWidth - phoneWidth/4, y: 300)
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
            self.dotView1.isHidden = false
            self.dotView2.isHidden = false
            self.dotView3.isHidden = false
            self.dotView4.isHidden = false
            self.shapeLayer.fillColor = Theme.BLUE.withAlphaComponent(0.5).cgColor
        }
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
        shapeLayerMoved()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: dot1.center.x, y: dot1.center.y))
        path.addLine(to: CGPoint(x: dot2.center.x, y: dot2.center.y))
        path.addLine(to: CGPoint(x: dot3.center.x, y: dot3.center.y))
        path.addLine(to: CGPoint(x: dot4.center.x, y: dot4.center.y))
        path.close()
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = Theme.BLUE.cgColor
        shapeLayer.fillColor = Theme.BLUE.withAlphaComponent(0.5).cgColor
        shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
    }

}
