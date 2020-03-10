//
//  TestMainBar.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/8/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol handleInviteControllers {
    func changeRecentsHeight(number: Int)
}

class TestMainBar: UIViewController {
    
//    var delegate: mainBarSearchDelegate?
    var mainBarRecents: MainBarRecents = .noRecents {
        didSet {
            mainBarNormalHeight = self.mainBarRecents.rawValue
            if self.mainBarBanner {
                mainBarNormalHeight += bannerHeight
            }
//            mainBarHighestHeight = mainBarNormalHeight + mainBarDifference
        }
    }
    
    var bannerHeight: CGFloat = 75
    var mainBarBanner: Bool = false {
        didSet {
            if self.mainBarBanner {
                mainBarNormalHeight += bannerHeight
//                mainBarLowestHeight += bannerHeight
            } else {
                mainBarNormalHeight -= bannerHeight
//                mainBarLowestHeight -= bannerHeight
            }
        }
    }
    
    var reservationsOpen: Bool = false
    var couponsOpen: Bool = false
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.isScrollEnabled = false
        view.clipsToBounds = true
        view.backgroundColor = Theme.BLACK.withAlphaComponent(0.9)
        
        return view
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = -1
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    lazy var bannerController: MainBannerView = {
        let controller = MainBannerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var searchController: MainSearchView = {
        let controller = MainSearchView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.delegate = self
        
        return controller
    }()
    
    lazy var optionsController: MainOptionsView = {
        let controller = MainOptionsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var quickController: MainQuickView = {
        let controller = MainQuickView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.DarkRed
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        scrollView.delegate = self
        
//        setupStack()
//        setupViews()
    }
    
    func setupViews() {
        setupBanner(0, last: false)
        setupSearch(0, last: true)
        setupOptions(0, last: true)
        setupQuick(0, last: true)
    }
    
    var scrollViewTopAnchor: NSLayoutConstraint!
    
    func setupStack() {
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight * 5/4)
        scrollViewTopAnchor = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
            scrollViewTopAnchor.isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    }
    
    var bannerHeightAnchor: NSLayoutConstraint!
    
    func setupBanner(_ index: Int, last: Bool) {
        bannerController.view.alpha = 1
        if last {
            stackView.addArrangedSubview(bannerController.view)
        } else {
            stackView.insertArrangedSubview(bannerController.view, at: index)
        }
        bannerHeightAnchor = bannerController.view.heightAnchor.constraint(equalToConstant: bannerHeight)
            bannerHeightAnchor.isActive = true
        
        mainBarBanner = true
    }
    
    var searchHeightAnchor: NSLayoutConstraint!
    
    func setupSearch(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(searchController.view)
        } else {
            stackView.insertArrangedSubview(searchController.view, at: index)
        }
        searchHeightAnchor = searchController.view.heightAnchor.constraint(equalToConstant: 232)
            searchHeightAnchor.isActive = true
        
        searchController.durationBottomController.parkNowButton.addTarget(self, action: #selector(reserveSpotPressed(sender:)), for: .touchUpInside)
        searchController.durationBottomController.reserveSpotButton.addTarget(self, action: #selector(reserveSpotPressed(sender:)), for: .touchUpInside)
    }
    
    func setupOptions(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(optionsController.view)
        } else {
            stackView.insertArrangedSubview(optionsController.view, at: index)
        }
        optionsController.view.heightAnchor.constraint(equalToConstant: optionsController.cellHeight + 124).isActive = true
    }
    
    func setupQuick(_ index: Int, last: Bool) {
        if last {
            stackView.addArrangedSubview(quickController.view)
        } else {
            stackView.insertArrangedSubview(quickController.view, at: index)
        }
        quickController.view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        quickController.firstButton.addTarget(self, action: #selector(firstQuickOptionPressed), for: .touchUpInside)
        quickController.firstLabel.addTarget(self, action: #selector(firstQuickOptionPressed), for: .touchUpInside)
        quickController.secondButton.addTarget(self, action: #selector(secondQuickOptionPressed), for: .touchUpInside)
        quickController.secondLabel.addTarget(self, action: #selector(secondQuickOptionPressed), for: .touchUpInside)
        quickController.thirdButton.addTarget(self, action: #selector(thirdQuickOptionPressed), for: .touchUpInside)
        quickController.thirdLabel.addTarget(self, action: #selector(thirdQuickOptionPressed), for: .touchUpInside)
    }
    
    func showQuickOptions() {
        bannerHeightAnchor.constant = 0
        scrollViewTopAnchor.constant = 120
        UIView.animate(withDuration: animationOut, animations: {
            self.bannerController.view.alpha = 0
            self.searchController.durationBottomController.view.alpha = 0
            self.scrollView.layer.cornerRadius = 24
            self.searchController.view.layer.cornerRadius = 24
            self.optionsController.view.layer.cornerRadius = 24
            self.view.layoutIfNeeded()
        }) { (success) in
            self.scrollViewTopAnchor.constant = 0
            self.quickController.animateQuickViews()
            UIView.animate(withDuration: animationOut * 2, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func hideQuickOptions() {
        bannerHeightAnchor.constant = 72
        scrollViewTopAnchor.constant = 0
        quickController.dismissQuickViews()
        UIView.animate(withDuration: animationOut) {
            self.bannerController.view.alpha = 1
            self.searchController.durationBottomController.view.alpha = 1
            self.scrollView.layer.cornerRadius = 0
            self.searchController.view.layer.cornerRadius = 0
            self.optionsController.view.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func firstQuickOptionPressed() {
//        delegate?.quickHelp()
    }
    
    @objc func secondQuickOptionPressed() {
//        delegate?.quickNewHost()
    }
    
    @objc func thirdQuickOptionPressed() {
//        delegate?.quickAccount()
    }
    
}

extension TestMainBar {
    
    @objc func reserveSpotPressed(sender: UIButton) {
        if sender == searchController.durationBottomController.parkNowButton {
//            delegate?.showDuration(parkNow: true)
        } else {
//            delegate?.showDuration(parkNow: false)
        }
    }
    
    func expandReservations() {
        reservationsOpen = true
        bannerHeightAnchor.constant += 100
        bannerController.expandBanner()
    }
    
    func closeReservations() {
        reservationsOpen = false
        bannerHeightAnchor.constant -= 100
        bannerController.closeBanner()
    }
    
}

extension TestMainBar: handleInviteControllers {
    
    @objc func newHostControllerPressed() {
//        self.scrollView.setContentOffset(.zero, animated: true)
//        self.delegate?.becomeANewHost()
//        delayWithSeconds(2) {
//            self.scrollView.isScrollEnabled = false
//        }
    }

    func changeRecentsHeight(number: Int) {
//        if number == 1 {
//            mainBarRecents = .oneRecents
//        } else if number == 2 {
//            mainBarRecents = .twoRecents
//        }
//        let height = searchController.cellHeight * CGFloat(number)
//        searchHeightAnchor.constant = 224 + height
//        UIView.animate(withDuration: animationIn) {
//            self.searchController.recentsTableView.alpha = 1
//            self.view.layoutIfNeeded()
//        }
    }
    
}

extension TestMainBar: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
//        shouldDragMainBar = true
        let translation = scrollView.contentOffset.y
        
        if translation < 0 {
            scrollView.contentOffset.y = 0.0
            scrollView.isScrollEnabled = false
//            self.delegate?.closeMainBar()
        }
    }
    
}
