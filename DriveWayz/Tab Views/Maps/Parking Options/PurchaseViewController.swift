//
//  BookingController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

var purchaseNormalHeight: CGFloat = 372
var publicNormalHeight: CGFloat = phoneHeight

class PurchaseViewController: UIViewController {
    
    var discount: Int = 0
    
    var bannerView = PurchaseBannerView()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 29
        let image = UIImage(named: "Apartment Parking")
        view.image = image
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shared"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apartment parking"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$9.38"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.textAlignment = .right
        
        return label
    }()
    
    var subCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$10.72"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()

    var subCostLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.GRAY_WHITE
        
        return view
    }()

    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return button
    }()
    
    var informationFilledIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "informationFilledIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.addTarget(self, action: #selector(informationButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Time Booked"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var timeValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:15am to 2:45pm"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 18
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.clipsToBounds = false

        setupViews()
        setupTime()
    }
    
    var bannerHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(bannerView)
        bannerView.anchor(top: nil, left: view.leftAnchor, bottom: view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -56, paddingRight: 0, width: 0, height: 0)
        bannerHeightAnchor = bannerView.heightAnchor.constraint(equalToConstant: 56)
            bannerHeightAnchor.isActive = true
        
        view.addSubview(spotIcon)
        spotIcon.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 20).isActive = true
        spotIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 58).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabel.bottomAnchor.constraint(equalTo: spotIcon.centerYAnchor, constant: 4).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: spotIcon.rightAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: spotIcon.centerYAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.sizeToFit()
        
        view.addSubview(costLabel)
        view.addSubview(subCostLabel)
        view.addSubview(subCostLine)
        
        costLabel.bottomAnchor.constraint(equalTo: spotIcon.centerYAnchor, constant: 4).isActive = true
        costLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        costLabel.sizeToFit()
        
        subCostLabel.topAnchor.constraint(equalTo: spotIcon.centerYAnchor, constant: 4).isActive = true
        subCostLabel.rightAnchor.constraint(equalTo: costLabel.rightAnchor).isActive = true
        subCostLabel.sizeToFit()
        
        view.addSubview(subCostLine)
        subCostLine.anchor(top: nil, left: subCostLabel.leftAnchor, bottom: nil, right: subCostLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        subCostLine.centerYAnchor.constraint(equalTo: subCostLabel.centerYAnchor).isActive = true
        
        view.addSubview(informationIcon)
        view.addSubview(informationFilledIcon)
        
        informationIcon.anchor(top: nil, left: subLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        informationIcon.centerYAnchor.constraint(equalTo: subLabel.centerYAnchor).isActive = true
        
        informationFilledIcon.anchor(top: nil, left: nil, bottom: nil, right: costLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 20, height: 20)
        informationFilledIcon.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor).isActive = true
        
    }
    
    func setupTime() {
        
        view.addSubview(timeLabel)
        view.addSubview(timeValue)
        view.addSubview(editButton)
        
        timeLabel.topAnchor.constraint(equalTo: spotIcon.bottomAnchor, constant: 20).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        timeLabel.sizeToFit()
        
        timeValue.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
        timeValue.leftAnchor.constraint(equalTo: timeLabel.leftAnchor).isActive = true
        timeValue.sizeToFit()
        
        editButton.bottomAnchor.constraint(equalTo: timeValue.bottomAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
    }
    
    @objc func informationButtonPressed() {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 0.6
        }) { (success) in
            let controller = PaymentBreakdownViewController()
            if let cost = self.costLabel.text {
//                let hourlyCost = String(format: "$%.2f", price)
                controller.setData(totalCost: cost, hourlyCost: cost, discount: self.discount)
            }
            let navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    @objc func expandBanner() {
        bannerHeightAnchor.constant = 196
        bannerView.expandBanner()
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func minimizeBanner() {
        bannerHeightAnchor.constant = 56
        bannerView.minimizeBanner()
        UIView.animate(withDuration: animationIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }

}
