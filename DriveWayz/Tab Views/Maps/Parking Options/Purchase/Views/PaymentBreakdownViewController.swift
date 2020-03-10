//
//  PaymentBreakdownViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/6/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

struct Fees {
    var description: String
    var amount: String
}

class PaymentBreakdownViewController: UIViewController {
    
    var delegate: handleExtendPaymentMethod?
    var bottomAnchor: CGFloat = 0.0
    var shouldDismiss: Bool = true
    
    var fees: [Fees] = [] {
        didSet {
            feesTableView.reloadData()
        }
    }
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var feesTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(FeesCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.separatorStyle = .none
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price breakdown"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You agree to pay the upfront price and applicable overstay fees. The final charge will reflect the amount presented and the total duration of stay."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 10
        
        return label
    }()
    
    var disclaimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Overstay charges may apply to the booking if you are parked longer than the duration specified."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 5
        
        return label
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feesTableView.delegate = self
        feesTableView.dataSource = self
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    var feeTableHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        container.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -32
        case .iphoneX:
            profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -52)
                profitsBottomAnchor.isActive = true
            self.bottomAnchor = -52
        }
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(disclaimerLabel)
        disclaimerLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -32).isActive = true
        disclaimerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        disclaimerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        disclaimerLabel.sizeToFit()
        
        view.addSubview(feesTableView)
        feesTableView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor, constant: -32).isActive = true
        feesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        feesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        feeTableHeightAnchor = feesTableView.heightAnchor.constraint(equalToConstant: 140)
            feeTableHeightAnchor.isActive = true
        
        view.addSubview(informationLabel)
        view.addSubview(mainLabel)
        
        informationLabel.bottomAnchor.constraint(equalTo: feesTableView.topAnchor, constant: -32).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        informationLabel.sizeToFit()
        
        mainLabel.bottomAnchor.constraint(equalTo: informationLabel.topAnchor, constant: -16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -32).isActive = true
        
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.profitsBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        UIView.animate(withDuration: animationOut) {
            tabDimmingView.alpha = 0
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension PaymentBreakdownViewController: UITableViewDelegate, UITableViewDataSource {
    
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

class FeesCell: UITableViewCell {
    
    var fee: Fees? {
        didSet {
            if let fee = self.fee {
                mainLabel.text = fee.description
                feeLabel.text = fee.amount
                if fee.description.contains("%") {
                    feeLabel.textColor = Theme.GREEN
                } else {
                    feeLabel.textColor = Theme.BLACK
                }
            }
        }
    }
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var feeLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainLabel)
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        addSubview(feeLabel)
        feeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        feeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        feeLabel.sizeToFit()
        
        addSubview(line)
        line.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        line.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func total() {
//        mainLabel.font = Fonts.SSPRegularH3
//        feeLabel.font = Fonts.SSPRegularH3
        line.alpha = 1
    }
    
    func notTotal() {
//        mainLabel.font = Fonts.SSPRegularH4
//        feeLabel.font = Fonts.SSPRegularH4
        line.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


