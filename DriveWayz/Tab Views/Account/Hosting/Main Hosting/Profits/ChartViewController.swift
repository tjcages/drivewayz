//
//  ChartViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    var delegate: handleHostScrolling?

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var profitsCharts: ProfitsChartsViewController = {
        let controller = ProfitsChartsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var profitsPayments: ProfitsPaymentsViewController = {
        let controller = ProfitsPaymentsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var noBookingsController: NoBookingsViewController = {
        let controller = NoBookingsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.noMessagesLabel.text = "No previous transactions"
        controller.container.alpha = 0
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setupViews()
    }
    
    var paymentsHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight * 2)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(profitsCharts.view)
        profitsCharts.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
        profitsCharts.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profitsCharts.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        profitsCharts.view.heightAnchor.constraint(equalToConstant: phoneWidth * 0.82).isActive = true
        
        scrollView.addSubview(noBookingsController.view)
        noBookingsController.view.topAnchor.constraint(equalTo: profitsCharts.view.bottomAnchor, constant: 16).isActive = true
        noBookingsController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noBookingsController.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        noBookingsController.view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        scrollView.addSubview(profitsPayments.view)
        profitsPayments.view.topAnchor.constraint(equalTo: profitsCharts.view.bottomAnchor, constant: 16).isActive = true
        profitsPayments.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsPayments.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        paymentsHeight = profitsPayments.view.heightAnchor.constraint(equalToConstant: 0)
            paymentsHeight.isActive = true
        
    }
}


extension ChartViewController: handleHostTransfers {
    
    func changePaymentAmount(total: Double, transit: Double) {
        
    }
    
    func expandTransferHeight(height: CGFloat) {
        self.paymentsHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    func closeBackground() {
        self.delegate?.closeBackground()
    }
    
}


extension ChartViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.makeScrollViewScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.makeScrollViewEnd(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.makeScrollViewEnd(scrollView)
    }
    
}
