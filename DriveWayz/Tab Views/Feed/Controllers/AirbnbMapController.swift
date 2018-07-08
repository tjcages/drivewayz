//
//  AirbnbMapController.swift
//  airbnb-main
//
//  Created by Yonas Stephen on 20/4/17.
//  Copyright © 2017 Yonas Stephen. All rights reserved.
//

import UIKit
import MapKit

class AirbnbMapController: UIViewController {
    
    let cellID = "cellID"
    var headerViewHeightConstraint: NSLayoutConstraint?
    
    var minHeaderHeight: CGFloat {
        return headerView.minHeaderHeight
    }
    var midHeaderHeight: CGFloat {
        return headerView.midHeaderHeight
    }
    var maxHeaderHeight: CGFloat {
        return headerView.maxHeaderHeight
    }
    
    let locations = ["Oslo", "Stockholm", "Barcelona", "Madrid", "Copenhagen", "London", "Milan", "Rome", "Hamburg"]
    
    lazy var items: [AirbnbHome] = {
        var arr = [AirbnbHome]()
        for i in 5..<11 {
            let location = self.locations[Int(arc4random_uniform(UInt32(self.locations.count)))]
            let item = AirbnbHome(imageName: "home-\(i)", description: "Entire home in \(location)", price: Int(arc4random_uniform(100) + 200), reviewCount: Int(arc4random_uniform(300) + 1), rating: Double(arc4random()) / Double(UINT32_MAX) + 4)
            arr.append(item)
        }
        return arr
    }()
    
    lazy var headerView: AirbnbMapExploreHeaderView = {
        let view = AirbnbMapExploreHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = AirbnbExploreController()
        view.pageTabDelegate = self as? AirbnbExploreHeaderViewDelegate
        return view
    }()
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.backgroundColor = UIColor.white
        mapView.layer.masksToBounds = false
        mapView.layer.shadowColor = UIColor.darkGray.cgColor
        mapView.layer.shadowOpacity = 4
        mapView.layer.shadowOffset = CGSize.zero
        mapView.layer.shadowRadius = 5
        return mapView
    }()
    
    lazy var thumbnailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 200, height: 185)
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.register(AirbnbMapItemCell.self, forCellWithReuseIdentifier: self.cellID)
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        view.addSubview(thumbnailCollectionView)
        
        thumbnailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        thumbnailCollectionView.heightAnchor.constraint(equalToConstant: 185).isActive = true
        thumbnailCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thumbnailCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(mapView)
        
        mapView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        mapView.bottomAnchor.constraint(equalTo: thumbnailCollectionView.topAnchor, constant: -10).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
    
    }
    
    func didCollapseHeader(completion: (() -> Void)?) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            let oldHeight = self.headerView.frame.size.height
            self.headerViewHeightConstraint?.constant = self.midHeaderHeight
            self.headerView.updateHeader(newHeight: self.midHeaderHeight, offset: self.midHeaderHeight - oldHeight)
            self.view.layoutIfNeeded()
        })
    }
    
    func didExpandHeader(completion: (() -> Void)?) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            let oldHeight = self.headerView.frame.size.height
            self.headerViewHeightConstraint?.constant = self.maxHeaderHeight
            self.headerView.updateHeader(newHeight: self.maxHeaderHeight, offset: self.maxHeaderHeight - oldHeight)
            self.view.layoutIfNeeded()
        })
    }
    
}

extension AirbnbMapController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AirbnbMapItemCell
        
        cell.home = items[indexPath.item]
        
        return cell
    }
}
