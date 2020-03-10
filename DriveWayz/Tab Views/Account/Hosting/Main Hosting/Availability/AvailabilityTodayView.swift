//
//  AvailabilityTodayView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/12/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class AvailabilityTodayView: UIViewController {
    
    var hourValues: [CGFloat] = []
    var halfHours: [Date] = []
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Upcoming hourly trends"
        
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
        label.text = "Today's availability"
        
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
        controller.options.append(AvailabilityOptions(text: "See full availability", icon: UIImage(named: "hostAvailabilityClock")))
        controller.options.append(AvailabilityOptions(text: "Mark spot inactive", icon: UIImage(named: "hostAvailabilityNegative")))
        
        return controller
    }()
    
    func setData() {
        halfHours = []
        let halfHour = TimeInterval(1800)
        var date = Date().round(precision: halfHour, rule: .down)
        while date.isInToday {
            halfHours.append(date)
            date = date.addingTimeInterval(halfHour)
        }
        hourValues = parkingValues.suffix(halfHours.count)
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

extension AvailabilityTodayView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return halfHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 62, height: 86)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! AvailabilityHoursCell
        
        if halfHours.count > indexPath.row && hourValues.count > indexPath.row {
            cell.date = halfHours[indexPath.row]
            cell.value = hourValues[indexPath.row]
        }
        if indexPath.row == 0 {
            cell.dateLabel.text = "NOW"
            cell.dateLabel.alpha = 1
        } else if indexPath.row == 1 {
            cell.dateLabel.alpha = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

class AvailabilityHoursCell: UICollectionViewCell {
    
    var day: Bool = false
    var date: Date? {
        didSet {
            if day {
                formatter.dateFormat = "E"
            } else {
                formatter.dateFormat = "h a"
            }
            if let date = date {
                let minutes = calendar.component(.minute, from: date)
                if minutes > 0 {
                    dateLabel.alpha = 0
                } else {
                    dateLabel.alpha = 1
                }
                let string = formatter.string(from: date)
                dateLabel.text = string.uppercased()
            }
        }
    }
    
    var value: CGFloat = 0.0 {
        didSet {
            let height = 28 + 28 * value
            let alphaVal = 0.4 + 0.6 * value
            availableViewHeight.constant = height
            availableView.alpha = alphaVal
            layoutIfNeeded()
        }
    }
    
    var availableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NOW"
        label.textColor = Theme.BLACK
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    var availableViewHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(dateLabel)
        addSubview(availableView)
        
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateLabel.sizeToFit()
        
        availableView.anchor(top: nil, left: leftAnchor, bottom: dateLabel.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 6, paddingBottom: 8, paddingRight: 6, width: 0, height: 0)
        availableViewHeight = availableView.heightAnchor.constraint(equalToConstant: 56)
            availableViewHeight.isActive = true
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

