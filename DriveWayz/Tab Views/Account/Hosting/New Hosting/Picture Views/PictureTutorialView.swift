//
//  PictureTutorialView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PictureTutorialView: UIViewController {

    var delegate: HandleHostPictures?
    lazy var bottomAnchor: CGFloat = -16
    var shouldPan: Bool = true
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight + cancelBottomHeight * 2))
        
        return view
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    let paging = HorizontalPagingDisplay()
    var pagingView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.decelerationRate = .fast
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    var firstTutorialView: TutorialExampleView = {
        let controller = TutorialExampleView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = "Choose a picture or use Google Streetview"
        controller.informationLabel.text = "Make sure the spot is completely visible so drivers will know where to pull in."
        controller.imageView.contentMode = .scaleAspectFill
        if let image = UIImage(named: "photoTutorial1") {
            controller.imageView.image = image
        }
        
        return controller
    }()
    
    var secondTutorialView: TutorialExampleView = {
        let controller = TutorialExampleView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = "Drag the corners of the highlighted region over the spot"
        controller.informationLabel.text = "Use this to mark the boundaries of where drivers can park."
        controller.imageView.contentMode = .scaleAspectFill
        if let image = UIImage(named: "photoTutorial2") {
            controller.imageView.image = image
        }
        
        return controller
    }()
    
    var thirdTutorialView: TutorialExampleView = {
        let controller = TutorialExampleView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.exampleButton.alpha = 0
        controller.mainLabel.text = "Your images stay hidden until a driver books the space"
        controller.informationLabel.text = "Host information will always be protected."
        controller.imageView.contentMode = .center
        if let image = UIImage(named: "flat-lock") {
            controller.imageView.image = image
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagingView.delegate = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
        setupScroll()
    }
    
    var nextBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        view.addSubview(pullButton)
        
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(pagingView)
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 70, height: 70)
        nextBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextBottomAnchor.isActive = true
        
    }

    func setupScroll() {
        
        pagingView.contentSize = CGSize(width: phoneWidth * 4, height: 100)
        pagingView.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        pagingView.addSubview(firstTutorialView.view)
        pagingView.addSubview(secondTutorialView.view)
        pagingView.addSubview(thirdTutorialView.view)
        let controllerHeight: CGFloat = 372

        firstTutorialView.view.anchor(top: nil, left: pagingView.leftAnchor, bottom: nextButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: phoneWidth, height: controllerHeight)
        
        secondTutorialView.view.anchor(top: nil, left: firstTutorialView.view.rightAnchor, bottom: nextButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: phoneWidth, height: controllerHeight)
        
        thirdTutorialView.view.anchor(top: nil, left: secondTutorialView.view.rightAnchor, bottom: nextButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: phoneWidth, height: controllerHeight)
        
        container.addSubview(paging)
        paging.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paging.topAnchor.constraint(equalTo: firstTutorialView.view.topAnchor, constant: (phoneWidth - 40) * 0.62 + 16).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 53).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        container.anchor(top: firstTutorialView.view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func nextButtonPressed() {
        let translation = pagingView.contentOffset.x
        if translation == 0 {
            pagingView.setContentOffset(CGPoint(x: phoneWidth, y: 0), animated: true)
            scrollViewDidScroll(pagingView)
        } else if translation == phoneWidth {
            pagingView.setContentOffset(CGPoint(x: phoneWidth * 2, y: 0), animated: true)
            scrollViewDidScroll(pagingView)
        } else {
            dismissView()
        }
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        if shouldPan {
            let state = sender.state
            let translation = sender.translation(in: self.view).y
            if state == .changed {
                self.nextBottomAnchor.constant = self.bottomAnchor + translation/1.5
                self.view.layoutIfNeeded()
                if translation >= 160 || translation <= -320 {
                    self.nextBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                    self.dismissView()
                }
            } else if state == .ended {
                let difference = abs(self.nextBottomAnchor.constant) + self.bottomAnchor
                if difference >= 160 {
                    self.dismissView()
                } else {
                    self.nextBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    @objc func dismissView() {
        if shouldPan {
            delegate?.removeDim()
            dismiss(animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// Change the Paging control as user scrolls
extension PictureTutorialView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        var percentage = translation/phoneWidth
        paging.changeScroll(percentage: percentage)
        
        if percentage < 0 {
            firstTutorialView.view.alpha = 1
        } else if percentage >= 0 && percentage <= 1.0 {
            firstTutorialView.view.alpha = 1 - 1 * percentage
            secondTutorialView.view.alpha = 0 + 1 * percentage
        } else if percentage > 1.0 && percentage <= 2.0 {
            percentage -= 1.0
            secondTutorialView.view.alpha = 1 - 1 * percentage
            thirdTutorialView.view.alpha = 0 + 1 * percentage
        } else if percentage >= 2.0 && percentage <= 2.3 {
            thirdTutorialView.view.alpha = 1
        } else {
            dismissView()
        }
    }
}
