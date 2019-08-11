//
//  HostPromotionsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CHIPageControl

class HostPromotionsViewController: UIViewController {
    
    lazy var cellWidth = phoneWidth - 52
    private var indexOfCellBeforeDragging = 0
    var promotions: [String] = ["Invite a friend to become a host!",
                                "Save money on everyday parking!",
                                "Use your earnings \nback on parking",
                                "Prepare for events \nwith dynamic pricing"
    ]
    var promotionSub: [String] = ["Each take $10 credit",
                                  "Invite a friend for 10% off",
                                  "Never pay for parking again!",
                                  "Earn more during busy times!",
    ]
    var promotionImage: [String] = ["hostPromotionMessage",
                                     "hostPromotionInvite",
                                     "hostPromotionsMoney",
                                     "hostPromotionsPricing",
    ]
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var promotionsPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(PromotionsCell.self, forCellWithReuseIdentifier: "Cell")
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.isPagingEnabled = true
        
        return view
    }()

    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "Do more with hosting"
        label.font = Fonts.SSPSemiBoldH5
        label.alpha = 0
        
        return label
    }()
    
    var pageControl: CHIPageControlPuya = {
        let pageControl = CHIPageControlPuya(frame: CGRect(x: 0, y:0, width: 100, height: 20))
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 4
        pageControl.radius = 4
        pageControl.tintColor = Theme.LIGHT_GRAY
        pageControl.currentPageTintColor = Theme.STRAWBERRY_PINK
        pageControl.padding = 6
        
        return pageControl
    }()
    
    lazy var lightBlurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customFifthColor(topColor: Theme.OFF_WHITE.withAlphaComponent(0), middleColor: Theme.OFF_WHITE, secondMiddleColor: Theme.OFF_WHITE, thirdMiddleColor: Theme.OFF_WHITE, fourthMiddleColor: Theme.OFF_WHITE, fifthMiddleColor: Theme.OFF_WHITE, bottomColor: Theme.OFF_WHITE)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: 272)
        background.zPosition = -10
        view.layer.insertSublayer(background, at: 0)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        promotionsPicker.delegate = self
        promotionsPicker.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(lightBlurView)
        lightBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        lightBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        lightBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        lightBlurView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        
        self.view.addSubview(promotionsPicker)
        promotionsPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        promotionsPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        promotionsPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        promotionsPicker.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        self.view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: promotionsPicker.topAnchor, constant: -4).isActive = true
        mainLabel.sizeToFit()
        
        self.view.addSubview(pageControl)
        pageControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        pageControl.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor).isActive = true
        pageControl.sizeToFit()
        
    }

}


// Populate spaces collectionView
extension HostPromotionsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = self.promotions.count
        return self.promotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! PromotionsCell
        
        if indexPath.row < self.promotions.count {
            cell.promotionLabel.text = self.promotions[indexPath.row]
            cell.promotionSubLabel.text = self.promotionSub[indexPath.row]
            cell.imageName = self.promotionImage[indexPath.row]
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        self.pageControl.set(progress: indexOfMajorCell, animated: true)
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < self.promotions.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = self.cellWidth * CGFloat(snapToIndex)
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = self.cellWidth
        let proportionalOffset = self.layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(self.promotions.count - 1, index))
        
        return safeIndex
    }
    
}



class PromotionsCell: UICollectionViewCell {
    
    var counterClockwise: Bool = true
    var imageName: String? {
        didSet {
            if let imageName = self.imageName, let image = UIImage(named: imageName) {
                self.iconImageView.image = image
                if imageName == "hostPromotionMessage" {
                    self.changeGradientColors(topColor: Theme.LightTeal, bottomColor: Theme.DarkTeal)
                } else if imageName == "hostPromotionInvite" {
                    self.changeGradientColors(topColor: Theme.LightOrange, bottomColor: Theme.DarkOrange)
                } else if imageName == "hostPromotionsMoney" {
                    self.changeGradientColors(topColor: Theme.LightGreen, bottomColor: Theme.DarkGreen)
                } else if imageName == "hostPromotionsPricing" {
                    self.changeGradientColors(topColor: Theme.LightPurple, bottomColor: Theme.DarkPurple)
                }
            }
        }
    }
    
    func changeGradientColors(topColor: UIColor, bottomColor: UIColor) {
        let background = CAGradientLayer().customColor(topColor: topColor, bottomColor: bottomColor)
        background.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        background.zPosition = -10
        gradientView.layer.addSublayer(background)
        let background2 = CAGradientLayer().customColor(topColor: topColor, bottomColor: bottomColor)
        background2.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        background2.zPosition = -10
        fadedGradientView.layer.addSublayer(background2)
        self.highlightView.backgroundColor = bottomColor
        self.seeMoreButton.setTitleColor(bottomColor, for: .normal)
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var gradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 46
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.6
        let background = CAGradientLayer().customColor(topColor: Theme.LightTeal, bottomColor: Theme.DarkTeal)
        background.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var fadedGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 72
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.alpha = 0.2
        let background = CAGradientLayer().customColor(topColor: Theme.LightTeal, bottomColor: Theme.DarkTeal)
        background.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "hostPromotionMessage")
        view.image = image
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var promotionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Invite a friend to become a host!"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var promotionSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Each take $10 credit"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var seeMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowColor = Theme.DARK_GRAY.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        
        setupViews()
        animateCirclesClockwise(counterClockwise: self.counterClockwise)
    }
    
    func setupViews() {
        
        self.addSubview(container)
        container.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(coverView)
        coverView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        coverView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        coverView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -12).isActive = true
        coverView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        container.addSubview(fadedGradientView)
        container.addSubview(gradientView)
        container.addSubview(iconImageView)
        
        gradientView.centerXAnchor.constraint(equalTo: container.rightAnchor, constant: -32).isActive = true
        gradientView.centerYAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        gradientView.widthAnchor.constraint(equalTo: gradientView.heightAnchor).isActive = true
        
        container.sendSubviewToBack(fadedGradientView)
        fadedGradientView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: -30).isActive = true
        fadedGradientView.leftAnchor.constraint(equalTo: gradientView.leftAnchor, constant: -30).isActive = true
        fadedGradientView.rightAnchor.constraint(equalTo: gradientView.rightAnchor, constant: 30).isActive = true
        fadedGradientView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 30).isActive = true
        
        iconImageView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 12).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: gradientView.leftAnchor, constant: 12).isActive = true
        iconImageView.rightAnchor.constraint(equalTo: gradientView.rightAnchor, constant: -12).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -12).isActive = true
        
        container.addSubview(promotionLabel)
        container.addSubview(highlightView)
        container.addSubview(promotionSubLabel)
        
        promotionLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        promotionLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        promotionLabel.rightAnchor.constraint(equalTo: iconImageView.leftAnchor, constant: -12).isActive = true
        promotionLabel.sizeToFit()
        
        promotionSubLabel.centerYAnchor.constraint(equalTo: highlightView.centerYAnchor).isActive = true
        promotionSubLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        promotionSubLabel.rightAnchor.constraint(lessThanOrEqualTo: iconImageView.rightAnchor, constant: -32).isActive = true
        promotionSubLabel.sizeToFit()
        
        highlightView.topAnchor.constraint(equalTo: promotionLabel.bottomAnchor, constant: 16).isActive = true
        highlightView.heightAnchor.constraint(equalTo: promotionSubLabel.heightAnchor, constant: 8).isActive = true
        highlightView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: -4).isActive = true
        highlightView.rightAnchor.constraint(equalTo: promotionSubLabel.rightAnchor, constant: 12).isActive = true
        
        container.addSubview(seeMoreButton)
        seeMoreButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).isActive = true
        seeMoreButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        seeMoreButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        seeMoreButton.sizeToFit()
        
    }
    
    func animateCirclesClockwise(counterClockwise: Bool) {
        var multiplier: CGFloat = 1
        if counterClockwise == true {
            self.counterClockwise = false
            multiplier = -1
        } else { self.counterClockwise = true }
        UIView.animate(withDuration: 6, animations: {
            self.gradientView.transform = CGAffineTransform(rotationAngle: multiplier * CGFloat.pi/2)
            self.fadedGradientView.transform = CGAffineTransform(rotationAngle: -multiplier * CGFloat.pi/4)
        }) { (success) in
            self.animateCirclesClockwise(counterClockwise: self.counterClockwise)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
