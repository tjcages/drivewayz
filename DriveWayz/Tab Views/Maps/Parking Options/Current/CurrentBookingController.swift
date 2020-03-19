//
//  CurrentBookingController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/2/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit

var currentBarNormalHeight: CGFloat = 280 {
    didSet {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "readjustMainBar"), object: nil)
    }
}

class CurrentBookingController: UIViewController {
    
    var delegate: HandleCurrent?
    let progressSize: CGFloat = 100
    let progressLargeSize: CGFloat = 144
    let progressChangeSize: CGFloat = phoneWidth - 64
    
    var currentRatio: Double = 0.0
    
    var isChangingDuration: Bool = false {
        didSet {
            if isChangingDuration {
                canPanCurrentView = false
                scrollView.scrollToTop(animated: false)
            } else {
                canPanCurrentView = true
            }
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.decelerationRate = .fast
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 156 + bottomSafeArea, right: 0)
//        view.bounces = false
        
        return view
    }()
    
    var slideBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var infoView = CurrentInfoView()
    var bottomView = CurrentBottomView()
    var durationView = CurrentDurationView()
    var lotView = CurrentLotView()
    var progressWheel = CurrentProgressView()
    var stayView = CurrentStayView()
    
    var progressButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(progressTapped), for: .touchUpInside)
        
        return button
    }()
    
    var carIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Half_Car_Kiosk_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        
        return view
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        button.layer.cornerRadius = 20
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Time left"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2:15"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var unitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hours"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    var changeDurationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change parking duration", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.setTitleColor(Theme.BLUE_MED, for: .disabled)
        button.isEnabled = false
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.alpha = 0
        button.addTarget(self, action: #selector(changeDurationPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Economy lot"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        label.alpha = 0
        
        return label
    }()
    
    var bookingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booked 9:30am to 11:15am"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        scrollView.delegate = self
        
        bottomView.mainButton.addTarget(self, action: #selector(endBookingPressed), for: .touchUpInside)
        
        setupInfo()
        setupViews()
        setupExpanded()
    }
    
    func updateRatio(ratio: Double, duration: Double, _ start: Bool) {
        if start {
            bottomView.show()
        }
        progressWheel.animateToRatio(ratio: ratio, duration: duration)
        currentRatio = ratio
    }
    
    var progressWheelTopAnchor: NSLayoutConstraint!
    var progressWheelCenterAnchor: NSLayoutConstraint!
    var progressHeightAnchor: NSLayoutConstraint!
    
    var durationButtonTopAnchor: NSLayoutConstraint!
    var timeCenterYAnchor: NSLayoutConstraint!
    var unitTopAnchor: NSLayoutConstraint!
    
    func setupInfo() {
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 700)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(slideBar)
        scrollView.addSubview(line)

        slideBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slideBar.anchor(top: scrollView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 4)
        
        line.anchor(top: slideBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        scrollView.addSubview(infoView)
        infoView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoView.sizeToFit()
        
        scrollView.addSubview(progressWheel)
        scrollView.addSubview(progressButton)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(unitLabel)
        scrollView.addSubview(changeDurationButton)
        
        progressWheelTopAnchor = progressWheel.topAnchor.constraint(equalTo: infoView.topAnchor)
            progressWheelTopAnchor.isActive = true
        progressWheelCenterAnchor = progressWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: phoneWidth/2 - progressSize/2 - 20)
            progressWheelCenterAnchor.isActive = true
        progressHeightAnchor = progressWheel.heightAnchor.constraint(equalToConstant: progressSize)
            progressHeightAnchor.isActive = true
        progressWheel.widthAnchor.constraint(equalTo: progressWheel.heightAnchor).isActive = true
        
        progressButton.anchor(top: progressWheel.topAnchor, left: progressWheel.leftAnchor, bottom: progressWheel.bottomAnchor, right: progressWheel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        timeLabel.centerXAnchor.constraint(equalTo: progressWheel.centerXAnchor).isActive = true
        timeCenterYAnchor = timeLabel.centerYAnchor.constraint(equalTo: progressWheel.centerYAnchor, constant: -12)
            timeCenterYAnchor.isActive = true
        timeLabel.sizeToFit()
        
        unitLabel.centerXAnchor.constraint(equalTo: progressWheel.centerXAnchor).isActive = true
        unitTopAnchor = unitLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor)
            unitTopAnchor.isActive = true
        unitLabel.sizeToFit()
        
        durationButtonTopAnchor = changeDurationButton.topAnchor.constraint(equalTo: progressWheel.bottomAnchor, constant: 74)
            durationButtonTopAnchor.isActive = true
        changeDurationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeDurationButton.sizeToFit()
        
        scrollView.addSubview(carIllustration)
        let width = carIllustration.image.size.width/carIllustration.image.size.height
        carIllustration.widthAnchor.constraint(equalTo: carIllustration.heightAnchor, multiplier: width).isActive = true
        carIllustration.heightAnchor.constraint(equalToConstant: 34).isActive = true
        carIllustration.centerXAnchor.constraint(equalTo: progressWheel.centerXAnchor).isActive = true
        carIllustration.centerYAnchor.constraint(equalTo: progressWheel.centerYAnchor).isActive = true
        
    }
    
    var containerTopAnchor: NSLayoutConstraint!
    var bottomViewHeightAnchor: NSLayoutConstraint!
    var stayViewTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        scrollView.addSubview(durationView)
        scrollView.addSubview(lotView)
        view.addSubview(bottomView)
        scrollView.addSubview(stayView)
        
        durationView.topAnchor.constraint(equalTo: changeDurationButton.bottomAnchor, constant: 20).isActive = true
        durationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        durationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        durationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        lotView.topAnchor.constraint(equalTo: durationView.bottomAnchor, constant: 20).isActive = true
        lotView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lotView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lotView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        bottomViewHeightAnchor = bottomView.heightAnchor.constraint(lessThanOrEqualToConstant: 156 + bottomSafeArea)
            bottomViewHeightAnchor.isActive = true
        containerTopAnchor = bottomView.topAnchor.constraint(equalTo: progressWheel.bottomAnchor, constant: 32)
            containerTopAnchor.priority = UILayoutPriority.defaultLow
            containerTopAnchor.isActive = true
        bottomView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        stayViewTopAnchor = stayView.topAnchor.constraint(equalTo: progressWheel.bottomAnchor, constant: 52)
            stayViewTopAnchor.isActive = true
        stayView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stayView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    var mainTopAnchor: NSLayoutConstraint!
    
    func setupExpanded() {
        
        view.addSubview(container)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.sizeToFit()
        
        container.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: backButton.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(mainLabel)
        scrollView.addSubview(bookingLabel)
        
        mainTopAnchor = mainLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topSafeArea + 48)
            mainTopAnchor.isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        bookingLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        bookingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bookingLabel.sizeToFit()
        
    }
    
    @objc func endBookingPressed(sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        if title == "End booking" {
            scrollView.isScrollEnabled = true
            scrollView.scrollToTop(animated: true)
            UIView.animateOut(withDuration: animationOut, animations: {
                tabDimmingView.alpha = 0.8
            }) { (success) in
                startLoadingAnimation()
                delayWithSeconds(1) {
                    endLoadingAnimation()
                    self.scrollView.isScrollEnabled = false
                    self.delegate?.closeCurrent(parking: false)
                    self.delegate?.dismissCurrent()
                }
            }
        }
    }
    
    func transitionToSearch(percent: CGFloat) {
        var percentage = percent
        let color = fadeFromColor(fromColor: Theme.STANDARD_GRAY, toColor: Theme.WHITE, withPercentage: percent)
        bottomView.backgroundColor = color
        
        if percent == 1.0 {
            if scrollView.contentOffset.y != 0.0 {
                scrollView.scrollToTop(animated: false)
            }
            progressHeightAnchor.constant = progressLargeSize
            progressWheelTopAnchor.constant = (topSafeArea + 29)
            progressWheelCenterAnchor.constant = 0
            UIView.animateOut(withDuration: animationOut, animations: {
                self.backButton.alpha = 1
                self.titleLabel.alpha = 1
                self.container.alpha = 1
                self.infoView.alpha = 0
                self.slideBar.alpha = 0
                self.line.alpha = 0
                self.carIllustration.alpha = 0
                self.progressButton.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scrollView.isScrollEnabled = true
                self.showExpanded()
            }
        } else if percent == 0.0 {
            bottomView.hideExpanded()
            progressHeightAnchor.constant = progressSize
            progressWheelTopAnchor.constant = 0
            progressWheelCenterAnchor.constant = phoneWidth/2 - self.progressSize/2 - 20
            UIView.animateOut(withDuration: animationOut, animations: {
                self.backButton.alpha = 0
                self.titleLabel.alpha = 0
                self.container.alpha = 0
                self.timeLabel.alpha = 0
                self.unitLabel.alpha = 0
                self.changeDurationButton.alpha = 0
                self.durationView.alpha = 0
                self.lotView.alpha = 0
                self.infoView.alpha = 1
                self.slideBar.alpha = 1
                self.line.alpha = 1
                self.carIllustration.alpha = 1
                self.progressButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scrollView.isScrollEnabled = false
                self.hideExpanded()
            }
        } else {
            if timeLabel.alpha == 1 {
                UIView.animateOut(withDuration: animationIn, animations: {
                    self.timeLabel.alpha = 0
                    self.unitLabel.alpha = 0
                    self.changeDurationButton.alpha = 0
                    self.durationView.alpha = 0
                    self.lotView.alpha = 0
                }) { (success) in
                    self.durationButtonTopAnchor.constant = 52
                    self.view.layoutIfNeeded()
                }
            }
            if percent >= 0.8 {
                percentage = (percent - 0.8)/0.2
                backButton.alpha = percentage
                titleLabel.alpha = percentage
            } else if percent >= 0.0 && percent < 0.6 {
                if percent < 0.2 {
                    percentage = percent/0.2
                    slideBar.alpha = 1 - percentage
                    line.alpha = 1 - percentage
                }
                percentage = percent/0.6
                infoView.alpha = 1 - percentage
                carIllustration.alpha = 1 - percentage
            }
            
            progressWheelTopAnchor.constant = (topSafeArea + 29) * percent
            progressWheelCenterAnchor.constant = (phoneWidth/2 - progressSize/2 - 20) * (1 - percent)
            let progressScale = progressSize + (progressLargeSize - progressSize) * percent
            progressHeightAnchor.constant = progressScale
            view.layoutIfNeeded()
        }
    }
    
    func showExpanded() {
        durationButtonTopAnchor.constant = 20
        UIView.animateOut(withDuration: animationOut, animations: {
            self.timeLabel.alpha = 1
            self.unitLabel.alpha = 1
            self.changeDurationButton.alpha = 1
            self.durationView.alpha = 1
            self.lotView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            self.bottomView.showExpanded()
        }
    }
    
    func hideExpanded() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.timeLabel.alpha = 0
            self.unitLabel.alpha = 0
        }) { (success) in
            self.durationButtonTopAnchor.constant = 52
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func progressTapped() {
        delegate?.currentPressed()
    }
    
    @objc func changeDurationPressed() {
        isChangingDuration = true
        bottomView.showDuration()
        updateRatio(ratio: 0.2, duration: animationOut * 2, false)
        
        bottomViewHeightAnchor.constant = 82 + bottomSafeArea
        progressWheelTopAnchor.constant = topSafeArea + 118
        progressHeightAnchor.constant = progressChangeSize
        unitTopAnchor.constant = 20
        mainTopAnchor.constant = topSafeArea + 80
        timeCenterYAnchor.constant = -20
        UIView.animateOut(withDuration: animationOut, animations: {
            self.timeLabel.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
            self.unitLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.timeLabel.font = Fonts.SSPSemiBoldH2
            self.timeLabel.textColor = Theme.BLACK
            self.mainLabel.alpha = 1
            self.bookingLabel.alpha = 1
            self.progressWheel.pinView.alpha = 1
            
            self.changeDurationButton.alpha = 0
            self.durationView.alpha = 0
            self.lotView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.progressWheel.disc.show()
            self.stayViewTopAnchor.constant = 20
            UIView.animateOut(withDuration: animationOut, animations: {
                self.stayView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func closeChangeDuration() {
        isChangingDuration = false
        bottomView.hideDuration()
        updateRatio(ratio: 0.9, duration: animationOut, false)
        progressWheel.disc.hide()
        
        bottomViewHeightAnchor.constant = 156 + bottomSafeArea
        progressWheelTopAnchor.constant = topSafeArea + 29
        progressHeightAnchor.constant = progressLargeSize
        unitTopAnchor.constant = 0
        mainTopAnchor.constant = topSafeArea + 48
        timeCenterYAnchor.constant = -12
        stayViewTopAnchor.constant = 52
        UIView.animateOut(withDuration: animationOut, animations: {
            self.timeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.unitLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.timeLabel.font = Fonts.SSPRegularH2
            self.timeLabel.textColor = Theme.GRAY_WHITE
            self.mainLabel.alpha = 0
            self.bookingLabel.alpha = 0
            self.stayView.alpha = 0
            self.progressWheel.pinView.alpha = 0
            
            self.changeDurationButton.alpha = 1
            self.durationView.alpha = 1
            self.lotView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    @objc func backButtonPressed() {
        if isChangingDuration {
            closeChangeDuration()
        } else {
            delegate?.closeCurrent(parking: false)
            if scrollView.contentOffset.y != 0.0 {
                scrollView.scrollToTop(animated: false)
            }
        }
    }
    
}

extension CurrentBookingController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isChangingDuration {
            let translation = scrollView.contentOffset.y
            if translation < -44 {
                delegate?.closeCurrent(parking: false)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let translation = scrollView.contentOffset.y
            if translation < 44 {
                scrollView.scrollToTop(animated: true)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation < 44 {
            scrollView.scrollToTop(animated: true)
        }
    }
    
}

class EndCircle: UIView {
    
    public var semiCircleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setupViews() {
        //Circle Points
        let center = CGPoint (x: 6.5, y: 6)
        let circleRadius: CGFloat = 6.5
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: true)

        semiCircleLayer.path = circlePath.cgPath
        semiCircleLayer.strokeColor = Theme.WHITE.cgColor
        semiCircleLayer.fillColor = Theme.BLUE_DARK.cgColor
        
        semiCircleLayer.lineWidth = 1
        semiCircleLayer.strokeStart = 0
        semiCircleLayer.strokeEnd  = 1
        
        layer.addSublayer(semiCircleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
