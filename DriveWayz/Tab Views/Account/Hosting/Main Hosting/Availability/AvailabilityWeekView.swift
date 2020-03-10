//
//  AvailabilityWeekView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AvailabilityWeekView: UIViewController {

    lazy var hourValues: [CGFloat] = parkingDayValues
    var days: [Date] = []
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Upcoming day trends"
        
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
        label.font = Fonts.SSPSemiBoldH2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "This week"
        
        return label
    }()
    
    var availableLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Active"
        
        return label
    }()
    
    var checkmark: CheckBox = {
        let check = CheckBox()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.style = .tick
        check.isChecked = true
        check.borderStyle = .roundedSquare(radius: 8)
        check.checkedBorderColor = .clear
        check.checkboxBackgroundColor = .clear
        check.checkmarkColor = Theme.BLUE
        check.backgroundColor = Theme.HOST_BLUE
        check.layer.cornerRadius = 8
        check.clipsToBounds = true
        check.isUserInteractionEnabled = false
        
        return check
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var datePicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picker.backgroundColor = UIColor.clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(AvailabilityHoursCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        return picker
    }()
    
    var optionsController: AvailabilityOptionsView = {
        let controller = AvailabilityOptionsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.options.append(AvailabilityOptions(text: "See full calendar", icon: UIImage(named: "hostAvailabilityCalendar")))
        controller.options.append(AvailabilityOptions(text: "Reservation settings", icon: UIImage(named: "hostAccountGear")))
        
        return controller
    }()
    
    func setData() {
        days = []
        var date = Date()
        while days.count < 7 {
            days.append(date)
            date = date.tomorrow
        }
        if let max = hourValues.max() {
            hourValues = hourValues.map { $0 / max }
            datePicker.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.delegate = self
        datePicker.dataSource = self

        setupViews()
        setData()
    }
    
    func setupViews() {
        
        view.addSubview(subLabel)
        view.addSubview(container)
        
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        container.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        container.addSubview(availableLabel)
        container.addSubview(checkmark)
        
        availableLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20).isActive = true
        availableLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        availableLabel.sizeToFit()
        
        checkmark.anchor(top: nil, left: availableLabel.rightAnchor, bottom: availableLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 0, width: 16, height: 16)
        
        container.addSubview(datePicker)
        datePicker.anchor(top: availableLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 86)
        
        container.addSubview(optionsController.view)
        optionsController.view.anchor(top: datePicker.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

}

extension AvailabilityWeekView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 62, height: 86)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! AvailabilityHoursCell
        cell.day = true
        
        if days.count > indexPath.row && hourValues.count > indexPath.row {
            let date = days[indexPath.row]
            cell.date = date
            if let index = date.getDayOfWeekFC() {
                cell.value = hourValues[index]
            }
        }
        if indexPath.row == 0 {
            cell.dateLabel.text = "TODAY"
            cell.dateLabel.alpha = 1
        } else if indexPath.row % 2 == 0 {
            cell.dateLabel.alpha = 1
        } else {
            cell.dateLabel.alpha = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
