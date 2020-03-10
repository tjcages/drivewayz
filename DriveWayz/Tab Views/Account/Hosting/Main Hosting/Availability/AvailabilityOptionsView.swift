//
//  AvailablityOptionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

struct AvailabilityOptions {
    let text: String
    let icon: UIImage?
}

class AvailabilityOptionsView: UIViewController {
    
    var availabilityDelegate: HostAvailabilityDelegate?
    
    var removeString: String = "inactive"
    var options: [AvailabilityOptions] = [] {
        didSet {
            optionsTable.reloadData()
        }
    }
    
    lazy var optionsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(AvailabilityOptionsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTable.delegate = self
        optionsTable.dataSource = self

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(optionsTable)
        optionsTable.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func cellSelected() {
        let cells = optionsTable.visibleCells as! [AvailabilityOptionsCell]
        for cell in cells {
            cell.cellSelected = true
        }
    }
    
    func cellUnselected() {
        let cells = optionsTable.visibleCells as! [AvailabilityOptionsCell]
        for cell in cells {
            cell.cellSelected = false
        }
    }
    
}

extension AvailabilityOptionsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AvailabilityOptionsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if options.count > indexPath.row {
            let option = options[indexPath.row]
            cell.option = option
            if option.text.contains(removeString) {
                cell.mainLabel.textColor = Theme.SALMON
                cell.iconButton.tintColor = Theme.SALMON
            } else {
                cell.mainLabel.textColor = Theme.BLACK
                cell.iconButton.tintColor = Theme.BLACK
            }
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AvailabilityOptionsCell
        if let title = cell.mainLabel.text {
            if title == "See full availability" {
                availabilityDelegate?.showFullAvailability()
            } else if title == "Mark spot inactive" {
                availabilityDelegate?.markSpotInactive()
            } else if title == "See full calendar" {
                availabilityDelegate?.showFullCalendar()
            } else if title == "Reservation settings" {
                availabilityDelegate?.showReservationSettings()
            }
        }
    }
    
}

class AvailabilityOptionsCell: UITableViewCell {
    
    var cellSelected: Bool = false {
        didSet {
            UIView.animate(withDuration: animationIn) {
                if self.cellSelected {
                    self.iconButton.tintColor = Theme.WHITE
                    self.mainLabel.textColor = Theme.WHITE
                    self.backgroundColor = Theme.BLUE
                } else {
                    self.iconButton.tintColor = Theme.BLACK
                    self.mainLabel.textColor = Theme.BLACK
                    self.backgroundColor = Theme.WHITE
                }
            }
        }
    }
    
    var option: AvailabilityOptions? {
        didSet {
            if let option = option {
                mainLabel.text = option.text
                iconButton.setImage(option.icon?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        }
    }
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Theme.BLACK
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(iconButton)
        addSubview(mainLabel)
        
        iconButton.anchor(top: nil, left: leftAnchor, bottom: nil, right:  nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
