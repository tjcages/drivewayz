//
//  PurchasePublicView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/6/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

protocol PublicDelegate {
    func removeDim()
}

class PurchasePublicView: UIViewController {
    
    var delegate: handleCheckoutParking?
    var spotType: SpotType = .Public {
        didSet {
            switch spotType {
            case .Private:
                titleLabel.text = "To parking lot"
                illustrationBackgroundColor = Theme.BLUE_DARK
            case .Public:
                titleLabel.text = "To parking garage"
                illustrationBackgroundColor = Theme.COOL_1_MED
            case .Free:
                titleLabel.text = "To public lot"
                illustrationBackgroundColor = Theme.COOL_2_MED
            }
        }
    }
    
    var illustrationBackgroundColor: UIColor = Theme.COOL_1_MED {
        didSet {
            infoView.backgroundColor = illustrationBackgroundColor
        }
    }
    
    var canDrag: Bool = true

    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To parking garage"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = illustrationBackgroundColor
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = Theme.WHITE
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        
        return view
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = -1
        
        return view
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    lazy var buttonView: PublicButtonView = {
        let view = PublicButtonView()
        view.mainButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        scrollView.delegate = self

        setupViews()
        setupStack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lightContentStatusBar()
        
        UIView.animateOut(withDuration: animationOut, animations: {
            self.backButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    var stackHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(infoView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        
        infoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.sizeToFit()
        
        view.addSubview(scrollView)
        view.addSubview(buttonView)
        scrollView.addSubview(stackView)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 600)
        scrollView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: buttonView.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        stackView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackHeightAnchor = stackView.heightAnchor.constraint(equalToConstant: 474)
            stackHeightAnchor.isActive = true
        
        buttonView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 192 - cancelBottomHeight)
        
        view.addSubview(dimmingView)
        dimmingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func setupStack() {
        let infoView = PublicInfoView()
        infoView.spotType = spotType
        infoView.heightAnchor.constraint(equalToConstant: 274).isActive = true
        stackView.addArrangedSubview(infoView)
        
        if spotType == .Public {
            let kioskView = PublicKioskView()
            kioskView.heightAnchor.constraint(equalToConstant: 164).isActive = true
            kioskView.whyButton.addTarget(self, action: #selector(showKioskHelp), for: .touchUpInside)
            stackView.addArrangedSubview(kioskView)
            stackHeightAnchor.constant = 618
        }
        
        let availabilityView = PublicAvailabilityView()
        availabilityView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        availabilityView.whyButton.addTarget(self, action: #selector(showAvailabilityHelp), for: .touchUpInside)
        stackView.addArrangedSubview(availabilityView)
        
        view.layoutIfNeeded()
    }
    
    @objc func mainButtonPressed() {
        dismiss(animated: true, completion: nil)
        delegate?.startNavigation()
    }
    
    @objc func backButtonPressed() {
        delegate?.parkingMaximized()
        UIView.animateOut(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0
        }, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
}

extension PurchasePublicView: PublicDelegate {
    
    @objc func showKioskHelp() {
        let controller = PublicInformationController()
        controller.delegate = self
        controller.publicInformation = .kiosk
        showHelp(controller: controller)
    }
    
    @objc func showAvailabilityHelp() {
        let controller = PublicInformationController()
        controller.delegate = self
        controller.publicInformation = .availability
        showHelp(controller: controller)
    }
    
    func showHelp(controller: UIViewController) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 0.7
        }) { (success) in
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func removeDim() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
}

extension PurchasePublicView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        canDrag = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let percent = translation/64
        if percent <= 1.0 && percent >= 0 {
            let color = fadeFromColor(fromColor: illustrationBackgroundColor, toColor: Theme.WHITE, withPercentage: percent)
            infoView.backgroundColor = color
            if let view = stackView.subviews.first as? PublicInfoView {
                if percent >= 0 && percent <= 0.5 {
                    view.infoView.alpha = 1 - percent * 2
                } else if percent >= 0.5 && percent <= 1.0 {
                    let percentage = (percent - 0.5) * 2
                    view.infoView.alpha = 0
                    view.svgIllustration.alpha = 1 - percentage
                }
                view.changeCarAnchors(percent: percent)
            }
            if percent >= 0.5 && percent <= 1.0 {
                let percentage = (percent - 0.5) * 2
                titleLabel.alpha = percentage
            }
        } else if percent > 1.0 {
            titleLabel.alpha = 1
            infoView.backgroundColor = Theme.WHITE
            if let view = stackView.subviews.first as? PublicInfoView {
                view.svgIllustration.alpha = 0
                view.infoView.alpha = 0
                view.changeCarAnchors(percent: 1)
            }
        } else if percent < 0 {
            titleLabel.alpha = 0
            infoView.backgroundColor = illustrationBackgroundColor
            if let view = stackView.subviews.first as? PublicInfoView {
                view.svgIllustration.alpha = 1
                view.infoView.alpha = 1
                view.changeCarAnchors(percent: 0)
            }
        }
        if translation < -64 {
            backButtonPressed()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            endScroll(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScroll(scrollView)
    }
    
    func endScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let percent = translation/64
        UIView.animateOut(withDuration: animationOut, animations: {
            if percent >= 0.5 && percent <= 1.0 {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 64), animated: true)
                self.titleLabel.alpha = 1
                self.infoView.backgroundColor = Theme.WHITE
                if let view = self.stackView.subviews.first as? PublicInfoView {
                    view.svgIllustration.alpha = 0
                    view.infoView.alpha = 0
                    view.changeCarAnchors(percent: 1)
                }
                defaultContentStatusBar()
            } else if percent > 1.0 {
                self.titleLabel.alpha = 1
                self.infoView.backgroundColor = Theme.WHITE
                if let view = self.stackView.subviews.first as? PublicInfoView {
                    view.svgIllustration.alpha = 0
                    view.infoView.alpha = 0
                    view.changeCarAnchors(percent: 1)
                }
                defaultContentStatusBar()
            } else {
                self.scrollView.scrollToTop(animated: true)
                self.titleLabel.alpha = 0
                self.infoView.backgroundColor = self.illustrationBackgroundColor
                if let view = self.stackView.subviews.first as? PublicInfoView {
                    view.svgIllustration.alpha = 1
                    if translation == 0 {
                        view.infoView.alpha = 1
                    }
                    view.changeCarAnchors(percent: 0)
                }
                lightContentStatusBar()
            }
        }, completion: nil)
    }
    
}
