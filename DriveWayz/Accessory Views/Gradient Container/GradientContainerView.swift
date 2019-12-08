//
//  GradientContainerViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class GradientContainerView: UIViewController {
    
    var gradientNewHeight = gradientHeight {
        didSet {
            gradientHeightAnchor.constant = gradientNewHeight
        }
    }
    var subHeight: CGFloat = 0
    var shouldDismiss: Bool = false
    
    let gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowRadius = 3
//        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        button.tag = 1
        button.alpha = 0
        
        return button
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var subView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 2
        label.alpha = 0
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        setupViews()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var scrollViewHeight: CGFloat = 800 {
        didSet {
            scrollView.contentSize = CGSize(width: phoneWidth, height: self.scrollViewHeight)
        }
    }
    
    var mainLabelBottomAnchor: NSLayoutConstraint!
    var subLabelBottom: NSLayoutConstraint!
    var subLabelBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(scrollView)
        view.addSubview(gradientContainer)
        
        view.addSubview(mainView)
        mainView.addSubview(mainLabel)
        
        view.addSubview(subView)
        subView.addSubview(subLabel)
        
        view.addSubview(backButton)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: scrollViewHeight)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        gradientContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeight)
            gradientHeightAnchor.isActive = true
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        }
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        mainLabelBottomAnchor = mainLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
            mainLabelBottomAnchor.isActive = true
        subLabelBottom = mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor)
            subLabelBottom.isActive = false
        mainLabel.sizeToFit()
        
        mainView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: gradientContainer.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        subLabelBottomAnchor = subLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 64)
            subLabelBottomAnchor.isActive = true
        subLabel.sizeToFit()
        
        subView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: gradientContainer.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func animateText(text: String) {
        UIView.animate(withDuration: animationIn, animations: {
            self.mainLabel.alpha = 0
        }) { (success) in
            self.setMainLabel(text: text)
        }
    }
    
    func setMainLabel(text: String) {
        mainLabel.text = text
        mainLabelBottomAnchor.constant = 32
        view.layoutIfNeeded()
        
        mainLabelBottomAnchor.constant = 0
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.mainLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.backButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.backButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setSublabel(text: String) {
        if text != "" {
            subLabel.text = text
            guard let height = subLabel.text?.height(withConstrainedWidth: phoneWidth - 40, font: Fonts.SSPRegularH3) else { return }
            gradientNewHeight = gradientHeight + height
            subHeight = height
            
            gradientHeightAnchor.constant = gradientNewHeight
            mainLabelBottomAnchor.isActive = false
            subLabelBottom.isActive = true
            subLabelBottomAnchor.constant = 0
            
            UIView.animate(withDuration: animationOut) {
                self.subLabel.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            subLabel.text = text
            gradientNewHeight = gradientHeight
            
            gradientHeightAnchor.constant = gradientNewHeight
            mainLabelBottomAnchor.isActive = true
            subLabelBottom.isActive = false
            
            UIView.animate(withDuration: animationOut) {
                self.subLabel.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func animateBackButton() {
        UIView.animate(withDuration: animationIn) {
            self.backButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.backButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func setBackButton() {
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(image, for: .normal)
        self.backButton.tag = 0
    }
    
    func setExitButton() {
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(image, for: .normal)
        self.backButton.tag = 1
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension GradientContainerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientHeightAnchor.constant = gradientNewHeight - percent * 60
                mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            } else if translation <= -60 {
                if shouldDismiss {
                    backButton.sendActions(for: .touchUpInside)
                }
            }
        } else {
            if translation < 0 && self.gradientHeightAnchor.constant != gradientNewHeight {
                scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        gradientHeightAnchor.constant = gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientHeightAnchor.constant = gradientNewHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
