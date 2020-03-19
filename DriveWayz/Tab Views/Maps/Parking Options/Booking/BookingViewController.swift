//
//  BookingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

var parkingNormalHeight: CGFloat = 430 {
    didSet {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "readjustBookingHeight"), object: nil)
    }
}

var exactRouteLine: Bool = true

class BookingViewController: UIViewController {
    
    var delegate: HandleMapBooking?
    var spotType: SpotType = .Public
    var cellHeight: CGFloat = 100
    
    var bookingOpen: Bool = false {
        didSet {
            bookingTableView.reloadData()
        }
    }
    
    var sortedBookingLots: [ParkingLot] = [] {
        didSet {
            bookingTableView.reloadData()
        }
    }
    
    var selectedIndex: IndexPath?
    
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 72
    let scrollBottomInset: CGFloat = 122

    lazy var bookingTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookingSpotView.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.clipsToBounds = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: abs(cancelBottomHeight) + 64, right: 0)
        
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
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Start Navigation", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        bookingTableView.delegate = self
        bookingTableView.dataSource = self

        setupViews()
    }
    
    var bookingTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(slideBar)
        view.addSubview(line)
        
        slideBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slideBar.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 4)
        
        line.anchor(top: slideBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(bookingTableView)
        bookingTableView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bookingTopAnchor = bookingTableView.topAnchor.constraint(equalTo: line.bottomAnchor)
            bookingTopAnchor.isActive = true
        
        view.addSubview(mainView)
        view.addSubview(mainButton)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: cancelBottomHeight, paddingRight: 20, width: 0, height: 56)
        
        mainView.anchor(top: mainButton.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func mainButtonPressed() {
        delegate?.startNavigation()
    }
    
}

extension BookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func selectFirstIndex() {
        let index = IndexPath(row: 0, section: 0)
        if bookingTableView.cellForRow(at: index) != nil {
            bookingTableView.scrollToTop(animated: false)
            tableView(bookingTableView, didSelectRowAt: index)
        }
    }
    
    func unselectFirstIndex() {
        if let index = selectedIndex, let previousCell = bookingTableView.cellForRow(at: index) as? BookingSpotView {
            previousCell.didSelect = false
            previousCell.unselectedView()
            selectedIndex = nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sortedBookingLots.count >= 6 {
            return 6
        }
        return sortedBookingLots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookingSpotView
        
        cell.selectionStyle = .none
        cell.didSelect = false
        
        if sortedBookingLots.count > indexPath.row {
            let lot = sortedBookingLots[indexPath.row]
            cell.parkingLot = lot
        }
        
        if let index = selectedIndex, index == indexPath {
            cell.selectedView()
        }
        
        if indexPath.row == 2 {
            cell.line.alpha = 0
        } else {
            cell.line.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookingSpotView
        
        if let lot = cell.parkingLot {
//            exactRouteLine = lot.minprice ?? "" != "nan" // Uncomment for free lots to not calculate exact route
            delegate?.drawHostPolyline(lot: lot, index: indexPath.row)
        }
        
        if let index = selectedIndex, index != indexPath, let previousCell = tableView.cellForRow(at: index) as? BookingSpotView {
            previousCell.didSelect = false
        }
        
        if !cell.didSelect {
            cell.didSelect = true
            selectedIndex = indexPath
        }
    }

}

extension BookingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if headerView.alpha == 1 {
//            scrollView.isScrollEnabled = false
//        }
        let translation = scrollView.contentOffset.y
        if translation <= 0.0 {
            let percentage = -translation/40
            if slideBar.alpha == 0 {
                delegate?.changeBookingScroll(percentage: percentage)
            }
            if percentage >= 1.0 {
                delegate?.closeBooking()
            }
        }
    }
    
    func changeBookingScrollAmount(percentage: CGFloat) {
        if percentage <= 0.5 {
            slideBar.alpha = 1 - percentage * 2
            line.alpha = 1 - percentage * 2
        }
        
        bookingTopAnchor.constant = -42 * percentage
        view.layoutIfNeeded()
    }
    
    func openBooking() {
        bookingOpen = true
        bookingTopAnchor.constant = -42
        UIView.animate(withDuration: animationIn) {
            self.slideBar.alpha = 0
            self.line.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBooking() {
        bookingOpen = false
        bookingTopAnchor.constant = 0
        bookingTableView.scrollToTop(animated: false)
        UIView.animate(withDuration: animationIn) {
            self.bookingTableView.isScrollEnabled = false
            self.slideBar.alpha = 1
            self.line.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
}
