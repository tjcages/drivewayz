//
//  VehicleMethodsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe

protocol updateVehicleMethod {
    func loadVehicles()
}

class VehicleMethodsView: UIViewController, updateVehicleMethod {
    
    var delegate: changeSettingsHandler?
    var vehicleMethods: [Vehicles] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(VehicleMethodsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.clipsToBounds = true
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(optionsTableView)
        optionsTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func loadVehicles() {
        //        loadingLine.alpha = 1
        //        loadingLine.startAnimating()
    }
    
}

extension VehicleMethodsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let height = CGFloat(60 * (vehicleMethods.count + 1)) + 47
        delegate?.changeVehicleHeight(amount: height)
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
        
        return vehicleMethods.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Vehicles"
        
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.sizeToFit()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! VehicleMethodsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if indexPath.row < vehicleMethods.count {
            cell.vehicleMethod = vehicleMethods[indexPath.row]
        }
        
        if indexPath.row == vehicleMethods.count {
            cell.newVehicle()
        } else {
            cell.oldVehicle()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == vehicleMethods.count {
            let controller = NewVehicleView()
            controller.delegate = self
            controller.vehicleMethods = vehicleMethods
            self.navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row < vehicleMethods.count {
            let method = vehicleMethods[indexPath.row]
            let controller = CurrentVehicleView()
            controller.delegate = self
            controller.vehicleMethods = vehicleMethods
            controller.observeVehicles(vehicle: method)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
