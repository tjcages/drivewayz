//
//  BookingPaymentViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class BookingPaymentViewController: UIViewController {
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sat Jan 12, 2019"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2:15 PM"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH1
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:30 PM"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPRegularH1
        label.textAlignment = .right
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "to"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        
        return label
    }()
    
    var lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    var bookingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userBookingFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$0.32"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var processingFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Processing fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userProcessingFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$1.23"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var drivewayzFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Drivewayz fee"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var userDrivewayzFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-$2.80"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    
    var profitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your profit"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userProfit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$12.38"
        label.textColor = Theme.GREEN_PIGMENT
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true

        setupTimes()
        setupViews()
        setupButtons()
    }
    
    func setupTimes() {
        
        self.view.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(fromTimeLabel)
        fromTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        fromTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(toTimeLabel)
        toTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(toLabel)
        toLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        toLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupViews() {
        
        self.view.addSubview(lineView3)
        lineView3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lineView3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        lineView3.topAnchor.constraint(equalTo: toTimeLabel.bottomAnchor, constant: 16).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(bookingFeeLabel)
        bookingFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        bookingFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        bookingFeeLabel.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 12).isActive = true
        bookingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(userBookingFee)
        userBookingFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userBookingFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userBookingFee.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 12).isActive = true
        userBookingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(processingFeeLabel)
        processingFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        processingFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        processingFeeLabel.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        processingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(userProcessingFee)
        userProcessingFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userProcessingFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userProcessingFee.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        userProcessingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(drivewayzFeeLabel)
        drivewayzFeeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        drivewayzFeeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        drivewayzFeeLabel.topAnchor.constraint(equalTo: processingFeeLabel.bottomAnchor, constant: 12).isActive = true
        drivewayzFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(userDrivewayzFee)
        userDrivewayzFee.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userDrivewayzFee.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userDrivewayzFee.topAnchor.constraint(equalTo: processingFeeLabel.bottomAnchor, constant: 12).isActive = true
        userDrivewayzFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(lineView4)
        lineView4.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        lineView4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        lineView4.topAnchor.constraint(equalTo: drivewayzFeeLabel.bottomAnchor, constant: 12).isActive = true
        lineView4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(profitLabel)
        profitLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        profitLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        profitLabel.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 12).isActive = true
        profitLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(userProfit)
        userProfit.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        userProfit.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        userProfit.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 12).isActive = true
        userProfit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setupButtons() {
        
        
        
    }
    
}
