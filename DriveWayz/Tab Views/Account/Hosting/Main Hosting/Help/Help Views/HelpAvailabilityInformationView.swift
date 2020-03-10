//
//  HelpAvailabilityInformationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HelpAvailabilityInformationView: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Let's Get Started", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLACK
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You can always change availability \npreferences in the host portal."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var mainIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "mainQuickHost")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.GRAY_WHITE
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Know when your \nspot is booked"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get notified when your parking spot \nis in use and for how long."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var currentlyBookedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Currently booked"
        mainLabel.textColor = Theme.WHITE
        mainLabel.font = Fonts.SSPSemiBoldH4
        
        let subLabel = UILabel()
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.text = "11:15am • 2:45pm"
        subLabel.textColor = Theme.WHITE
        subLabel.font = Fonts.SSPRegularH5
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        subLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
        return view
    }()
    
    var nextMainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't stress the details"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var nextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ensure your spot is ready \nfor the times listed and \nwe’ll handle the rest."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 3
        
        return label
    }()
    
    var calendarView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "flat-calendar")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var availabilityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainAvailabilityLabel: UILabel = {
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
        picker.isScrollEnabled = false
        
        return picker
    }()
    
    var unavailableButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.SALMON.withAlphaComponent(0.2)
        button.setTitle("Mark spot unavailable", for: .normal)
        button.setTitleColor(Theme.SALMON, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        let image = UIImage(named: "hostAvailabilityNegative")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.SALMON
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 32)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        button.contentHorizontalAlignment = .right
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        
        return button
    }()

    var lastSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Need your spot back? \nMark inactivate to prevent bookings."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var worksView: HelpWorksView = {
        let view = HelpWorksView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.index = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.delegate = self
        datePicker.dataSource = self

        setupViews()
        setupAvailability()
        setupMainButton()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        view.addSubview(currentlyBookedView)
        currentlyBookedView.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 56)
        
        view.addSubview(nextMainLabel)
        view.addSubview(nextSubLabel)
        view.addSubview(calendarView)
        
        nextMainLabel.topAnchor.constraint(equalTo: currentlyBookedView.bottomAnchor, constant: 32).isActive = true
        nextMainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nextMainLabel.sizeToFit()
        
        nextSubLabel.anchor(top: nextMainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: calendarView.leftAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        nextSubLabel.sizeToFit()
        
        calendarView.centerYAnchor.constraint(equalTo: nextSubLabel.centerYAnchor).isActive = true
        calendarView.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 80, height: 80)
        
    }
    
    func setupAvailability() {

        view.addSubview(availabilityView)
        availabilityView.anchor(top: nextSubLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 202)
        
        availabilityView.addSubview(mainAvailabilityLabel)
        mainAvailabilityLabel.topAnchor.constraint(equalTo: availabilityView.topAnchor, constant: 16).isActive = true
        mainAvailabilityLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 20).isActive = true
        mainAvailabilityLabel.sizeToFit()
        
        availabilityView.addSubview(availableLabel)
        availabilityView.addSubview(checkmark)
        
        availableLabel.topAnchor.constraint(equalTo: mainAvailabilityLabel.bottomAnchor, constant: 20).isActive = true
        availableLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 20).isActive = true
        availableLabel.sizeToFit()
        
        checkmark.anchor(top: nil, left: availableLabel.rightAnchor, bottom: availableLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 0, width: 16, height: 16)
        
        availabilityView.addSubview(datePicker)
        datePicker.anchor(top: availableLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth - 60, height: 86)
        datePicker.centerXAnchor.constraint(equalTo: availabilityView.centerXAnchor).isActive = true
        
        view.addSubview(unavailableButton)
        unavailableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unavailableButton.anchor(top: availabilityView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 248, height: 48)
        
        view.addSubview(lastSubLabel)
        lastSubLabel.anchor(top: unavailableButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        lastSubLabel.sizeToFit()
        
    }
    
    func setupMainButton() {
        
        view.addSubview(worksView)
        view.addSubview(container)
        
        worksView.anchor(top: lastSubLabel.bottomAnchor, left: view.leftAnchor, bottom: container.topAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, width: 0, height: 0)
        
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -400, paddingRight: 0, width: 0, height: 648)
        
        view.addSubview(mainButton)
        view.addSubview(informationLabel)
        view.addSubview(mainIcon)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight).isActive = true
        
        informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        informationLabel.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 20, width: 0, height: 0)
        informationLabel.sizeToFit()
        
        mainIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainIcon.anchor(top: nil, left: nil, bottom: informationLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 30, height: 30)
        
    }

}

extension HelpAvailabilityInformationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (phoneWidth - 60)/7
        let size = CGSize(width: width, height: 72)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! AvailabilityHoursCell
        cell.dateLabel.font = Fonts.SSPRegularH5
    
        if indexPath.row == 0 {
            cell.dateLabel.text = "NOW"
            cell.dateLabel.alpha = 1
            cell.value = 0.4
        } else if indexPath.row == 1 {
            cell.dateLabel.alpha = 0
            cell.value = 0.6
        } else if indexPath.row == 2 {
            cell.value = 0.2
        } else if indexPath.row == 3 {
            cell.dateLabel.text = "6 PM"
            cell.dateLabel.alpha = 1
            cell.value = 0.1
        } else if indexPath.row == 6 {
            cell.dateLabel.text = "9 PM"
            cell.dateLabel.alpha = 1
            cell.value = 0.8
        } else if indexPath.row == 4 {
            cell.availableView.backgroundColor = Theme.GRAY_WHITE_4
            cell.value = 0.4
        } else if indexPath.row == 5 {
            cell.availableView.backgroundColor = Theme.GRAY_WHITE_4
            cell.value = 0.6
        }
        
        return cell
    }
    
}
