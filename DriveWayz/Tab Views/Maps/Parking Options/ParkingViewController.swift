//
//  ParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 12/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ParkingViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hourArray: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    var minuteArray: [Int] = [00,15,30,45]
    var delegate: handleCheckoutParking?
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        
        return view
    }()
    
    lazy var primeSpotController: PrimeSpotViewController = {
        let controller = PrimeSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        self.addChild(controller)
        
        return controller
    }()
    
    lazy var standardSpotController: StandardSpotViewController = {
        let controller = StandardSpotViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var bestPriceController: BestPriceViewController = {
        let controller = BestPriceViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    lazy var reserveSpotController: ReservationsViewController = {
        let controller = ReservationsViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        return controller
    }()
    
    var primeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.textAlignment = .center
        label.text = "Prime spot"
        label.font = Fonts.SSPRegularH3
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var bestPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = "Best price"
        label.font = Fonts.SSPRegularH3
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        label.isUserInteractionEnabled = true

        return label
    }()
    
    var standardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.text = "Standard spots"
        label.font = Fonts.SSPRegularH3
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    lazy var setTimesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SET TIME", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.WHITE
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        let background = CAGradientLayer().purpleColor()
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 48, height: 60)
        background.zPosition = -10
        button.layer.addSublayer(background)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var saveDurationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE DURATION", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLACK
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.addTarget(self, action: #selector(saveDurationPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    var durationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 0.5
        view.alpha = 0
        view.clipsToBounds = false
        
        return view
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "DURATION"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var hourPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.BLACK
        picker.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.BLACK, forKeyPath: "textColor")
        
        return picker
    }()
    
    var minutePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.tintColor = Theme.BLACK
        picker.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(Theme.BLACK, forKeyPath: "textColor")
        
        return picker
    }()
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "HOUR"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var minuteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "MINUTES"
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        view.alpha = 0
        
        let label = UILabel(frame: CGRect(x: 24, y: 10, width: 100, height: 30))
        label.text = "Visa 4422"
        label.font = Fonts.SSPRegularH4
        view.addSubview(label)
        
        return view
    }()
    
    var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PURPLE
        label.text = "$9.53"
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    var fullDatesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "2:15 PM to 4:30 PM"
        label.font = Fonts.SSPLightH3
        label.textAlignment = .right
        label.alpha = 0
        
        return label
    }()
    
    var informationIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "information")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var searchingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.text = "SEARCHING"
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var loadingActivity: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .ballPulse, color: Theme.BLACK, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        
        scrollView.delegate = self
        hourPicker.delegate = self
        hourPicker.dataSource = self
        minutePicker.delegate = self
        minutePicker.dataSource = self
        
        setupViews()
        setupDuration()
        setupPurchase()
    }
    
    var spotLabelAnchor: NSLayoutConstraint!
    
    var bestPriceWidth: CGFloat = 0
    var primeWidth: CGFloat = 0
    var standardWidth: CGFloat = 0
    
    @objc func primeLabelTapped() {
        UIView.animate(withDuration: animationIn) {
            self.scrollView.contentOffset.x = self.view.frame.width
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4)
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    @objc func bestPriceLabelTapped() { UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = 0 }}
    @objc func standardLabelTapped() { UIView.animate(withDuration: animationIn) { self.scrollView.contentOffset.x = self.view.frame.width*2 }}
    
    func setupViews() {
        
        self.primeWidth = (self.primeLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        self.bestPriceWidth = (self.bestPriceLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        self.standardWidth = (self.standardLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPRegularH2))!
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: 320)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(primeLabel)
        spotLabelAnchor = primeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            spotLabelAnchor.isActive = true
        primeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        primeLabel.widthAnchor.constraint(equalToConstant: primeWidth).isActive = true
        primeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let primeTap = UITapGestureRecognizer(target: self, action: #selector(primeLabelTapped))
        primeLabel.addGestureRecognizer(primeTap)
        
        self.view.addSubview(bestPriceLabel)
        bestPriceLabel.rightAnchor.constraint(equalTo: primeLabel.leftAnchor, constant: -24).isActive = true
        bestPriceLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        bestPriceLabel.widthAnchor.constraint(equalToConstant: bestPriceWidth).isActive = true
        bestPriceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let bestPriceTap = UITapGestureRecognizer(target: self, action: #selector(bestPriceLabelTapped))
        bestPriceLabel.addGestureRecognizer(bestPriceTap)
        
        self.view.addSubview(standardLabel)
        standardLabel.leftAnchor.constraint(equalTo: primeLabel.rightAnchor, constant: 24).isActive = true
        standardLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        standardLabel.widthAnchor.constraint(equalToConstant: standardWidth).isActive = true
        standardLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let standardTap = UITapGestureRecognizer(target: self, action: #selector(standardLabelTapped))
        standardLabel.addGestureRecognizer(standardTap)
        
        self.view.addSubview(searchingLabel)
        searchingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        searchingLabel.widthAnchor.constraint(equalToConstant: (searchingLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 4).isActive = true
        searchingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
        searchingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(loadingActivity)
        loadingActivity.leftAnchor.constraint(equalTo: searchingLabel.rightAnchor).isActive = true
        loadingActivity.bottomAnchor.constraint(equalTo: searchingLabel.bottomAnchor, constant: 0).isActive = true
        loadingActivity.widthAnchor.constraint(equalToConstant: 20).isActive = true
        loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor).isActive = true
        
        scrollView.addSubview(bestPriceController.view)
        bestPriceController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        bestPriceController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        bestPriceController.view.topAnchor.constraint(equalTo: primeLabel.bottomAnchor).isActive = true
        bestPriceController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(primeSpotController.view)
        primeSpotController.view.leftAnchor.constraint(equalTo: bestPriceController.view.rightAnchor).isActive = true
        primeSpotController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        primeSpotController.view.topAnchor.constraint(equalTo: primeLabel.bottomAnchor).isActive = true
        primeSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.addSubview(standardSpotController.view)
        standardSpotController.view.leftAnchor.constraint(equalTo: primeSpotController.view.rightAnchor).isActive = true
        standardSpotController.view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        standardSpotController.view.topAnchor.constraint(equalTo: primeLabel.bottomAnchor).isActive = true
        standardSpotController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    var durationViewTopAnchor: NSLayoutConstraint!
    
    func setupDuration() {
        
        self.view.addSubview(durationView)
        durationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        durationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        durationViewTopAnchor = durationView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300)
            durationViewTopAnchor.isActive = true
        durationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(setTimesButton)
        setTimesButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        setTimesButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        setTimesButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        setTimesButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true

        self.view.addSubview(saveDurationButton)
        saveDurationButton.heightAnchor.constraint(equalToConstant: 61).isActive = true
        saveDurationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        saveDurationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        saveDurationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        
        durationView.addSubview(durationLabel)
        durationLabel.topAnchor.constraint(equalTo: durationView.topAnchor, constant: 10).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        durationLabel.widthAnchor.constraint(equalToConstant: (durationLabel.text?.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3))! + 15).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(hourPicker)
        hourPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hourPicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        hourPicker.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: -4).isActive = true
        hourPicker.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        durationView.addSubview(minutePicker)
        minutePicker.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -20).isActive = true
        minutePicker.widthAnchor.constraint(equalToConstant: self.view.frame.width/2 - 24).isActive = true
        minutePicker.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: -4).isActive = true
        minutePicker.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        durationView.addSubview(hourLabel)
        hourLabel.leftAnchor.constraint(equalTo: hourPicker.centerXAnchor, constant: -15).isActive = true
        hourLabel.rightAnchor.constraint(equalTo: minutePicker.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: hourPicker.centerYAnchor).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(minuteLabel)
        minuteLabel.leftAnchor.constraint(equalTo: minutePicker.centerXAnchor, constant: 0).isActive = true
        minuteLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        minuteLabel.centerYAnchor.constraint(equalTo: minutePicker.centerYAnchor).isActive = true
        minuteLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setupPurchase() {
        
        durationView.addSubview(cardView)
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.setTimesButton.topAnchor, constant: 1).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        durationView.addSubview(informationIcon)
        let string = "PURCHASE"
        informationIcon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30 + string.width(withConstrainedHeight: 30, font: Fonts.SSPSemiBoldH3)).isActive = true
        informationIcon.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor, constant: 3).isActive = true
        informationIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        informationIcon.widthAnchor.constraint(equalTo: informationIcon.heightAnchor).isActive = true
        
        durationView.addSubview(totalCostLabel)
        totalCostLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        totalCostLabel.leftAnchor.constraint(equalTo: durationLabel.rightAnchor, constant: 24).isActive = true
        totalCostLabel.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor).isActive = true
        totalCostLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        durationView.addSubview(fullDatesLabel)
        fullDatesLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        fullDatesLabel.leftAnchor.constraint(equalTo: durationLabel.rightAnchor, constant: 24).isActive = true
        fullDatesLabel.topAnchor.constraint(equalTo: totalCostLabel.bottomAnchor).isActive = true
        fullDatesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        var percentage = offset/self.view.frame.width
        if offset < 0 {
            percentage = abs(percentage)
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) + ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * percentage
            self.bestPriceLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.bestPriceLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
        } else if offset >= 0 && offset <= self.view.frame.width {
            self.spotLabelAnchor.constant = ((self.bestPriceWidth/2 + 24) + (self.primeWidth/2)) * (1 - percentage)
            self.bestPriceLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.bestPriceLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.primeLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.primeLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
        } else if offset > self.view.frame.width && offset <= self.view.frame.width * 2 {
            percentage = percentage - 1
            self.spotLabelAnchor.constant = -(((self.standardWidth/2 + 24) + (self.primeWidth/2)) * (percentage))
            self.primeLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.primeLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * percentage)
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentage, y: 0.8 + 0.2 * percentage)
        } else if offset > self.view.frame.width * 2 {
            percentage = percentage - 2
            self.spotLabelAnchor.constant = -((self.standardWidth/2 + 24) + (self.primeWidth/2)) + ((self.standardWidth/2 + 24) + (self.primeWidth/2)) * -percentage
            self.standardLabel.textColor = Theme.BLACK.withAlphaComponent(0.4 + 0.6 * (1 - percentage))
            self.standardLabel.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * (1 - percentage), y: 0.8 + 0.2 * (1 - percentage))
        }
        self.view.layoutIfNeeded()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width/2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hourPicker && self.hourArray.count > 0 {
            return self.hourArray.count
        } else if pickerView == minutePicker && self.minuteArray.count > 0 {
            return self.minuteArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == hourPicker && self.hourArray.count > row {
            return "\(self.hourArray[row])"
        } else if pickerView == minutePicker && self.minuteArray.count > row {
            return "\(self.minuteArray[row])"
        } else {
            return "0"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 90, height: 80)
        
        let label = UILabel()
        label.frame = CGRect(x: -40, y: 0, width: 90, height: 80)
        label.textAlignment = .center
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH3
        
        if pickerView == hourPicker && self.hourArray.count > row {
            label.text = "\(self.hourArray[row])"
        } else if pickerView == minutePicker && self.minuteArray.count > row {
            if self.minuteArray[row] == 0 {
                label.text = "00"
            } else {
                label.text = "\(self.minuteArray[row])"
            }
        }
        
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPicker {
            if row > 0 {
                self.hourLabel.text = "HOURS"
            } else {
                self.hourLabel.text = "HOUR"
            }
        }
    }
    
    func bringUpSearch() {
        self.setTimesButton.removeTarget(nil, action: nil, for: .allEvents)
        self.setTimesButton.setTitle("", for: .normal)
        self.scrollView.alpha = 0
        self.primeLabel.alpha = 0
        self.bestPriceLabel.alpha = 0
        self.standardLabel.alpha = 0
        self.searchingLabel.alpha = 1
        self.loadingActivity.alpha = 1
        self.loadingActivity.startAnimating()
    }
    
    func parkingSelected() {
        self.setTimesButton.addTarget(self, action: #selector(setTimesPressed(sender:)), for: .touchUpInside)
        UIView.animate(withDuration: animationIn) {
            self.primeLabel.alpha = 1
            self.bestPriceLabel.alpha = 1
            self.standardLabel.alpha = 1
            self.scrollView.alpha = 1
            self.searchingLabel.alpha = 0
            self.loadingActivity.alpha = 0
            self.loadingActivity.stopAnimating()
        }
        self.setTimesButton.setTitle("SET TIME", for: .normal)
    }
    
    @objc func setTimesPressed(sender: UIButton) {
        self.delegate?.setTimesPressed()
        self.scrollView.isScrollEnabled = false
        self.saveDurationButton.alpha = 1
    }
    
    @objc func saveDurationPressed(sender: UIButton) {
        self.setTimesButton.removeTarget(nil, action: nil, for: .allEvents)
//        self.setTimesButton.addTarget(self, action: #selector(setTimesPressed(sender:)), for: .touchUpInside)
        self.saveDurationButton.alpha = 0
        UIView.animate(withDuration: animationIn) {
            self.hourPicker.alpha = 0
            self.minutePicker.alpha = 0
            self.hourLabel.alpha = 0
            self.minuteLabel.alpha = 0
            self.cardView.alpha = 1
            self.totalCostLabel.alpha = 1
            self.fullDatesLabel.alpha = 1
            self.informationIcon.alpha = 1
            self.durationViewTopAnchor.constant = 250
            self.view.layoutIfNeeded()
        }
        self.durationLabel.text = "PURCHASE"
        self.setTimesButton.setTitle("CONFIRM PURCHASE", for: .normal)
        self.primeSpotController.saveDurationPressed()
        self.delegate?.saveDurationPressed()
    }
    
    @objc func regularViewTapped() {
        guard let text = self.setTimesButton.titleLabel?.text else { return }
        if text == "CONFIRM PURCHASE" {
            self.setTimesButton.removeTarget(nil, action: nil, for: .allEvents)
            self.setTimesButton.addTarget(self, action: #selector(setTimesPressed(sender:)), for: .touchUpInside)
            self.delegate?.confirmPurchaseDismissed()
            self.primeSpotController.confirmPurchaseDismissed()
            self.saveDurationButton.alpha = 1
            UIView.animate(withDuration: animationIn) {
                self.hourPicker.alpha = 1
                self.minutePicker.alpha = 1
                self.hourLabel.alpha = 1
                self.minuteLabel.alpha = 1
                self.cardView.alpha = 0
                self.totalCostLabel.alpha = 0
                self.fullDatesLabel.alpha = 0
                self.informationIcon.alpha = 0
                self.durationViewTopAnchor.constant = 300
                self.view.layoutIfNeeded()
            }
            self.durationLabel.text = "DURATION"
            self.setTimesButton.setTitle("SAVE DURATION", for: .normal)
        } else {
            self.saveDurationButton.alpha = 0
            self.scrollView.isScrollEnabled = true
            self.setTimesButton.removeTarget(nil, action: nil, for: .allEvents)
            self.setTimesButton.addTarget(self, action: #selector(setTimesPressed(sender:)), for: .touchUpInside)
            self.delegate?.setTimesDismissed()
        }
    }
    
}
