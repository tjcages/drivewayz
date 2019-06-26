//
//  HostProfitsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol handleBankTransfers {
    func bringTransferCountroller(accountID: String, userFunds: Double)
    func dismissTransferController()
}

class HostProfitsViewController: UIViewController {
    
    var delegate: handleHostingControllers?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var profitsContainer: MyProfitsViewController = {
        let controller = MyProfitsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var profitsDateContainer: ProfitsDateViewController = {
        let controller = ProfitsDateViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    var profitsEarningsContainer: ProfitsEarningsViewController = {
        let controller = ProfitsEarningsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: 842)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(profitsContainer.view)
        profitsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsContainer.view.heightAnchor.constraint(equalToConstant: 96).isActive = true
        profitsContainer.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        scrollView.addSubview(profitsDateContainer.view)
        profitsDateContainer.view.topAnchor.constraint(equalTo: profitsContainer.view.bottomAnchor, constant: 12).isActive = true
        profitsDateContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsDateContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsDateContainer.view.heightAnchor.constraint(equalToConstant: 460).isActive = true
        
        scrollView.addSubview(profitsEarningsContainer.view)
        profitsEarningsContainer.view.topAnchor.constraint(equalTo: profitsDateContainer.view.bottomAnchor, constant: 12).isActive = true
        profitsEarningsContainer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        profitsEarningsContainer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        profitsEarningsContainer.view.heightAnchor.constraint(equalToConstant: 142).isActive = true
        
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}


extension HostProfitsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        self.delegate?.handleScrollView(translation: translation)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        self.delegate?.handleEndDragging(translation: translation)
    }
    
}
