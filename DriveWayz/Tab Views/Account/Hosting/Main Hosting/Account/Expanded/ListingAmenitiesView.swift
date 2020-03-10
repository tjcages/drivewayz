//
//  ListingAmenitiesView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingAmenitiesView: UIViewController {

    var selectAmenities: Int = 1
    lazy var cellWidth: CGFloat = 144
    lazy var cellHeight: CGFloat = 56
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Amenities"
        
        return label
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        return layout
    }()
    
    lazy var amenitiesPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = .clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(ListingAmenitiesCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return picker
    }()

    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        amenitiesPicker.delegate = self
        amenitiesPicker.dataSource = self

        setupViews()
    }
    
    var picturesWidth: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(arrowButton)
        arrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: informationLabel.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(amenitiesPicker)
        amenitiesPicker.anchor(top: informationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: cellHeight)
        picturesWidth = amenitiesPicker.widthAnchor.constraint(equalToConstant: cellWidth * 2 + 20 + 40)
            picturesWidth.isActive = true
        
        view.addSubview(line)
        line.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }

}

extension ListingAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectAmenities + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! ListingAmenitiesCell
        
//        if let image = images[tag] {
//            cell.selectedImage.image = image
//            if indexPath.row == selectedIndex {
//                cell.checked()
//            }
//        } else {
//            cell.selectedImage.image = nil
//        }
        
        return cell
    }
    
}

class ListingAmenitiesCell: UICollectionViewCell {
    
    var amenityIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "newHostBeach")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.numberOfLines = 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight =  20
        let attrString = NSMutableAttributedString(string: "Beach Parking")
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.BLUE
        clipsToBounds = true
        layer.cornerRadius = 4
        
        setupViews()
    }
    
    func setupViews() {

        addSubview(amenityIcon)
        addSubview(mainLabel)
        
        amenityIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        amenityIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amenityIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        amenityIcon.widthAnchor.constraint(equalTo: amenityIcon.heightAnchor).isActive = true
        
        mainLabel.leftAnchor.constraint(equalTo: amenityIcon.rightAnchor, constant: 12).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 12).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
