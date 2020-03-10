//
//  HelpEarningsInformationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HelpEarningsInformationView: UIViewController {

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
        label.text = "You can always monitor earnings \nin the host portal."
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
        label.text = "It's your money, \nuse it how you want"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earn passive income from your \nparking space that you can transfer \nout or use to book more parking."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 3
        
        return label
    }()
    
    var currentEarningsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "$45.23"
        mainLabel.textColor = Theme.WHITE
        mainLabel.font = Fonts.SSPExtraLarge
        
        let balanceLabel = UILabel()
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.text = "Current balance"
        balanceLabel.textColor = Theme.WHITE
        balanceLabel.font = Fonts.SSPRegularH3
        
        let informationLabel = UILabel()
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.text = "Since Nov 12, 2019"
        informationLabel.textColor = Theme.LINE_GRAY
        informationLabel.font = Fonts.SSPRegularH4
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Transfer", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 4
        
        view.addSubview(button)
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 112).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubview(mainLabel)
        view.addSubview(balanceLabel)
        view.addSubview(informationLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        balanceLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        balanceLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        balanceLabel.sizeToFit()
        
        informationLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor).isActive = true
        informationLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        informationLabel.sizeToFit()
        
        return view
    }()
    
    var nextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get real-time stats and \nanalytics on how your \nspot is doing."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 3
        
        return label
    }()
    
    var clockView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "flat-clock")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    var selectView: EarningsSelectView = {
        let view = EarningsSelectView()
        view.alpha = 1
        view.profitLabel.text = "$10.14"
        view.subLabel.text = "Wed Nov. 12, 2019"
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var profitsPicker: UICollectionView = {
        let picker = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picker.backgroundColor = UIColor.clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(AvailabilityHoursCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.isScrollEnabled = false
        picker.clipsToBounds = false
        
        return picker
    }()

    var lastSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Maximize income by promoting \nwith Drivewayz."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var worksView: HelpWorksView = {
        let view = HelpWorksView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.index = 1
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        profitsPicker.delegate = self
        profitsPicker.dataSource = self

        setupViews()
        setupEarnings()
        setupMainButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delayWithSeconds(1) {
            let indexPath = IndexPath(row: 3, section: 0)
            self.profitsPicker.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            self.collectionView(self.profitsPicker, didSelectItemAt: indexPath)
        }
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
        
        view.addSubview(currentEarningsView)
        currentEarningsView.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 148)
        
        view.addSubview(nextSubLabel)
        view.addSubview(clockView)
        
        nextSubLabel.anchor(top: currentEarningsView.bottomAnchor, left: clockView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        nextSubLabel.sizeToFit()
        
        clockView.centerYAnchor.constraint(equalTo: nextSubLabel.centerYAnchor).isActive = true
        clockView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
    }
    
    var selectionCenterAnchor: NSLayoutConstraint!
    
    func setupEarnings() {
        
        view.addSubview(profitsPicker)
        profitsPicker.anchor(top: nextSubLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 166, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: phoneWidth - 28, height: 86)
        profitsPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profitsPicker.addSubview(selectView)
        selectionCenterAnchor = selectView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            selectionCenterAnchor.isActive = true
        selectView.bottomAnchor.constraint(equalTo: profitsPicker.topAnchor, constant: -24).isActive = true
        selectView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        selectView.widthAnchor.constraint(equalToConstant: 176).isActive = true
        
        view.addSubview(lastSubLabel)
        lastSubLabel.anchor(top: profitsPicker.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
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

extension HelpEarningsInformationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (phoneWidth - 28)/6
        let size = CGSize(width: width, height: 86)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! AvailabilityHoursCell
        cell.dateLabel.font = Fonts.SSPRegularH5
    
        if indexPath.row == 0 {
            cell.dateLabel.alpha = 0
            cell.value = 0.4
        } else if indexPath.row == 1 {
            cell.dateLabel.text = "11/10"
            cell.dateLabel.alpha = 1
            cell.value = 0.6
        } else if indexPath.row == 2 {
            cell.dateLabel.alpha = 0
            cell.value = 0.2
        } else if indexPath.row == 3 {
            cell.dateLabel.text = "11/12"
            cell.dateLabel.alpha = 1
            cell.availableView.backgroundColor = Theme.BLACK
            cell.value = 1.0
        } else if indexPath.row == 4 {
            cell.dateLabel.alpha = 0
            cell.value = 0.4
        } else if indexPath.row == 5 {
            cell.dateLabel.text = "TODAY"
            cell.dateLabel.alpha = 1
            cell.value = 0.7
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AvailabilityHoursCell
        
        selectionCenterAnchor.isActive = false
        selectionCenterAnchor = selectView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
            selectionCenterAnchor.isActive = true
    }
    
}
