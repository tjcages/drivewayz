//
//  UserVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

protocol handlePercentage {
    func changePercentage(translation: CGFloat)
}

class UserVehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, handlePercentage {
    
    var delegate: moveControllers?
    
    var options: [String] = ["2001 Toyota 4Runner", "2007 Honda Pilot", "2018 Audi R4", "Add a vehicle"]
    var optionsSub: [String] = ["123-ZFA", "345-IBA", "567-GLA", ""]
    var optionsImages: [UIImage] = [UIImage(), UIImage(), UIImage(), UIImage()]
    let cellId = "cellId"
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(VehicleCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    lazy var currentVehicleController: CurrentVehicleViewController = {
        let controller = CurrentVehicleViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self

        return controller
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = Theme.GREEN_PIGMENT.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = Theme.GREEN_PIGMENT
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(bringBackMain))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        setupViews()
    }
    
    var containerHeightAnchor: NSLayoutConstraint!
    var containerCenterAnchor: NSLayoutConstraint!
    var optionsHeight: NSLayoutConstraint!
    var currentAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerHeightAnchor = container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 160)
        containerHeightAnchor.isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        container.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = .zero
        containerCenterAnchor = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        containerCenterAnchor.isActive = true
        scrollView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        optionsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        optionsTableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        optionsHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 60)
        optionsHeight.isActive = true

        self.view.addSubview(currentVehicleController.view)
        currentVehicleController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        currentVehicleController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        currentVehicleController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        currentAnchor = currentVehicleController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width)
        currentAnchor.isActive = true
        
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 26).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 38).isActive = true
        }
        
        scrollView.addSubview(checkmark)
        checkmark.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: 40).isActive = true
        
    }
    
    @objc func backButtonPressed(sender: UIButton) {
        self.currentVehicleController.scrollView.setContentOffset(.zero, animated: true)
        self.bringBackMain()
    }
    
    @objc func bringBackMain() {
        self.view.endEditing(true)
        UIView.animate(withDuration: animationOut, animations: {
            self.delegate?.changeMainLabel(text: "Vehicle")
            self.delegate?.moveMainLabel(percent: 0)
            self.containerHeightAnchor.constant = 160
            self.containerCenterAnchor.constant = 0
            self.currentAnchor.constant = self.view.frame.width
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.delegate?.bringExitButton()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionsHeight.constant = CGFloat(60 * self.options.count)
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! VehicleCell
        cell.titleLabel.text = options[indexPath.row]
        if optionsSub[indexPath.row] == "" {
            cell.titleTopAnchor.isActive = false
            cell.titleCenterAnchor.isActive = true
        } else {
            cell.titleTopAnchor.isActive = true
            cell.titleCenterAnchor.isActive = false
        }
        cell.titleLeftAnchor.constant = -20
        cell.subtitleLabel.text = optionsSub[indexPath.row]
        cell.iconView.setImage(optionsImages[indexPath.row], for: .normal)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        cell.selectionStyle = .none
        if cell.titleLabel.text == "Add a vehicle" {
            cell.titleLabel.textColor = Theme.SEA_BLUE
            cell.plusButton.alpha = 1
        } else {
            cell.titleLabel.textColor = Theme.BLACK
            cell.plusButton.alpha = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! VehicleCell
        cell.titleLabel.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! VehicleCell
        if options[indexPath.row] == "Add a vehicle" {
            cell.titleLabel.textColor = Theme.SEA_BLUE
        } else {
            cell.titleLabel.textColor = Theme.BLACK
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! VehicleCell
        if let title = cell.titleLabel.text, let subtitle = cell.subtitleLabel.text {
            if title != "" && subtitle != "" {
                self.currentVehicleController.setData(type: title, license: subtitle)
                self.currentVehicleController.setupCurrentVehicle()
            } else {
                self.delegate?.changeMainLabel(text: "Add a vehicle")
                self.currentVehicleController.setupNewVehicle()
            }
            self.moveToNext()
        }
    }
    
    func moveToNext() {
        UIView.animate(withDuration: animationIn) {
            self.delegate?.hideExitButton()
            self.backButton.alpha = 1
            self.containerCenterAnchor.constant = -self.view.frame.width/2
            self.currentAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        changePercentage(translation: translation)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation < 30 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 0
            }
        } else if translation >= 30 && translation <= 50 {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset.y = 50
            }
        }
    }
    
    func changePercentage(translation: CGFloat) {
        if translation <= 50 && translation >= 10 {
            let percent = (translation-10)/40
            switch device {
            case .iphone8:
                self.containerHeightAnchor.constant = 160 - (percent * 80)
            case .iphoneX:
                self.containerHeightAnchor.constant = 160 - (percent * 90)
            }
            self.delegate?.moveMainLabel(percent: percent)
        } else if translation < 10 {
            self.containerHeightAnchor.constant = 160
            self.delegate?.moveMainLabel(percent: 0)
        } else {
            self.delegate?.moveMainLabel(percent: 1)
            switch device {
            case .iphone8:
                self.containerHeightAnchor.constant = 80
            case .iphoneX:
                self.containerHeightAnchor.constant = 90
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
