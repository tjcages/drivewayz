//
//  TestParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 3/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol handleTestParking {
    func bookSpotPressed(amount: Double)
}

class ParkingViewController: UIViewController, handleTestParking {
    
    var delegate: handleCheckoutParking?
    var navigationDelegate: handleRouteNavigation?
    var locatorDelegate: handleLocatorButton?
    var parkingDelegate: handleParkingOptions?
    
    let identifier = "cellID"
    let cellHeight: CGFloat = 242
    let cellWidth: CGFloat = phoneWidth
    
    var bookingLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var bookingPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: bookingLayout)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor.clear
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(BookingCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.isPagingEnabled = true
        
        return picker
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Book Prime Spot", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var bookingSliderController: BookingSliderViewController = {
        let controller = BookingSliderViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration:"
        label.textColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.7)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var timeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "time")
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLUE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var timeLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("2 hours 15 minutes", for: .normal)
        label.setTitleColor(Theme.BLUE, for: .normal)
        label.titleLabel?.font = Fonts.SSPSemiBoldH4
        label.contentHorizontalAlignment = .right
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingPicker.delegate = self
        bookingPicker.dataSource = self
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 8
        
        setupViews()
        setupCalendar()
    }
    
    func setData(closestParking: [ParkingSpots], cheapestParking: [ParkingSpots], overallDestination: CLLocationCoordinate2D) {

    }
    
    func setupViews() {
        
        self.view.addSubview(mainButton)
        self.view.addSubview(bookingPicker)
        self.view.addSubview(bookingSliderController.view)
        
        bookingPicker.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        bookingPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookingPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bookingPicker.bottomAnchor.constraint(equalTo: mainButton.topAnchor).isActive = true
        
        mainButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28).isActive = true
        mainButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        mainButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        bookingSliderController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bookingSliderController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bookingSliderController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bookingSliderController.view.bottomAnchor.constraint(equalTo: bookingPicker.topAnchor).isActive = true
        
    }
    
    func setupCalendar() {
        
        self.view.addSubview(durationLabel)
        durationLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -12).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        durationLabel.sizeToFit()
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(timeButton)
        timeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        timeLabel.sizeToFit()
        
        timeButton.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -6).isActive = true
        timeButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -16).isActive = true
        timeButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        timeButton.widthAnchor.constraint(equalTo: timeButton.heightAnchor).isActive = true
        
        self.view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: timeButton.topAnchor, constant: -14).isActive = true
        line.leftAnchor.constraint(equalTo: mainButton.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: mainButton.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func bookSpotPressed(amount: Double) {

    }
    
    @objc func becomeAHost(sender: UIButton) {
        self.delegate?.becomeAHost()
    }
    
    func changeDates(fromDate: Date, totalTime: String) {
        var timeString = totalTime
        timeString = timeString.replacingOccurrences(of: "hrs", with: "hours")
        timeString = timeString.replacingOccurrences(of: "hr", with: "hour")
        timeString = timeString.replacingOccurrences(of: "min", with: "minutes")
        self.timeLabel.setTitle(timeString, for: .normal)
    }

}


extension ParkingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let contentSize = collectionView.contentSize
        self.bookingSliderController.scrollView.contentSize = contentSize
        
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! BookingCell
        
        delayWithSeconds(2) {
            cell.endAnimations()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        self.bookingSliderController.translation = translation
        let percentage = translation/phoneWidth
        if percentage == 0 && self.mainButton.titleLabel?.text != "Book Prime Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Prime Spot", for: .normal)
                }, completion: nil)
            }
        } else if percentage == 1 && self.mainButton.titleLabel?.text != "Book Economy Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Economy Spot", for: .normal)
                }, completion: nil)
            }
        } else if percentage == 2 && self.mainButton.titleLabel?.text != "Book Standard Spot" {
            UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                self.mainButton.setTitle("", for: .normal)
            }) { (success) in
                UIView.transition(with: self.mainButton, duration: animationIn, options: .transitionCrossDissolve, animations: {
                    self.mainButton.setTitle("Book Standard Spot", for: .normal)
                }, completion: nil)
            }
        }
    }
    
}

