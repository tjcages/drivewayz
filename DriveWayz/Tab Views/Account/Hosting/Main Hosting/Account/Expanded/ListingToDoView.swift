//
//  ListingToDoView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingToDoView: UIViewController {
    
    let cellWidth: CGFloat = 300
    let cellHeight: CGFloat = 192
    private var indexOfCellBeforeDragging = 0
    
    let numbers: Int = 2
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "To do"
        
        return label
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        
        return layout
    }()
    
    lazy var collectionPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = .clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(ToDoCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        
        return picker
    }()
    
    var paging: HorizontalPagingDisplay = {
        let view = HorizontalPagingDisplay()
        view.rightSelectionLine.isHidden = true
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        collectionPicker.delegate = self
        collectionPicker.dataSource = self
        
        setupViews()
    }
    

    func setupViews() {
        
        view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        view.addSubview(paging)
        paging.bottomAnchor.constraint(equalTo: subLabel.bottomAnchor).isActive = true
        paging.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 36.5).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        view.addSubview(collectionPicker)
        collectionPicker.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

}

extension ListingToDoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! ToDoCell
        
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
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < numbers && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = self.cellWidth * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.layout.collectionView!.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = cellWidth
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(numbers - 1, index))
        
        return safeIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.x
        let percentage = translation/cellWidth
        paging.changeScroll(percentage: percentage)
    }
    
}

class ToDoCell: UICollectionViewCell {
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.numberOfLines = 2
        label.text = "Provide more descriptive pictures to earn higher ratings"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.text = "The current pictures do not clearly identify the parking space."
        
        return label
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        let image = UIImage(named: "hostHouse")
        view.image = image
        
        return view
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.backgroundColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 4
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.WHITE
//        layer.shadowColor = Theme.DARK_GRAY.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowRadius = 4
//        layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(mainGraphic)
        addSubview(transferButton)
        
        mainLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        mainLabel.sizeToFit()
        
        subLabel.anchor(top: mainLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        subLabel.sizeToFit()
        
        mainGraphic.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 0, width: 56, height: 56)
        
        transferButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 100, height: 36)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

