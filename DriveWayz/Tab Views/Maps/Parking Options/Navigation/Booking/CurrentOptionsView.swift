//
//  CurrentOptionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentOptionsView: UIViewController {
    
    var delegate: handleCurrentBooking?
    let options: [BookingOptions] = [BookingOptions(mainText: "Parking spot was taken", subText: nil, iconImage: nil), BookingOptions(mainText: "Report a problem", subText: nil, iconImage: nil), BookingOptions(mainText: "End booking", subText: nil, iconImage: nil)]

    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookingOptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.separatorStyle = .none
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(optionsTableView)
        optionsTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

}

extension CurrentOptionsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookingOptionsCell
        cell.selectionStyle = .none
        
        if indexPath.row < options.count {
            cell.option = options[indexPath.row]
        }
        if cell.mainLabel.text == "End booking" {
            cell.mainLabel.textColor = Theme.HARMONY_RED
            cell.arrowButton.alpha = 0
        } else {
            cell.mainLabel.textColor = Theme.DARK_GRAY
            cell.arrowButton.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! BookingOptionsCell
        if cell.mainLabel.text == "Report a problem" {
            delegate?.bookingOptionsPressed()
        } else if cell.mainLabel.text == "Parking spot was taken" {
             delegate?.parkingTakenPressed()
        } else if cell.mainLabel.text == "End booking" {
            delegate?.askToEndReservation()
        }
    }
    
}
