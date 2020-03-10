//
//  BookingViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CoreLocation

var parkingNormalHeight: CGFloat = 462 {
    didSet {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "readjustBookingHeight"), object: nil)
    }
}

var exactRouteLine: Bool = true
var userEnteredDestination: Bool = true

enum BookingCellStates: CGFloat {
    case selected = 100
    case options = 140
}

class BookingViewController: UIViewController {
    
    var delegate: HandleMapBooking?
    var spotType: SpotType = .Public
    
    var shouldShowOptions: Bool = true {
        didSet {
            if !shouldShowOptions {
                let index = IndexPath(row: 1, section: 0)
                if let previousIndex = selectedIndex, index != previousIndex, let cell = bookingTableView.cellForRow(at: index) as? BookingSpotView {
                    cell.unselectedView()
                    parkingNormalHeight = 430
                }
            } else {
                bookingTableView.reloadData()
            }
        }
    }
    
    var selectedIndex: IndexPath? {
        didSet {
            bookingTableView.performBatchUpdates(nil, completion: nil)
        }
    }
    
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
        button.setTitle("Book Private", for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.setTitleColor(Theme.WHITE.withAlphaComponent(0.5), for: .highlighted)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
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
    
    func setupViews() {
        
        view.addSubview(slideBar)
        view.addSubview(line)
        
        slideBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slideBar.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 4)
        
        line.anchor(top: slideBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(bookingTableView)
        bookingTableView.anchor(top: line.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(mainButton)
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: cancelBottomHeight, paddingRight: 20, width: 0, height: 56)
        
    }
    
    @objc func mainButtonPressed() {
        delegate?.presentPublicController(spotType: self.spotType)
    }
    
}

extension BookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func selectFirstIndex() {
        let index = IndexPath(row: 0, section: 0)
        bookingTableView.selectRow(at: index, animated: true, scrollPosition: .top)
        tableView(bookingTableView, didSelectRowAt: index)
    }
    
    func unselectFirstIndex() {
        if let index = selectedIndex, let previousCell = bookingTableView.cellForRow(at: index) as? BookingSpotView {
            previousCell.didSelect = false
            previousCell.unselectedView()
            selectedIndex = nil
            shouldShowOptions = true
            parkingNormalHeight = 462
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && shouldShowOptions {
            return BookingCellStates.options.rawValue
        }
        return BookingCellStates.selected.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookingSpotView
        
        cell.selectionStyle = .none
        cell.didSelect = false
        
        if indexPath.row == 1 {
            if shouldShowOptions { cell.showMoreOptions() }
        } else if indexPath.row == 2 {
            cell.line.alpha = 0
        } else {
            cell.line.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookingSpotView
        
        if let index = selectedIndex, index != indexPath, let previousCell = tableView.cellForRow(at: index) as? BookingSpotView {
            previousCell.didSelect = false
            if shouldShowOptions { shouldShowOptions = false }
        }
        
        if !cell.didSelect {
            cell.didSelect = true
            selectedIndex = indexPath
        }
    }

}

extension BookingViewController: UIScrollViewDelegate {
    
    func changeBookingScrollAmount(percentage: CGFloat) {
        if percentage <= 0.5 {
            bookingTableView.contentInset = UIEdgeInsets(top: -28 + 28 * percentage, left: 0, bottom: scrollBottomInset, right: 0)
            bookingTableView.scrollToTop(animated: false)
            slideBar.alpha = 1 - percentage * 2
            line.alpha = 1 - percentage * 2
        } else {
//            headerView.alpha = 1 - (percentage - 0.5) * 2
        }
        
        view.layoutIfNeeded()
    }
    
    func openBooking() {
        bookingTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: scrollBottomInset, right: 0)
        bookingTableView.scrollToTop(animated: true)
        UIView.animate(withDuration: animationIn) {
//            self.headerView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBooking() {
        bookingTableView.contentInset = UIEdgeInsets(top: -28, left: 0, bottom: scrollBottomInset, right: 0)
//        bookingTableView.scrollToTop(animated: true)
        UIView.animate(withDuration: animationIn) {
            self.bookingTableView.isScrollEnabled = false
//            self.headerView.alpha = 1
            self.slideBar.alpha = 1
            self.line.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
}
