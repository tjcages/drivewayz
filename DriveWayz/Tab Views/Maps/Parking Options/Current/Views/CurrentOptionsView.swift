//
//  CurrentOptionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentOptionsView: UIView {
    
    var delegate: CurrentViewDelegate?
    
    let options: [BookingOptions] = [BookingOptions(mainText: "Extend duration", subText: nil, iconImage: UIImage(named: "hostAvailabilityIcon")?.withRenderingMode(.alwaysTemplate)), BookingOptions(mainText: "Report issue", subText: nil, iconImage: UIImage(named: "helpIssue")?.withRenderingMode(.alwaysTemplate)), BookingOptions(mainText: "End booking", subText: nil, iconImage: UIImage(named: "helpDelete")?.withRenderingMode(.alwaysTemplate))]
    
    var optionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Options"
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()

    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BookingOptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Theme.WHITE
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(optionsLabel)
        optionsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        optionsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        optionsLabel.sizeToFit()
        
        addSubview(optionsTableView)
        optionsTableView.anchor(top: optionsLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        cell.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        cell.backgroundColor = Theme.WHITE
        
        if indexPath.row < options.count {
            cell.option = options[indexPath.row]
            if indexPath.row == options.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
            }
        }
        if cell.mainLabel.text == "End booking" {
            cell.mainLabel.textColor = Theme.HARMONY_RED
            cell.iconButton.tintColor = Theme.HARMONY_RED
            cell.arrowButton.alpha = 0
        } else if cell.mainLabel.text == "Report issue" {
            cell.mainLabel.textColor = Theme.HARMONY_RED
            cell.iconButton.tintColor = Theme.HARMONY_RED
            cell.arrowButton.alpha = 1
        } else {
            cell.mainLabel.textColor = Theme.DARK_GRAY
            cell.iconButton.tintColor = Theme.BLACK
            cell.arrowButton.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! BookingOptionsCell
//        if cell.mainLabel.text == "Report a problem" {
//            delegate?.bookingOptionsPressed()
//        } else if cell.mainLabel.text == "Parking spot was taken" {
//             delegate?.parkingTakenPressed()
//        } else if cell.mainLabel.text == "End booking" {
//            delegate?.askToEndReservation()
//        }
    }
    
}
