//
//  MainOptionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/7/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CHIPageControl

class MainOptionsView: UIViewController {
    
    let cellWidth: CGFloat = 272
    let cellHeight: CGFloat = 160
    private var indexOfCellBeforeDragging = 0
    
    var mainOptions: [MainOption] = [MainOption(mainText: "Share and save", subText: "Invite a friend and earn 25% off your next park!", graphic: UIImage(named: "trophyGraphic"), option: .share), MainOption(mainText: "Have a coupon code?", subText: "Save money on everyday parking.", graphic: UIImage(named: "discountGraphic"), option: .code)
//                                     MainOption(mainText: "Start hosting, get $5", subText: "Earn easy money listing your parking spot today.", graphic: UIImage(named: "houseGraphic"))
    ]
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Earn rewards and discounts"
        
        return label
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        return layout
    }()
    
    lazy var collectionPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = .clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(MainOptionsCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 16, right: 24)
        
        return picker
    }()
    
    var pageControl: CHIPageControlPuya = {
        let pageControl = CHIPageControlPuya(frame: CGRect(x: 0, y:0, width: 100, height: 20))
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.tintColor = Theme.GRAY_WHITE_4
        pageControl.currentPageTintColor = Theme.GRAY_WHITE
        pageControl.padding = 6
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        collectionPicker.delegate = self
        collectionPicker.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(collectionPicker)
        view.addSubview(pageControl)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: collectionPicker.topAnchor).isActive = true
        mainLabel.sizeToFit()
        
        collectionPicker.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 48, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: cellHeight + 56)
        
        pageControl.bottomAnchor.constraint(equalTo: collectionPicker.bottomAnchor, constant: -12).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.sizeToFit()
        
    }
    
    func openRewardsView(image: UIImage?, option: DiscountOptions) {
        UIView.animate(withDuration: animationIn, animations: {
            tabDimmingView.alpha = 1
        }) { (success) in
            let controller = DiscountsViewController()
            controller.discountOption = option
            controller.graphicImage = image
            let navigation = UINavigationController(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
}

extension MainOptionsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = mainOptions.count
        pageControl.numberOfPages = number
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! MainOptionsCell
        
        if mainOptions.count > indexPath.row {
            let option = mainOptions[indexPath.row]
            cell.mainOption = option
            cell.discountOption = option.option
        }
        
        // Set a "Callback Closure" in the cell
        cell.moreTapAction = {
            () in
            self.openRewardsView(image: cell.mainGraphic.image, option: cell.discountOption)
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < mainOptions.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = self.cellWidth * CGFloat(snapToIndex)
            
            self.pageControl.set(progress: snapToIndex, animated: true)
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.layout.collectionView!.scrollToItem(at: indexPath, at: .left, animated: true)
            
            self.pageControl.set(progress: indexOfMajorCell, animated: true)
        }
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = cellWidth
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(mainOptions.count - 1, index))
        
        return safeIndex
    }
    
}
