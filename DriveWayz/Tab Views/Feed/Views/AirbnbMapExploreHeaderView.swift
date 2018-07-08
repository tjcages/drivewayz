//
//  AirbnbMapExploreHeaderView.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/10/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import AirbnbDatePicker
//import AirbnbOccupantFilter

protocol AirbnbMapExploreHeaderViewDelegate {
    func didSelect(viewController: UIViewController, completion: (() -> Void)?)
    func didCollapseHeader(completion: (() -> Void)?)
    func didExpandHeader(completion: (() -> Void)?)
}

class AirbnbMapExploreHeaderView: UIView {
    
    override var bounds: CGRect {
        didSet {
            backgroundGradientLayer.frame = bounds
        }
    }
    
    var delegate: UIViewController? {
        didSet {
            //destinationFilter.delegate = delegate
            datePicker.delegate = delegate
            //            guestFilter.delegate = delegate
        }
    }
    
    lazy var backgroundGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = self.backgroundGradient
        return layer
    }()
    
    var whiteOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.alpha = 0
        return view
    }()
    
    var backgroundGradient: [CGColor] = [Theme.PRIMARY_COLOR.cgColor, Theme.PRIMARY_DARK_COLOR.cgColor]
    
    var pageTabDelegate: AirbnbExploreHeaderViewDelegate?
    var pageTabControllers = [UIViewController]() {
        didSet {
            setupPagers()
        }
    }
    let pageTabHeight: CGFloat = 50
    
    let headerInputHeight: CGFloat = 0
    
    var minHeaderHeight: CGFloat {
        return 20 // status bar
            + pageTabHeight
    }
    var midHeaderHeight: CGFloat {
        return 20 + 10 // status bar + spacing
            + headerInputHeight // input 1
            + pageTabHeight
    }
    var maxHeaderHeight: CGFloat {
        return 110
    }
    
    let collapseButtonHeight: CGFloat = 40
    let collapseButtonMaxTopSpacing: CGFloat = 20 + 10
    let collapseButtonMinTopSpacing: CGFloat = 0
    
    var collapseButtonTopConstraint: NSLayoutConstraint?
    
    lazy var collapseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Collapse"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(AirbnbExploreHeaderView.handleCollapse), for: .touchUpInside)
        return button
    }()
    
    lazy var driveWayz: UIImageView = {
        let image = UIImage(named: "DriveWayz")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var destinationFilterTopConstraint: NSLayoutConstraint?
    
    lazy var summaryFilter: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = Theme.PRIMARY_COLOR
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(AirbnbExploreHeaderView.handleExpand), for: .touchUpInside)
        
        let img = UIImage(named: "Search")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.setTitle("Anywhere • Anytime • 1 car", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        return btn
    }()
    
    lazy var destinationFilter: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = Theme.PRIMARY_COLOR
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        
        let img = UIImage(named: "Globe")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.setTitle("Anywhere", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        return btn
    }()
    
    lazy var datePicker: AirbnbDatePicker = {
        let input = AirbnbDatePicker()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.dateInputButton.backgroundColor = Theme.PRIMARY_COLOR
        input.delegate = self.delegate
        return input
    }()
    
    //    lazy var guestFilter: AirbnbOccupantFilter = {
    //        let input = AirbnbOccupantFilter()
    //        input.translatesAutoresizingMaskIntoConstraints = false
    //        input.occupantInputButton.backgroundColor = Theme.PRIMARY_COLOR
    //        input.delegate = self.delegate
    //        return input
    //    }()
    
    var pagerView: AirbnbPageTabNavigationView = {
        let view = AirbnbPageTabNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = Theme.PRIMARY_DARK_COLOR
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(collapseButton)
        
        collapseButton.heightAnchor.constraint(equalToConstant: collapseButtonHeight).isActive = true
        collapseButtonTopConstraint = collapseButton.topAnchor.constraint(equalTo: topAnchor, constant: collapseButtonMaxTopSpacing)
        collapseButtonTopConstraint?.isActive = true
        collapseButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        collapseButton.widthAnchor.constraint(equalToConstant: collapseButtonHeight).isActive = true
        
        addSubview(driveWayz)
        
        driveWayz.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        driveWayz.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        driveWayz.widthAnchor.constraint(equalToConstant: 200).isActive = true
        driveWayz.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
//        addSubview(destinationFilter)
//        
//        destinationFilter.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        destinationFilterTopConstraint = destinationFilter.topAnchor.constraint(equalTo: topAnchor, constant: collapseButtonHeight + collapseButtonMaxTopSpacing + 10)
//        destinationFilterTopConstraint?.isActive = true
//        destinationFilter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        destinationFilter.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
//        
//        addSubview(summaryFilter)
//        
//        summaryFilter.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        summaryFilter.topAnchor.constraint(equalTo: destinationFilter.topAnchor).isActive = true
//        summaryFilter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        summaryFilter.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
//        summaryFilter.alpha = 0
//        
//        addSubview(datePicker)
//        
//        datePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        datePicker.topAnchor.constraint(equalTo: destinationFilter.bottomAnchor, constant: 10).isActive = true
//        datePicker.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        datePicker.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        //        addSubview(guestFilter)
        //
        //        guestFilter.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //        guestFilter.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10).isActive = true
        //        guestFilter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //        guestFilter.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        addSubview(whiteOverlayView)
        
        whiteOverlayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        whiteOverlayView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whiteOverlayView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        whiteOverlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func setupPagers() {
        // TODO: remove all subviews
        
        addSubview(pagerView)
        
        pagerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pagerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pagerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        pagerView.heightAnchor.constraint(equalToConstant: pageTabHeight).isActive = true
        
        for vc in pageTabControllers {
            pagerView.appendPageTabItem(withTitle: vc.title ?? "")
            pagerView.navigationDelegate = self
        }
        
    }
    
    override func layoutSubviews() {
        //        if backgroundGradientLayer.superlayer == nil {
        //            layer.insertSublayer(backgroundGradientLayer, at: 0)
        //        }
    }
    
    public func updateHeader(newHeight: CGFloat, offset: CGFloat) {
        let headerBottom = newHeight - pageTabHeight
        
        let midMaxPercentage = (newHeight - midHeaderHeight) / (maxHeaderHeight - midHeaderHeight)
        datePicker.alpha = midMaxPercentage
        
        //        var datePickerPercentage3 = (headerBottom - guestFilter.frame.origin.y) / guestFilter.frame.height
        var datePickerPercentage3 = (headerBottom - 50) / 50
        datePickerPercentage3 = max(0, min(1, datePickerPercentage3)) // capped between 0 and 1
        //        guestFilter.alpha = datePickerPercentage3
        destinationFilter.alpha = datePickerPercentage3
        collapseButton.alpha = datePickerPercentage3
        
        //        var collapseButtonTopSpacingPercentage = (headerBottom - destinationFilter.frame.origin.y) / (guestFilter.frame.origin.y + guestFilter.frame.height - destinationFilter.frame.origin.y)
        var collapseButtonTopSpacingPercentage = (headerBottom - destinationFilter.frame.origin.y) / 50
        collapseButtonTopSpacingPercentage = max(0, min(1, collapseButtonTopSpacingPercentage))
        collapseButtonTopConstraint?.constant = collapseButtonTopSpacingPercentage * collapseButtonMaxTopSpacing
        
        //        summaryFilter.setTitle("\(destinationFilter.titleLabel!.text!) • \(datePicker.dateInputButton.titleLabel!.text!) • \(guestFilter.occupantInputButton.titleLabel!.text!)", for: .normal)
        summaryFilter.setTitle("\(destinationFilter.titleLabel!.text!) • \(datePicker.dateInputButton.titleLabel!.text!) • 1 car", for: .normal)
        if newHeight > midHeaderHeight + 10{
            destinationFilter.alpha = collapseButtonTopSpacingPercentage
            destinationFilterTopConstraint?.constant = max(UIApplication.shared.statusBarFrame.height + 10,collapseButtonTopSpacingPercentage * (collapseButtonHeight + collapseButtonMaxTopSpacing + 10))
            summaryFilter.alpha = 1 - collapseButtonTopSpacingPercentage
            whiteOverlayView.alpha = 0
            
            pagerView.backgroundColor = Theme.PRIMARY_DARK_COLOR
            pagerView.titleColor = UIColor.white
            pagerView.selectedTitleColor = UIColor.white
            
            //        } else if newHeight == midHeaderHeight {
            //            destinationFilterTopConstraint?.constant = UIApplication.shared.statusBarFrame.height + 10
            //            destinationFilter.alpha = 0
            //            summaryFilter.alpha = 1
            //            whiteOverlayView.alpha = 0
            //
            //            pagerView.backgroundColor = Theme.PRIMARY_DARK_COLOR
            //            pagerView.titleColor = UIColor.white
            //            pagerView.selectedTitleColor = UIColor.white
            //
        } else {
            destinationFilterTopConstraint?.constant = destinationFilterTopConstraint!.constant - offset
            let minMidPercentage = (newHeight - minHeaderHeight) / (midHeaderHeight - minHeaderHeight)
            destinationFilter.alpha = 0
            summaryFilter.alpha = minMidPercentage
            
            whiteOverlayView.alpha = 1 - minMidPercentage
            pagerView.backgroundColor = UIColor.fade(fromColor: Theme.PRIMARY_DARK_COLOR, toColor: UIColor.white, withPercentage: 1 - minMidPercentage)
            pagerView.titleColor = UIColor.fade(fromColor: UIColor.white, toColor: UIColor.darkGray, withPercentage: 1 - minMidPercentage)
            pagerView.selectedTitleColor = UIColor.fade(fromColor: UIColor.white, toColor: Theme.PRIMARY_COLOR, withPercentage: 1 - minMidPercentage)
        }
    }
    
    @objc func handleCollapse() {
        pageTabDelegate?.didCollapseHeader(completion: nil)
    }
    
    @objc func handleExpand() {
        pageTabDelegate?.didExpandHeader(completion: nil)
    }
}

extension AirbnbMapExploreHeaderView: AirbnbPageTabNavigationViewDelegate {
    func didSelect(tabItem: AirbnbPageTabItem, atIndex index: Int, completion: (() -> Void)?) {
        if index >= 0, index < pageTabControllers.count {
            pageTabDelegate?.didSelect(viewController: pageTabControllers[index]) {
                if let handler = completion {
                    handler()
                }
            }
        }
    }
    
    func animatePageTabSelection(toIndex index: Int) {
        pagerView.animatePageTabSelection(toIndex: index)
    }
}
