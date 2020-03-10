//
//  CurrentAmenitiesViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 2/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CurrentAmenitiesViewController: UIViewController {
    
    var amenitiesName: [String] = [] {
        didSet {
            var array: [String] = []
            for name in amenitiesName {
                array.append(name.capitalizingFirstLetter())
            }
            amenitiesName = array
            self.amenitiesPicker.reloadData()
        }
    }
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        
        return layout
    }()
    
    lazy var amenitiesPicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = false
        view.register(CurrentAmenities.self, forCellWithReuseIdentifier: "Cell")
        view.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        amenitiesPicker.delegate = self
        amenitiesPicker.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(amenitiesPicker)
        amenitiesPicker.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        amenitiesPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        amenitiesPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        amenitiesPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }

}


extension CurrentAmenitiesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenitiesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let amenitiesText = amenitiesName[indexPath.row]
        let width = amenitiesText.width(withConstrainedHeight: 36, font: Fonts.SSPRegularH5) + 24
        
        return CGSize(width: width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CurrentAmenities
        cell.iconLabel.text = amenitiesName[indexPath.row]
        
        return cell
    }
    
}


class CurrentAmenities: UICollectionViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(cellView)
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(iconLabel)
        iconLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        iconLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        iconLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        iconLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
