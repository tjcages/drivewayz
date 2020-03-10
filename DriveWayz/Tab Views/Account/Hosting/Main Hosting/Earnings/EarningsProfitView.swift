//
//  EarningsProfitView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EarningsProfitView: UIViewController {
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Today • "
        
        return label
    }()
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "Oct 2"
        
        return label
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        view.isPagingEnabled = true
        
        return view
    }()
    
    var firstContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.HOST_BLUE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var secondContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.HOST_BLUE
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var profitGraphic: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "profitGraphic")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var netProfitLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.text = "Net profit"
        
        return label
    }()
    
    var profitLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "$13.41"
        
        return label
    }()
    
    let paging = HorizontalPagingDisplay()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        setupViews()
        setupContainer()
    }
    
    func setupViews() {
        
        view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: phoneWidth * 2, height: 100)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(subLabel)
        view.addSubview(dayLabel)
        
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        dayLabel.topAnchor.constraint(equalTo: subLabel.topAnchor).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: subLabel.rightAnchor).isActive = true
        dayLabel.sizeToFit()
        
        scrollView.addSubview(firstContainer)
        firstContainer.anchor(top: subLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: phoneWidth - 32, height: 0)
        
        scrollView.addSubview(secondContainer)
        secondContainer.anchor(top: firstContainer.topAnchor, left: firstContainer.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: phoneWidth - 32, height: 0)
        
        view.addSubview(paging)
        paging.rightSelectionLine.isHidden = true
        paging.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        paging.bottomAnchor.constraint(equalTo: subLabel.bottomAnchor).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 36.5).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
    }

    func setupContainer() {
        
        firstContainer.addSubview(profitGraphic)
        profitGraphic.anchor(top: nil, left: nil, bottom: firstContainer.bottomAnchor, right: firstContainer.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -4, paddingRight: 8, width: 0, height: 0)
        profitGraphic.heightAnchor.constraint(equalTo: firstContainer.heightAnchor, constant: -20).isActive = true
        
        firstContainer.addSubview(netProfitLabel)
        firstContainer.addSubview(profitLabel)
        
        netProfitLabel.topAnchor.constraint(equalTo: firstContainer.topAnchor, constant: 16).isActive = true
        netProfitLabel.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: 20).isActive = true
        netProfitLabel.sizeToFit()
        
        profitLabel.topAnchor.constraint(equalTo: netProfitLabel.bottomAnchor).isActive = true
        profitLabel.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: 20).isActive = true
        profitLabel.sizeToFit()
        
    }
    
}

// Change the Paging control as user scrolls
extension EarningsProfitView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        let percentage = translation/phoneWidth
        paging.changeScroll(percentage: percentage)
        
        if percentage < 0 {
            firstContainer.alpha = 1
        } else if percentage >= 0 && percentage <= 1.0 {
            firstContainer.alpha = 1 - 1 * percentage
            secondContainer.alpha = 0 + 1 * percentage
        } else if percentage >= 1.0 {
            secondContainer.alpha = 1
        }
    }
}
