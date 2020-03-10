//
//  ListingPhotosView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/26/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingPhotosView: UIViewController {
    
    var selectImages: Int = 1
    lazy var cellWidth: CGFloat = 144
    lazy var cellHeight: CGFloat = 168
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Listing details"
        
        return label
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "Photos"
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "1 space"
        
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
        layout.minimumLineSpacing = 20
        
        return layout
    }()
    
    lazy var picturesPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = .clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(ListingPhotoCell.self, forCellWithReuseIdentifier: "identifier")
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
        
        picturesPicker.delegate = self
        picturesPicker.dataSource = self

        setupViews()
    }
    
    var picturesWidth: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(subLabel)
        view.addSubview(container)
        
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        container.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(mainLabel)
        view.addSubview(informationLabel)
        view.addSubview(arrowButton)
        
        mainLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        informationLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: mainLabel.bottomAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(picturesPicker)
        picturesPicker.anchor(top: informationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: cellHeight)
        picturesWidth = picturesPicker.widthAnchor.constraint(equalToConstant: cellWidth * 2 + 20 + 40)
            picturesWidth.isActive = true
        
        view.addSubview(line)
        line.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }

}

extension ListingPhotosView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectImages + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! ListingPhotoCell
        
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

class ListingPhotoCell: UICollectionViewCell {
    
    var addIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var selectedImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.BACKGROUND_GRAY
        clipsToBounds = true
        layer.cornerRadius = 8
        
        setupViews()
    }
    
    func setupViews() {

        addSubview(addIcon)
        addIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        addIcon.widthAnchor.constraint(equalTo: addIcon.heightAnchor).isActive = true
        
        addSubview(selectedImage)
        selectedImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
