//
//  ReservationsTableViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos
import Mapbox

class ReservationsTableViewController: UIViewController {
    
    let cellHeight: CGFloat = 202
    var delegate: handleHostingReservations?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.isHidden = true
        
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
        label.text = "Upcoming"
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
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = false
        
        return view
    }()
    
    var reservationsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = UIColor.clear
        view.register(ReservationsView.self, forCellReuseIdentifier: "cellId")
        view.contentInset = UIEdgeInsets(top: 52, left: 0, bottom: 200, right: 0)
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
        view.contentInset = UIEdgeInsets(top: 52, left: 0, bottom: 200, right: 0)
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
            gradientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
            let background = CAGradientLayer().purpleBlueColor()
            background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 160)
            background.zPosition = -10
            gradientContainer.layer.addSublayer(background)
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
            let background = CAGradientLayer().purpleBlueColor()
            background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 180)
            background.zPosition = -10
            gradientContainer.layer.addSublayer(background)
        }
        
        self.view.addSubview(horizontalScrollView)
        self.view.bringSubviewToFront(gradientContainer)
        horizontalScrollView.contentSize = CGSize(width: phoneWidth * 2, height: self.view.frame.height)
        horizontalScrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -24).isActive = true
        horizontalScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        horizontalScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        horizontalScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        horizontalScrollView.addSubview(reservationsTableView)
        reservationsTableView.leftAnchor.constraint(equalTo: horizontalScrollView.leftAnchor).isActive = true
        reservationsTableView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -24).isActive = true
        reservationsTableView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        reservationsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
        
        horizontalScrollView.addSubview(upcomingTableView)
        upcomingTableView.leftAnchor.constraint(equalTo: reservationsTableView.rightAnchor).isActive = true
        upcomingTableView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -24).isActive = true
        upcomingTableView.widthAnchor.constraint(equalToConstant: phoneWidth).isActive = true
        upcomingTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80).isActive = true
        
        self.view.addSubview(reservationsLabel)
        reservationsWidth = (reservationsLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPBoldH2))!
        reservationsLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -24).isActive = true
        reservationsLabelCenterAnchor = reservationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24)
        reservationsLabelCenterAnchor.isActive = true
        reservationsLabel.widthAnchor.constraint(equalToConstant: reservationsWidth).isActive = true
        reservationsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(upcomingLabel)
        upcomingLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -24).isActive = true
        upcomingLabel.leftAnchor.constraint(equalTo: reservationsLabel.rightAnchor, constant: 62).isActive = true
        upcomingLabel.widthAnchor.constraint(equalToConstant: (upcomingLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPBoldH2))!).isActive = true
        upcomingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(selectionLine)
        selectionLine.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        selectionLine.topAnchor.constraint(equalTo: reservationsLabel.bottomAnchor, constant: 4).isActive = true
        selectionLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        selectionLine.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }

}

extension ReservationsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.hostingPreviousPressed()
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
