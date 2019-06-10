//
//  UserUpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 8/27/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Cosmos
import Mapbox

class UserUpcomingViewController: UIViewController {
    
    let cellHeight: CGFloat = 202
    var delegate: handleUpcomingConrollers?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var reservationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reservations"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPBoldH2
        
        return label
    }()
    
    var upcomingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "History"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPBoldH2
        label.alpha = 0.6
        
        return label
    }()
    
    var selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var horizontalScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        
        return view
    }()
    
    var reservationsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = UIColor.clear
        view.register(ReservationsView.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 200, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        
        return view
    }()
    
    var upcomingTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = UIColor.clear
        view.register(ReservationsView.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 200, right: 0)
        view.contentOffset = CGPoint.zero
        view.decelerationRate = .fast
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = false
        
        horizontalScrollView.delegate = self
        reservationsTableView.delegate = self
        reservationsTableView.dataSource = self
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        setupViews()
    }
    
    var reservationsLabelCenterAnchor: NSLayoutConstraint!
    var reservationsWidth: CGFloat = 0.0
    
    func setupViews() {
        
        self.view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: 204).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 232).isActive = true
        }
        
        gradientContainer.addSubview(reservationsLabel)
        gradientContainer.addSubview(upcomingLabel)
        reservationsWidth = (reservationsLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPBoldH2))!
        reservationsLabelCenterAnchor = reservationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24)
        reservationsLabelCenterAnchor.isActive = true
        reservationsLabel.widthAnchor.constraint(equalToConstant: reservationsWidth).isActive = true
        reservationsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            reservationsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140).isActive = true
            upcomingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140).isActive = true
        case .iphoneX:
            reservationsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 180).isActive = true
            upcomingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 180).isActive = true
        }
        
        upcomingLabel.leftAnchor.constraint(equalTo: reservationsLabel.rightAnchor, constant: 62).isActive = true
        upcomingLabel.widthAnchor.constraint(equalToConstant: (upcomingLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPBoldH2))!).isActive = true
        upcomingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        gradientContainer.addSubview(selectionLine)
        selectionLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        selectionLine.topAnchor.constraint(equalTo: reservationsLabel.bottomAnchor, constant: 4).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(horizontalScrollView)
        horizontalScrollView.contentSize = CGSize(width: phoneWidth * 2, height: self.view.frame.height)
        horizontalScrollView.topAnchor.constraint(equalTo: selectionLine.bottomAnchor, constant: 8).isActive = true
        horizontalScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        horizontalScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        horizontalScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        horizontalScrollView.addSubview(reservationsTableView)
        reservationsTableView.leftAnchor.constraint(equalTo: horizontalScrollView.leftAnchor).isActive = true
        reservationsTableView.topAnchor.constraint(equalTo: selectionLine.bottomAnchor, constant: -8).isActive = true
        reservationsTableView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        reservationsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
        
        horizontalScrollView.addSubview(upcomingTableView)
        upcomingTableView.leftAnchor.constraint(equalTo: reservationsTableView.rightAnchor).isActive = true
        upcomingTableView.topAnchor.constraint(equalTo: selectionLine.bottomAnchor, constant: -8).isActive = true
        upcomingTableView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        upcomingTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
        
    }
    
}

extension UserUpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openRecentController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = reservationsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ReservationsView {
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            let translation = scrollView.contentOffset.x
            var percentage = translation/phoneWidth
            if percentage >= 0 && percentage <= 0.9 {
                percentage = percentage/0.9
                self.reservationsLabel.alpha = 1 - 0.4 * percentage
                self.upcomingLabel.alpha = 0.6 + 0.4 * percentage
                self.reservationsLabelCenterAnchor.constant = 24 - (self.reservationsWidth + 64) * percentage
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

class ReservationsView: UITableViewCell {
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var dateLabel: UILabel = {
        let view = UILabel()
        view.text = "5:50pm - 6:45pm"
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        
        return view
    }()
    
    lazy var mapView: MGLMapView = {
        let view = MGLMapView(frame: CGRect(x: 0, y: 0, width: 400, height: 45))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsUserLocation = true
        view.showsScale = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.logoView.isHidden = true
        view.attributionButton.isHidden = true
        view.isUserInteractionEnabled = false
        view.showsUserLocation = false
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let origImage = UIImage(named: "background4")
        imageView.image = origImage
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.OFF_WHITE
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Graham"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPBoldH4
        
        return label
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 1
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 16
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.LIGHT_BLUE
        view.settings.emptyBorderColor = UIColor.clear
        view.settings.filledBorderColor = Theme.BLUE
        view.settings.emptyColor = UIColor.clear
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.9"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH6
        
        return label
    }()
    
    var paymentLabel: UILabel = {
        let view = UILabel()
        view.text = "Payment"
        view.font = Fonts.SSPRegularH6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        view.textAlignment = .right
        
        return view
    }()
    
    var paymentAmount: UILabel = {
        let view = UILabel()
        view.text = "$34.74"
        view.font = Fonts.SSPBoldH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        view.textAlignment = .right
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        addSubview(container)
        addSubview(mapView)
        addSubview(dateLabel)
        addSubview(profileImageView)
        addSubview(userName)
        addSubview(stars)
        addSubview(starsLabel)
        addSubview(paymentLabel)
        addSubview(paymentAmount)
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        mapView.styleURL = url
        let location = CLLocationCoordinate2D(latitude: 40.0150, longitude: -105.2705)
        var center = location
        center.latitude = center.latitude + 0.0002
        center.longitude = center.longitude + 0.0006
        mapView.setCenter(center, zoomLevel: 16, animated: false)
        let annotation = MGLPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        dateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        mapView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        mapView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        mapView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 14).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        userName.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userName.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        userName.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -2).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stars.leftAnchor.constraint(equalTo: userName.leftAnchor, constant: -2).isActive = true
        stars.widthAnchor.constraint(equalToConstant: 16).isActive = true
        stars.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: -4).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        starsLabel.leftAnchor.constraint(equalTo: stars.rightAnchor, constant: 4).isActive = true
        starsLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        starsLabel.centerYAnchor.constraint(equalTo: stars.centerYAnchor).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        paymentLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        paymentLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        paymentLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -2).isActive = true
        paymentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        paymentAmount.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        paymentAmount.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        paymentAmount.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: -2).isActive = true
        paymentAmount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}








