//
//  CurrentPaymentView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 12/16/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentPaymentView: UIView {
    
    var delegate: CurrentViewDelegate?
    var expanded: Bool = true
    
    var fees: [Fees] = [] {
        didSet {
            feesTableView.reloadData()
        }
    }
    
    var paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Payment"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPSemiBoldH5
        
        return label
    }()
    
    var reservationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 45/2
        button.clipsToBounds = true
        button.tintColor = Theme.BLACK
        let image = UIImage(named: "hostEarningsIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$8.80"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mastercard 4321"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var switchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Switch", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = Theme.LINE_GRAY
        view.addSubview(line)
        
        return view
    }()
    
    var feesTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(FeesCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.separatorStyle = .none
        
        return view
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Expand")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(arrowPressed), for: .touchUpInside)
        
        return button
    }()
    
    var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    func setData(totalCost: String, hourlyCost: String, discount: Int) {
        var totalCost = totalCost
        totalCost = totalCost.replacingOccurrences(of: "$", with: "")
        guard let cost = Double(totalCost), let totalHours = currentTotalTime else { return }
        
        let totalHoursFee = Fees(description: "Total hours", amount: totalHours)
        let hourlyFee = Fees(description: "Hourly price", amount: "\(hourlyCost)/hour")
        let bookingFee = Fees(description: "Booking fee", amount: "$0.30")
        
        let rounded = (0.029 * cost).rounded(toPlaces: 2)
        let processing = String(format: "$%.2f", rounded)
        let processingFee = Fees(description: "Processing fee", amount: processing)
        let finalCost = Fees(description: "Total cost", amount: "$\(totalCost)")
        
        if discount != 0 {
            let discountAmount = String(format: "-$%.2f", (Double(discount)/100.0 * cost))
            let discountFee = Fees(description: "\(discount)% discount", amount: discountAmount)
            fees = [totalHoursFee, hourlyFee, bookingFee, processingFee, discountFee, finalCost]
        } else {
            fees = [totalHoursFee, hourlyFee, bookingFee, processingFee, finalCost]
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        clipsToBounds = true
        
        feesTableView.delegate = self
        feesTableView.dataSource = self
        
        setupViews()
        setupBreakdown()
        
        arrowPressed()
        
        // TESTING
        currentTotalTime = "2.25 hours"
        setData(totalCost: "$8.73", hourlyCost: "$4.06", discount: 0)
    }
    
    func setupViews() {
        
        addSubview(paymentLabel)
        paymentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        paymentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        paymentLabel.sizeToFit()
        
        addSubview(reservationIcon)
        addSubview(titleLabel)
        addSubview(subLabel)
        
        reservationIcon.anchor(top: paymentLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        
        titleLabel.topAnchor.constraint(equalTo: reservationIcon.topAnchor, constant: -2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        titleLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: reservationIcon.rightAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()

        addSubview(switchButton)
        switchButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 120, height: 30)
        switchButton.centerYAnchor.constraint(equalTo: reservationIcon.centerYAnchor).isActive = true
        
    }
    
    var feeTableHeightAnchor: NSLayoutConstraint!
    
    func setupBreakdown() {
        
        addSubview(container)
        container.anchor(top: reservationIcon.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(feesTableView)
        feesTableView.anchor(top: container.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        feeTableHeightAnchor = feesTableView.heightAnchor.constraint(equalToConstant: 0)
            feeTableHeightAnchor.isActive = true
        
        addSubview(arrowButton)
        arrowButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: paymentLabel.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(spacer)
         spacer.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 4)
        
    }
    
    @objc func arrowPressed() {
        UIView.animate(withDuration: animationIn) {
            if self.expanded {
                self.delegate?.minimizePayment()
                self.expanded = false
                self.container.alpha = 0
                self.arrowButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } else {
                self.delegate?.expandPayment()
                self.expanded = true
                self.container.alpha = 1
                self.arrowButton.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CurrentPaymentView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feeTableHeightAnchor.constant = 30.0 * CGFloat(fees.count - 1) + 50.0
        return fees.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != (fees.count - 1) {
            return 30
        } else {
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feesTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! FeesCell
        cell.selectionStyle = .none
        cell.backgroundColor = Theme.WHITE
        
        if fees.count > indexPath.row {
            cell.fee = fees[indexPath.row]
        }
        if indexPath.row != (fees.count - 1) {
            cell.notTotal()
        } else {
            cell.total()
        }

        return cell
    }
    
}
