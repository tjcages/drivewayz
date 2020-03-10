//
//  AvailabilityFullView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/27/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AvailabilityFullView: UIViewController {
    
    var options: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var selectedTimes: [Int: [Date]] = [:]
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.setBackButton()
        
        return controller
    }()
    
    lazy var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(AvailabilityCell.self, forCellReuseIdentifier: "cellId")
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.separatorStyle = .none
        view.keyboardDismissMode = .interactive
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.alpha = 0
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: gradientHeight, right: 0)
        
        return view
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self

        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text != "Full Availbility" {
            gradientController.animateText(text: "Full Availbility")
        }
        UIView.animate(withDuration: animationIn) {
            self.optionsTableView.alpha = 1
            self.editButton.alpha = 1
        }
    }
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        editButton.bottomAnchor.constraint(equalTo: gradientController.backButton.bottomAnchor).isActive = true
        editButton.sizeToFit()
        
        gradientController.scrollView.addSubview(optionsTableView)
        optionsTableView.anchor(top: gradientController.scrollView.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func editPressed() {
        let controller = HostAvailabilityView()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}

extension AvailabilityFullView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let range = selectedTimes[indexPath.row], range.count == 4 {
            return 116
        } else {
            return 92
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Select day to set time range"
        
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.sizeToFit()
        
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AvailabilityCell
        cell.selectionStyle = .none
        
        if options.count > indexPath.row {
            cell.mainLabel.text = options[indexPath.row]
        }
        
        if let range = selectedTimes[indexPath.row] {
            cell.dates = range
        } else {
            cell.cellUnselected()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
