//
//  EarningsWalletView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EarningsWalletView: UIViewController {
    
    var hostListing: ParkingSpots? {
        didSet {
            if let parking = hostListing {
                if let timestamp = parking.timestamp {
                    setData(timestamp: timestamp)
                }
            }
        }
    }
    
    var dates: [Date] = []
    var selectedPoint: CGPoint = .zero
    var timer: Timer?
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Dashboard"
        
        return label
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Transfer", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var earningsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$45.23"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPExtraLarge
        
        return label
    }()

    var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "Current balance"
        
        return label
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "Since Nov. 12, 2019"
        
        return label
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
//        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(EarningsDayCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 16, right: 14)
        picker.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        picker.clipsToBounds = false
        
        return picker
    }()
    
    var optionsController: AvailabilityOptionsView = {
        let controller = AvailabilityOptionsView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.options.append(AvailabilityOptions(text: "See earnings history", icon: UIImage(named: "hostEarningsHistory")))
        
        return controller
    }()
    
    var selectView: EarningsSelectView = {
        let view = EarningsSelectView()
        view.transform = CGAffineTransform(scaleX: -0.8, y: 0.6)
        
        return view
    }()
    
    var noneView: EarningsNoneView = {
        let view = EarningsNoneView()
        
        return view
    }()
    
    func setData(timestamp: TimeInterval) {
        var date = Date(timeIntervalSince1970: timestamp)
        dates = []
        while !date.isInTomorrow {
            dates.append(date)
            date = date.tomorrow
        }
        dates.reverse()
        datePicker.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.delegate = self
        datePicker.dataSource = self

        setupViews()
    }
    
    var selectionCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(subLabel)
        view.addSubview(container)
        
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        container.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(earningsLabel)
        view.addSubview(balanceLabel)
        view.addSubview(informationLabel)
        
        earningsLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        earningsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        earningsLabel.sizeToFit()
        
        balanceLabel.topAnchor.constraint(equalTo: earningsLabel.bottomAnchor, constant: 4).isActive = true
        balanceLabel.leftAnchor.constraint(equalTo: earningsLabel.leftAnchor).isActive = true
        balanceLabel.sizeToFit()
        
        informationLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: earningsLabel.leftAnchor).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(datePicker)
        datePicker.anchor(top: informationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 102)
        
        view.addSubview(transferButton)
        transferButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        transferButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        transferButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(optionsController.view)
        optionsController.view.anchor(top: transferButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        datePicker.addSubview(selectView)
        selectionCenterAnchor = selectView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            selectionCenterAnchor.isActive = true
        selectView.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -4).isActive = true
        selectView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        selectView.widthAnchor.constraint(equalToConstant: 176).isActive = true
        
        view.addSubview(noneView)
        noneView.anchor(top: datePicker.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func cellSelected() {
        optionsController.cellSelected()
        let cells = datePicker.visibleCells as! [EarningsDayCell]
        for cell in cells {
            cell.cellSelected = true
        }
        UIView.animate(withDuration: animationIn, animations: {
            self.container.backgroundColor = Theme.BLUE
            self.transferButton.backgroundColor = Theme.WHITE
            self.transferButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            self.earningsLabel.textColor = Theme.WHITE
            self.balanceLabel.textColor = Theme.WHITE
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.selectView.alpha = 1
                self.selectView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
    }
    
    @objc func cellUnselected() {
        UIView.animate(withDuration: animationIn, animations: {
            self.selectView.transform = CGAffineTransform(scaleX: -0.8, y: 0.6)
            if self.selectView.alpha == 1 {
                self.selectView.alpha = 0
            }
        }) { (success) in
            self.optionsController.cellUnselected()
            let cells = self.datePicker.visibleCells as! [EarningsDayCell]
            for cell in cells {
                cell.cellSelected = false
            }
            UIView.animate(withDuration: animationIn) {
                self.container.backgroundColor = Theme.WHITE
                self.transferButton.backgroundColor = Theme.DARK_GRAY
                self.transferButton.setTitleColor(Theme.WHITE, for: .normal)
                self.earningsLabel.textColor = Theme.DARK_GRAY
                self.balanceLabel.textColor = Theme.DARK_GRAY
            }
        }
    }

}

extension EarningsWalletView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 62, height: 86)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! EarningsDayCell
        cell.tag = indexPath.row
        
        if dates.count > indexPath.row {
            let date = dates[indexPath.row]
            cell.date = date
            cell.value = 0.0
        }
        
        if container.backgroundColor == Theme.BLUE {
            cell.cellSelected = true
        } else {
            cell.cellSelected = false
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
        selectedPoint = collectionView.contentOffset
        timer?.invalidate()
        
        let cell = collectionView.cellForItem(at: indexPath) as! EarningsDayCell
        selectView.date = cell.date
        
        selectionCenterAnchor.isActive = false
        selectionCenterAnchor = selectView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
            selectionCenterAnchor.isActive = true
        
        cellSelected()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(cellUnselected), userInfo: nil, repeats: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if abs(selectedPoint.x - scrollView.contentOffset.x) >= phoneWidth && selectedPoint != .zero {
            selectedPoint = .zero
            if selectView.alpha == 1 {
                timer?.invalidate()
                selectView.alpha = 0
            }
        }
    }
    
}

class EarningsDayCell: UICollectionViewCell {
    
    var date: Date? {
        didSet {
            formatter.dateFormat = "MM/dd"
            if let date = date {
                let string = formatter.string(from: date)
                dateLabel.text = string
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
    
    var cellSelected: Bool = false {
        didSet {
            UIView.animate(withDuration: animationIn) {
                if self.cellSelected {
                    self.availableView.backgroundColor = Theme.WHITE
                    self.dateLabel.textColor = Theme.WHITE
                } else {
                    self.availableView.backgroundColor = Theme.BLUE
                    self.dateLabel.textColor = Theme.DARK_GRAY
                }
            }
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
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .center
        label.alpha = 0
        label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
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

