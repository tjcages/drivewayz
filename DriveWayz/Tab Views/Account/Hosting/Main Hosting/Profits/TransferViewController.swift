//
//  RefundViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleHostTransfers {
    func expandTransferHeight(height: CGFloat)
    func changePaymentAmount(total: Double, transit: Double)
    func closeBackground()
}

class TransferViewController: UIViewController, handleHostTransfers {

    var delegate: handleHostScrolling?
    var transferDelegate: handlePaymentTransfers?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    lazy var profitsRefund: ProfitsTransfersViewController = {
        let controller = ProfitsTransfersViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var profitsPayments: TransferAllViewController = {
        let controller = TransferAllViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
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
        
        scrollView.addSubview(profitsRefund.view)
        profitsRefund.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
        profitsRefund.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profitsRefund.view.widthAnchor.constraint(equalToConstant: phoneWidth - 24).isActive = true
        profitsRefund.view.heightAnchor.constraint(equalToConstant: phoneWidth * 0.42).isActive = true
        
        scrollView.addSubview(profitsPayments.view)
        profitsPayments.view.topAnchor.constraint(equalTo: profitsRefund.view.bottomAnchor, constant: 16).isActive = true
        profitsPayments.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsPayments.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        paymentsHeight = profitsPayments.view.heightAnchor.constraint(equalToConstant: 0)
            paymentsHeight.isActive = true
        
    }
    
    func transferInformation(payout: Payouts) {
        self.transferDelegate?.transferInformation(payout: payout)
    }
    
    func changePaymentAmount(total: Double, transit: Double) {
        self.profitsRefund.totalEarnings.text = String(format: "$%.2f", total)
        self.profitsRefund.futureLabel.text = String(format: "$%.2f in transit to bank", transit)
    }
    
    func expandTransferHeight(height: CGFloat) {
        self.paymentsHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    func closeBackground() {
        self.delegate?.closeBackground()
    }
    
}


extension TransferViewController: UIScrollViewDelegate {
    
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
