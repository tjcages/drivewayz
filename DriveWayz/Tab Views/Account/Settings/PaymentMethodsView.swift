//
//  PaymentMethodsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe

protocol updatePaymentMethod {
    func loadPayments()
}

class PaymentMethodsView: UIViewController, updatePaymentMethod {
    
    var delegate: changeSettingsHandler?
    var paymentMethods: [PaymentMethod] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PaymentMethodsCell.self, forCellReuseIdentifier: "cellId")
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
    
    func loadPayments() {
//        loadingLine.alpha = 1
//        loadingLine.startAnimating()
    }
    
}

extension PaymentMethodsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let height = CGFloat(60 * (paymentMethods.count + 1)) + 47
        delegate?.changePaymentHeight(amount: height)
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
        return paymentMethods.count + 1
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
        label.text = "Payment Methods"
        
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.sizeToFit()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PaymentMethodsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if indexPath.row < paymentMethods.count {
            cell.paymentMethod = paymentMethods[indexPath.row]
        }
        
        if indexPath.row == paymentMethods.count {
            cell.newCard()
        } else {
            cell.oldCard()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == paymentMethods.count {
            let controller = NewCardView()
            controller.delegate = self
            controller.paymentMethods = paymentMethods
            self.navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row < paymentMethods.count {
            let method = paymentMethods[indexPath.row]
            let controller = CurrentCardView()
            controller.delegate = self
            controller.paymentMethods = paymentMethods
            controller.observePayments(payment: method)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
