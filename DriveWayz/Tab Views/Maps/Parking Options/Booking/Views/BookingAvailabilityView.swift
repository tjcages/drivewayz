//
//  BookingAvailabilityView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/5/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class BookingAvailabilityView: UIView {
    
    var business: [Business] = [.almost_half, .mostly_empty, .almost_full] {
        didSet {
            setData()
        }
    }
    
    let height: CGFloat = 10
    let base: CGFloat = 4
    
    var firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WARM_2_MED
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WARM_2_MED
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var thirdView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WARM_2_MED
        view.layer.cornerRadius = 2
        
        return view
    }()
    
//    var fourthView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = Theme.WARM_2_MED
//        view.layer.cornerRadius = 2
//
//        return view
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
        
        setupViews()
        setData()
    }
    
    func setData() {
        let first = business[0].rawValue
        firstView.alpha = first
        firstHeightAnchor.constant = height * first + base
        
        let second = business[1].rawValue
        secondView.alpha = second
        secondHeightAnchor.constant = height * second + base
        
        let third = business[2].rawValue
        thirdView.alpha = third
        thirdHeightAnchor.constant = height * third + base
        
//        let fourth = business[3].rawValue
//        fourthView.alpha = fourth
//        fourthHeightAnchor.constant = height * fourth + base
    }
    
    var firstHeightAnchor: NSLayoutConstraint!
    var secondHeightAnchor: NSLayoutConstraint!
    var thirdHeightAnchor: NSLayoutConstraint!
//    var fourthHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(firstView)
        addSubview(secondView)
        addSubview(thirdView)
//        addSubview(fourthView)
        
//        fourthView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 10, height: 0)
//        fourthHeightAnchor = fourthView.heightAnchor.constraint(equalToConstant: height + base)
//            fourthHeightAnchor.isActive = true
        
        thirdView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 10, height: 0)
        thirdHeightAnchor = thirdView.heightAnchor.constraint(equalToConstant: height + base)
            thirdHeightAnchor.isActive = true
        
        secondView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: thirdView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 10, height: 0)
        secondHeightAnchor = secondView.heightAnchor.constraint(equalToConstant: height + base)
            secondHeightAnchor.isActive = true
        
        firstView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: secondView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 10, height: 0)
        firstHeightAnchor = firstView.heightAnchor.constraint(equalToConstant: height + base)
            firstHeightAnchor.isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
