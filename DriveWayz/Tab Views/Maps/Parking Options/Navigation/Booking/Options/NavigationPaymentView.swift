//
//  NavigationPaymentView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class NavigationPaymentView: UIViewController {
    
    var currentBooking: Bookings? {
        didSet {
            if let booking = self.currentBooking, let toTime = booking.toDate, let fromTime = booking.fromDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                dateFormatter.amSymbol = "am"
                dateFormatter.pmSymbol = "pm"
                let date = Date(timeIntervalSince1970: toTime)
                let fromDate = Date(timeIntervalSince1970: fromTime)
                let dateString = dateFormatter.string(from: date)
                let fromString = dateFormatter.string(from: fromDate)
                self.toTimeLabel.text = dateString
                self.fromTimeLabel.text = fromString
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "E, d MMM yyyy"
                let fromDayString = dateFormatter2.string(from: fromDate)
                self.dateLabel.text = fromDayString
                
                if let parkingPrice = booking.price, let parkingHours = booking.hours, let totalPayment = booking.totalCost {
                    self.totalHoursFee.text = "\(parkingHours) hours"
                    self.hourlyPriceFee.text = String(format:"$%.2f/hour", parkingPrice)
                    self.userProfit.text = String(format:"$%.2f", totalPayment)
                    
                    let bookingFee = 0.30
                    let processingFee = 0.029 * totalPayment
                    self.userBookingFee.text = String(format:"$%.02f", bookingFee)
                    self.userProcessingFee.text = String(format:"$%.02f", processingFee)
                }
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sat Jan 12, 2019"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var fromTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2:15pm"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH00
        
        return label
    }()
    
    var toTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4:30pm"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH00
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
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    var totalHoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Parking duration"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var totalHoursFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var hourlyPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hourly cost"
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH5
        
        return label
    }()
    
    var hourlyPriceFee: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
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
        label.text = ""
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
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
        label.text = ""
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var lineView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.PRUSSIAN_BLUE.withAlphaComponent(0.2)
        
        return view
    }()
    
    
    var profitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking total"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var userProfit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH3
        label.textAlignment = .right
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupPayments()
    }
    
    func setupViews() {
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        container.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        dateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        container.addSubview(fromTimeLabel)
        fromTimeLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        fromTimeLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        fromTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        fromTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(toTimeLabel)
        toTimeLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        toTimeLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        toTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        toTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(toLabel)
        toLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        toLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        toLabel.bottomAnchor.constraint(equalTo: fromTimeLabel.bottomAnchor).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupPayments() {
        
        container.addSubview(lineView3)
        lineView3.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        lineView3.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        lineView3.topAnchor.constraint(equalTo: toTimeLabel.bottomAnchor, constant: 24).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        container.addSubview(totalHoursLabel)
        totalHoursLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        totalHoursLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        totalHoursLabel.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 16).isActive = true
        totalHoursLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(totalHoursFee)
        totalHoursFee.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        totalHoursFee.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        totalHoursFee.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 12).isActive = true
        totalHoursFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(hourlyPriceLabel)
        hourlyPriceLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        hourlyPriceLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        hourlyPriceLabel.topAnchor.constraint(equalTo: totalHoursLabel.bottomAnchor, constant: 12).isActive = true
        hourlyPriceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(hourlyPriceFee)
        hourlyPriceFee.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        hourlyPriceFee.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        hourlyPriceFee.topAnchor.constraint(equalTo: totalHoursLabel.bottomAnchor, constant: 12).isActive = true
        hourlyPriceFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(bookingFeeLabel)
        bookingFeeLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        bookingFeeLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        bookingFeeLabel.topAnchor.constraint(equalTo: hourlyPriceLabel.bottomAnchor, constant: 12).isActive = true
        bookingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(userBookingFee)
        userBookingFee.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        userBookingFee.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        userBookingFee.topAnchor.constraint(equalTo: hourlyPriceLabel.bottomAnchor, constant: 12).isActive = true
        userBookingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(processingFeeLabel)
        processingFeeLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        processingFeeLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        processingFeeLabel.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        processingFeeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(userProcessingFee)
        userProcessingFee.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        userProcessingFee.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        userProcessingFee.topAnchor.constraint(equalTo: bookingFeeLabel.bottomAnchor, constant: 12).isActive = true
        userProcessingFee.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addSubview(lineView4)
        lineView4.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        lineView4.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        lineView4.topAnchor.constraint(equalTo: processingFeeLabel.bottomAnchor, constant: 16).isActive = true
        lineView4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        container.addSubview(profitLabel)
        profitLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        profitLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        profitLabel.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 8).isActive = true
        profitLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(userProfit)
        userProfit.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        userProfit.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        userProfit.topAnchor.constraint(equalTo: lineView4.bottomAnchor, constant: 8).isActive = true
        userProfit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}
