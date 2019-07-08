//
//  SendOptionsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class SendOptionsViewController: UIViewController {
    
    let identifier = "cellID"
    var optionsTop: [String] = ["Spot is taken", "Can't find spot", "Bad picture", "Time was incorrect", "Had to leave early"]
    var optionsBottom: [String] = ["Car was towed", "Wrong location", "Vehicle was damaged", "Need a refund"]
    
    var optionsLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    lazy var topOptionsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: optionsLayout)
        picker.backgroundColor = UIColor.clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(MessageOptionsCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        return picker
    }()
    
    lazy var bottomOptionsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: optionsLayout)
        picker.backgroundColor = UIColor.clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(MessageOptionsCell.self, forCellWithReuseIdentifier: identifier)
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 84, bottom: 0, right: 24)
        
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topOptionsPicker.delegate = self
        topOptionsPicker.dataSource = self
        bottomOptionsPicker.delegate = self
        bottomOptionsPicker.dataSource = self
        
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(topOptionsPicker)
        topOptionsPicker.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        topOptionsPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topOptionsPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topOptionsPicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(bottomOptionsPicker)
        bottomOptionsPicker.topAnchor.constraint(equalTo: topOptionsPicker.bottomAnchor, constant: 12).isActive = true
        bottomOptionsPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomOptionsPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomOptionsPicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

}


extension SendOptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.optionsTop.count
        } else {
            return self.optionsBottom.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.topOptionsPicker {
            if self.optionsTop.count > indexPath.row {
                let width = (self.optionsTop[indexPath.row].width(withConstrainedHeight: 40, font: Fonts.SSPRegularH4)) + 32
                
                return CGSize(width: width, height: 40)
            } else {
                return CGSize(width: 100, height: 40)
            }
        } else if collectionView == self.bottomOptionsPicker {
            if self.optionsBottom.count > indexPath.row {
                let width = (self.optionsBottom[indexPath.row].width(withConstrainedHeight: 40, font: Fonts.SSPRegularH4)) + 32
                
                return CGSize(width: width, height: 40)
            } else {
                return CGSize(width: 100, height: 40)
            }
        } else {
            return CGSize(width: 100, height: 40)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if section == 0 {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        } else if section == 1 {
//            return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
//        } else {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MessageOptionsCell
        
        if collectionView == self.topOptionsPicker {
            if self.optionsTop.count > indexPath.row {
                cell.optionLabel.text = self.optionsTop[indexPath.row]
            }
        } else if collectionView == self.bottomOptionsPicker {
            if self.optionsBottom.count > indexPath.row {
                cell.optionLabel.text = self.optionsBottom[indexPath.row]
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.topOptionsPicker {
            let x = scrollView.contentOffset.x + 60
            let y = scrollView.contentOffset.y
            self.bottomOptionsPicker.contentOffset = CGPoint(x: x, y: y)
        } else {
            let x = scrollView.contentOffset.x - 60
            let y = scrollView.contentOffset.y
            self.topOptionsPicker.contentOffset = CGPoint(x: x, y: y)
        }
    }
    
}


class MessageOptionsCell: UICollectionViewCell {
    
    var optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Options"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.WHITE
        layer.shadowColor = Theme.DARK_GRAY.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.cornerRadius = self.bounds.height/2
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(optionLabel)
        optionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        optionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        optionLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


