//
//  TestEventsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class TestEventsViewController: UIViewController {
    
    let cellWidth: CGFloat = 300
    let cellHeight: CGFloat = 244
    
    var eventsLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 3
        
        return layout
    }()
    
    lazy var eventsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: cellHeight), collectionViewLayout: eventsLayout)
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.WHITE
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(EventCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsPicker.delegate = self
        eventsPicker.dataSource = self

        setupViews()
    }
    
    func setupViews() {
        view.addSubview(eventsPicker)
    }
    
}

extension TestEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == eventsPicker {
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            return CGSize(width: 70, height: 60)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView == eventsPicker {
//            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
//        } else {
//            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! EventCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
