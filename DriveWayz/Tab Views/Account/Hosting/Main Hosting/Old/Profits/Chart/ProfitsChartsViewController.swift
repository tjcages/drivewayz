//
//  ProfitsChartsViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsChartsViewController: UIViewController {
    
    var datesArray: [String] = ["APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT"]
    var maxValue: Double = 0.0
    var profitsArray: [Double] = [] {
        didSet {
            if let max = self.profitsArray.max() {
                self.maxValue = max
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.LightBlue, bottomColor: Theme.DarkBlue)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneWidth * 0.82 + 8)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    lazy var datePicker: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        view.register(DateCell.self, forCellWithReuseIdentifier: "Cell")
        
        return view
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.1)
        
        return view
    }()

    var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE.withAlphaComponent(0.1)
        
        return view
    }()
    
    var tableButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BAR", for: .normal)
        button.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    var chartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("LINE", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 16
        button.alpha = 0
        
        return button
    }()
    
    var totalEarnings: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "$0.00"
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var datesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.6)
//        label.text = "15TH MAY - 14TH JUN"
        label.font = Fonts.SSPRegularH6
        
        return label
    }()
    
    lazy var profitsChart: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
//        view.isScrollEnabled = false
        view.register(ChartCell.self, forCellWithReuseIdentifier: "Chart")
        
        return view
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "openDots")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var highlight: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.WHITE.withAlphaComponent(0.2), bottomColor: Theme.WHITE.withAlphaComponent(0.0))
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneWidth * 0.82 - 56)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.clipsToBounds = true
        view.alpha = 0
        
        return view
    }()
    
    var amountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN
        button.setTitle("$0.00", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 7
        button.isUserInteractionEnabled = false
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.alpha = 0
        
        return button
    }()
    
    var triangleView: TriangleView = {
        let triangle = TriangleView()
        triangle.backgroundColor = UIColor.clear
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.color = Theme.GREEN
        triangle.transform = CGAffineTransform(rotationAngle: CGFloat.pi + CGFloat.pi/7.91)
        triangle.alpha = 0
        
        return triangle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2

        setupViews()
        setupTop()
        setupSelector()
        
        profitsChart.delegate = self
        profitsChart.dataSource = self
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(tableButton)
        tableButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        tableButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        tableButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        tableButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.view.addSubview(chartButton)
        chartButton.leftAnchor.constraint(equalTo: tableButton.rightAnchor).isActive = true
        chartButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        chartButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        chartButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.view.addSubview(bottomLine)
        bottomLine.bottomAnchor.constraint(equalTo: chartButton.topAnchor, constant: -12).isActive = true
        bottomLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
    }
    
    var highlighCenterAnchor: NSLayoutConstraint!
    
    func setupTop() {
        
        let width = phoneWidth - 24
        let space = width/6
        
        self.view.addSubview(highlight)
        highlighCenterAnchor = highlight.centerXAnchor.constraint(equalTo: container.leftAnchor)
            highlighCenterAnchor.isActive = true
        highlight.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        highlight.bottomAnchor.constraint(equalTo: bottomLine.topAnchor).isActive = true
        highlight.widthAnchor.constraint(equalToConstant: space).isActive = true
        
        self.view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(topLine)
        topLine.topAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
        topLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        
        self.view.addSubview(totalEarnings)
        totalEarnings.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 4).isActive = true
        totalEarnings.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        totalEarnings.sizeToFit()
        
        self.view.addSubview(datesLabel)
        datesLabel.topAnchor.constraint(equalTo: totalEarnings.bottomAnchor, constant: 0).isActive = true
        datesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        datesLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        datesLabel.sizeToFit()
        
        self.view.addSubview(profitsChart)
        profitsChart.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 8).isActive = true
        profitsChart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profitsChart.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        profitsChart.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -8).isActive = true
        
    }
    
    var amountCenterXAnchor: NSLayoutConstraint!
    var amountBottomAnchor: NSLayoutConstraint!
    var amountLeftAnchor: NSLayoutConstraint!
    var amountRightAnchor: NSLayoutConstraint!
    
    func setupSelector() {
        
        self.view.addSubview(triangleView)
        self.view.addSubview(amountButton)
        
        amountButton.bottomAnchor.constraint(equalTo: triangleView.topAnchor, constant: 11).isActive = true
        amountLeftAnchor = amountButton.leftAnchor.constraint(equalTo: triangleView.leftAnchor, constant: 4)
            amountLeftAnchor.isActive = true
        amountRightAnchor = amountButton.rightAnchor.constraint(equalTo: triangleView.rightAnchor, constant: -4)
            amountRightAnchor.isActive = false
        amountButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        amountButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        amountCenterXAnchor = triangleView.leftAnchor.constraint(equalTo:  container.leftAnchor)
            amountCenterXAnchor.isActive = true
        amountBottomAnchor = triangleView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
            amountBottomAnchor.isActive = true
        triangleView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        triangleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
}


extension ProfitsChartsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.container.bounds.width
        let space = width/7
        if collectionView == self.profitsChart {
            let height = self.profitsChart.bounds.height
            return CGSize(width: space, height: height)
        } else {
            return CGSize(width: space, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.profitsChart {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Chart", for: indexPath as IndexPath) as! ChartCell
            cell.maxValue = self.maxValue
            if indexPath.row < self.profitsArray.count {
                cell.value = self.profitsArray[indexPath.row]
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! DateCell
            cell.iconLabel.text = self.datesArray[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.datePicker.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.profitsChart.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        let chartCell = self.profitsChart.cellForItem(at: indexPath) as! ChartCell
        let dateCell = self.datePicker.cellForItem(at: indexPath) as! DateCell
        self.amountButton.alpha = 1
        if let location = collectionView.layoutAttributesForItem(at: indexPath) {
            let x = location.center.x
            var xx = x
            let y = chartCell.bar.bounds.maxY
            
            if indexPath.row >= 4 {
                xx = x - 10
                self.amountLeftAnchor.isActive = false
                self.amountRightAnchor.isActive = true
                UIView.animate(withDuration: animationIn) {
                    self.amountButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
                    self.triangleView.transform = CGAffineTransform(rotationAngle: CGFloat.pi - CGFloat.pi/7.91)
                    self.view.layoutIfNeeded()
                }
            } else {
                self.amountLeftAnchor.isActive = true
                self.amountRightAnchor.isActive = false
                UIView.animate(withDuration: animationIn) {
                    self.amountButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                    self.triangleView.transform = CGAffineTransform(rotationAngle: CGFloat.pi + CGFloat.pi/7.91)
                    self.view.layoutIfNeeded()
                }
            }
            
            self.amountCenterXAnchor.constant = xx
            self.amountBottomAnchor.constant = -y + 80
            self.highlighCenterAnchor.constant = x
            UIView.animate(withDuration: animationIn) {
                self.highlight.center.x = x
                self.highlight.alpha = 1
                chartCell.bar.alpha = 1
                dateCell.iconLabel.font = Fonts.SSPSemiBoldH6
                dateCell.iconLabel.textColor = Theme.WHITE
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.datePicker.deselectItem(at: indexPath, animated: false)
        self.profitsChart.deselectItem(at: indexPath, animated: false)
        
        let chartCell = self.profitsChart.cellForItem(at: indexPath) as! ChartCell
        let dateCell = self.datePicker.cellForItem(at: indexPath) as! DateCell
    
        UIView.animate(withDuration: animationIn) {
            chartCell.bar.alpha = 0.2
            dateCell.iconLabel.font = Fonts.SSPRegularH6
            dateCell.iconLabel.textColor = Theme.WHITE.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        }
    }
    
}



class DateCell: UICollectionViewCell {
    
    var iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.6)
        label.font = Fonts.SSPRegularH6
        label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    func setupViews() {

        self.addSubview(iconLabel)
        iconLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        iconLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        iconLabel.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        iconLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChartCell: UICollectionViewCell {
    
    var maxValue: Double = 0.0
    var value: Double = 0.0 {
        didSet {
            let max = self.bounds.height - 24
            let percentage = self.value/self.maxValue
            let height = Double(max) * percentage + 24
            self.barHeightAnchor.constant = CGFloat(height)
            self.layoutIfNeeded()
        }
    }
    
    var bar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 10
        view.alpha = 0.2
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    var barHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.addSubview(bar)
        bar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        barHeightAnchor = bar.heightAnchor.constraint(equalToConstant: 24)
            barHeightAnchor.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
