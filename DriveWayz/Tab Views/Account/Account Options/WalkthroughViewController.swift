//
//  WalkthroughViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    var delegate: controlsNewParking?
    
    var termsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var blurBackgroundStartup: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.6
        
        return blurView
    }()
    
    var terms: UILabel = {
        let label = UILabel()
        label.textColor = Theme.PRIMARY_COLOR
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.text = "Welcome to Drivewayz"
        
        return label
    }()
    
    var segmentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var text: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = """
        We're reinventing the way you think about parking by creating a network of private spots, now made public.
        
        Park closer, quicker, safer and cheaper in any of our hosts' spots.
        
        Become a host and make easy money by renting out yours!
        """
        label.numberOfLines = 15
        
        return label
    }()
    
    var text1: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "This is your home page. Enter your destination and view nearby parking options."
        label.numberOfLines = 4
        
        return label
    }()
    
    var image2: UIImageView = {
        let image = UIImageView()
        let parking = UIImage(named: "exampleParking")
        image.image = parking
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    var text2: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "List your empty parking spot here and make quick and easy cash while helping others!"
        label.numberOfLines = 3
        
        return label
    }()
    
    var image3: UIImageView = {
        let image = UIImageView()
        let parking = UIImage(named: "exampleCar")
        image.image = parking
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    var text3: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "All you need to begin finding cheap parking is upload some information about your vehicle!"
        label.numberOfLines = 3
        
        return label
    }()
    
    var startupPages: UIPageControl = {
        let page = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
        page.numberOfPages = 4
        page.currentPage = 0
        page.tintColor = Theme.DARK_GRAY
        page.pageIndicatorTintColor = Theme.DARK_GRAY
        page.currentPageIndicatorTintColor = Theme.PRIMARY_COLOR
        page.translatesAutoresizingMaskIntoConstraints = false
        page.isUserInteractionEnabled = false
        
        return page
    }()
    
    var accept: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(nextPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var back: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start!", for: .normal)
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        button.alpha = 0
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTerms()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var nextAnchor: NSLayoutConstraint!
    var lastAnchor: NSLayoutConstraint!
    var confirmAnchor: NSLayoutConstraint!
    var confirmWidthAnchor: NSLayoutConstraint!
    var segmentTopAnchor: NSLayoutConstraint!
    var termsContainerHeightAnchor: NSLayoutConstraint!
    var termsContainerCenterAnchor: NSLayoutConstraint!
    var mapTextAnchor: NSLayoutConstraint!
    
    func setupTerms() {
        
        self.view.addSubview(blurBackgroundStartup)
        blurBackgroundStartup.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurBackgroundStartup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurBackgroundStartup.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurBackgroundStartup.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(termsContainer)
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(segmentLeft(sender:)))
        gestureLeft.direction = .left
        termsContainer.addGestureRecognizer(gestureLeft)
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(pageBack(sender:)))
        gestureRight.direction = .right
        termsContainer.addGestureRecognizer(gestureRight)
        termsContainerCenterAnchor = termsContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            termsContainerCenterAnchor.isActive = true
        termsContainerHeightAnchor = termsContainer.heightAnchor.constraint(equalToConstant: 400)
            termsContainerHeightAnchor.isActive = true
        termsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        termsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        termsContainer.addSubview(segmentView)
        segmentTopAnchor = segmentView.topAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 60)
            segmentTopAnchor.isActive = true
        segmentView.bottomAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -60).isActive = true
        segmentView.leftAnchor.constraint(equalTo: termsContainer.leftAnchor).isActive = true
        segmentView.rightAnchor.constraint(equalTo: termsContainer.rightAnchor).isActive = true
        
        segmentView.addSubview(text)
        text.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 0).isActive = true
        text.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -20).isActive = true
        text.leftAnchor.constraint(equalTo: segmentView.leftAnchor, constant: 10).isActive = true
        text.rightAnchor.constraint(equalTo: segmentView.rightAnchor, constant: -10).isActive = true
        
        segmentView.addSubview(text1)
        text1.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 0).isActive = true
        text1.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -20).isActive = true
        text1.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mapTextAnchor = text1.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: self.view.frame.width)
            mapTextAnchor.isActive = true
        
        segmentView.addSubview(image2)
        image2.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 0).isActive = true
        image2.heightAnchor.constraint(equalToConstant: 325).isActive = true
        nextAnchor = image2.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: self.view.frame.width)
        nextAnchor.isActive = true
        image2.widthAnchor.constraint(equalTo: segmentView.widthAnchor).isActive = true
        
        segmentView.addSubview(text2)
        text2.topAnchor.constraint(equalTo: image2.bottomAnchor, constant: 0).isActive = true
        text2.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -20).isActive = true
        text2.centerXAnchor.constraint(equalTo: image2.centerXAnchor).isActive = true
        text2.widthAnchor.constraint(equalTo: segmentView.widthAnchor, constant: -20).isActive = true
        
        segmentView.addSubview(image3)
        image3.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 0).isActive = true
        image3.heightAnchor.constraint(equalToConstant: 200).isActive = true
        lastAnchor = image3.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: self.view.frame.width)
        lastAnchor.isActive = true
        image3.widthAnchor.constraint(equalTo: segmentView.widthAnchor).isActive = true
        
        segmentView.addSubview(text3)
        text3.topAnchor.constraint(equalTo: image3.bottomAnchor, constant: 0).isActive = true
        text3.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -20).isActive = true
        text3.centerXAnchor.constraint(equalTo: image3.centerXAnchor).isActive = true
        text3.widthAnchor.constraint(equalTo: segmentView.widthAnchor, constant: -20).isActive = true
        
        termsContainer.addSubview(startupPages)
        startupPages.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startupPages.heightAnchor.constraint(equalToConstant: 20).isActive = true
        startupPages.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        startupPages.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -10).isActive = true
        
        termsContainer.addSubview(terms)
        terms.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        terms.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -20).isActive = true
        terms.centerYAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 30).isActive = true
        terms.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        termsContainer.addSubview(accept)
        confirmAnchor = accept.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor)
            confirmAnchor.isActive = true
        confirmWidthAnchor = accept.widthAnchor.constraint(equalToConstant: 160)
            confirmWidthAnchor.isActive = true
        accept.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -30).isActive = true
        accept.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsContainer.addSubview(back)
        back.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor, constant: -70).isActive = true
        back.widthAnchor.constraint(equalToConstant: 120).isActive = true
        back.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -30).isActive = true
        back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func segmentLeft(sender: UISwipeGestureRecognizer) {
        nextPressedFunc()
    }
    
    @objc func nextPressed(sender: UIButton) {
        nextPressedFunc()
    }
    
    func nextPressedFunc() {
        self.accept.isUserInteractionEnabled = false
        if self.text.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.terms.alpha = 0
                self.text.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.terms.alpha = 0
                self.accept.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.startupPages.currentPage = 1
                        self.termsContainerCenterAnchor.constant = self.view.frame.height / 2 - 90 - 60
                        self.segmentTopAnchor.constant = 0
                        self.termsContainerHeightAnchor.constant = 180
                        self.blurBackgroundStartup.alpha = 0.3
                        self.view.layoutIfNeeded()
                    })
                }, completion: { (success) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.termsContainer.alpha = 1
                        self.mapTextAnchor.constant = 0
                    })
                })
            }
        } else if text1.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.termsContainerHeightAnchor.constant = 500
                self.termsContainerCenterAnchor.constant = 0
                self.confirmAnchor.constant = 70
                self.confirmWidthAnchor.constant = 120
                self.text1.alpha = 0
                self.startupPages.currentPage = 2
                self.delegate?.moveTopProfile()
                self.view.layoutIfNeeded()
            }) { (success) in
                self.accept.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.nextAnchor.constant = 0
                    self.back.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else if self.nextAnchor.constant == 0 && text2.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.termsContainerHeightAnchor.constant = 375
                self.confirmAnchor.constant = 0
                self.confirmWidthAnchor.constant = 160
                self.back.alpha = 0
                self.text2.alpha = 0
                self.image2.alpha = 0
                self.startupPages.currentPage = 3
                self.view.layoutIfNeeded()
            }) { (success) in
                self.accept.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.lastAnchor.constant = 0
                    self.text3.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.accept.setTitle("Get started!", for: .normal)
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.termsContainer.alpha = 0
                self.blurBackgroundStartup.alpha = 0
            }) { (success) in
                self.delegate?.moveToMap()
                self.accept.isUserInteractionEnabled = true
                self.view.removeFromSuperview()
                self.blurBackgroundStartup.removeFromSuperview()
                self.termsContainer.removeFromSuperview()
                self.delegate?.setupNewVehicle(vehicleStatus: VehicleStatus.noVehicle)
            }
        }
    }
    
    @objc func pageBack(sender: UISwipeGestureRecognizer) {
        if self.text.alpha == 1 {
            //
        } else if text1.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.termsContainer.alpha = 1
                self.mapTextAnchor.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }) { (success) in
                self.accept.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.startupPages.currentPage = 0
                        self.termsContainerCenterAnchor.constant = 0
                        self.segmentTopAnchor.constant = 60
                        self.termsContainerHeightAnchor.constant = 400
                        self.blurBackgroundStartup.alpha = 0.6
                        self.view.layoutIfNeeded()
                    })
                }, completion: { (success) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.terms.alpha = 1
                        self.text.alpha = 1
                    })
                })
            }
        } else if self.nextAnchor.constant == 0 && text2.alpha == 1 {
            self.delegate?.moveToMap()
            UIView.animate(withDuration: 0.3, animations: {
                self.nextAnchor.constant = self.view.frame.width
                self.back.alpha = 0
                self.confirmAnchor.constant = 0
                self.view.layoutIfNeeded()
            }) { (success) in
                self.accept.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.confirmWidthAnchor.constant = 160
                    self.startupPages.currentPage = 1
                    self.termsContainerCenterAnchor.constant = self.view.frame.height / 2 - 90 - 60
                    self.segmentTopAnchor.constant = 0
                    self.termsContainerHeightAnchor.constant = 180
                    self.blurBackgroundStartup.alpha = 0.3
                    self.mapTextAnchor.constant = 0
                    self.text1.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.lastAnchor.constant = self.view.frame.width
                self.termsContainerHeightAnchor.constant = 500
                self.termsContainerCenterAnchor.constant = 0
                self.confirmAnchor.constant = 60
                self.confirmWidthAnchor.constant = 120
                self.text3.alpha = 0
                self.startupPages.currentPage = 2
                self.view.layoutIfNeeded()
            }) { (success) in
                self.accept.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.nextAnchor.constant = 0
                    self.text2.alpha = 1
                    self.image2.alpha = 1
                    self.back.alpha = 1
                    self.view.layoutIfNeeded()
                })
                self.accept.setTitle("Next", for: .normal)
            }
        }
    }
    
    @objc func backPressed(sender: UIButton) {
        self.delegate?.setupNewParking(parkingImage: ParkingImage.noImage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextPressedFunc()
        }
    }

}
