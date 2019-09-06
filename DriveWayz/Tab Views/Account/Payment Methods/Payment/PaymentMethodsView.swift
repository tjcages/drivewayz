//
//  PaymentMethodsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe

protocol updatePaymentMethod {
    func loadPayments()
}

class PaymentMethodsView: UIViewController, updatePaymentMethod {
    
    var delegate: changeSettingsHandler?
    var paymentMethods: [PaymentMethod] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        //        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment methods"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PaymentMethodsCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        
        scrollView.delegate = self
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
    }
    
    var gradientHeightAnchor: NSLayoutConstraint!
    var tableViewHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(optionsTableView)
        view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 140)
            gradientHeightAnchor.isActive = true
        case .iphoneX:
            gradientHeightAnchor = gradientContainer.heightAnchor.constraint(equalToConstant: 160)
            gradientHeightAnchor.isActive = true
        }
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 800)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        optionsTableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        optionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableViewHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 0)
            tableViewHeight.isActive = true
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        }
        
        view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
    
    }
    
    func loadPayments() {
        loadingLine.alpha = 1
        loadingLine.startAnimating()
    }
    
}

extension PaymentMethodsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = CGFloat(60 * (paymentMethods.count + 1)) - 1
        self.view.layoutIfNeeded()
        return paymentMethods.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PaymentMethodsCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        if indexPath.row < paymentMethods.count {
            cell.paymentMethod = paymentMethods[indexPath.row]
        }
        
        if indexPath.row == paymentMethods.count {
            cell.newCard()
        } else {
            cell.oldCard()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == paymentMethods.count {
            let controller = NewCardView()
            controller.delegate = self
            controller.paymentMethods = paymentMethods
            self.navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row < paymentMethods.count {
            let method = paymentMethods[indexPath.row]
            let controller = CurrentCardView()
            controller.delegate = self
            controller.paymentMethods = paymentMethods
            controller.observePayments(payment: method)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}



extension PaymentMethodsView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        var totalHeight: CGFloat = 0.0
        switch device {
        case .iphone8:
            totalHeight = 140
        case .iphoneX:
            totalHeight = 160
        }
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                self.gradientHeightAnchor.constant = totalHeight - percent * 60
                self.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            }
        } else {
            let translation = scrollView.contentOffset.y
            if translation < 0 && self.gradientHeightAnchor.constant != totalHeight {
                self.scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            self.scrollMinimized()
        } else {
            self.scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 140
        case .iphoneX:
            self.gradientHeightAnchor.constant = 160
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        switch device {
        case .iphone8:
            self.gradientHeightAnchor.constant = 80
        case .iphoneX:
            self.gradientHeightAnchor.constant = 100
        }
        UIView.animate(withDuration: animationOut, animations: {
            self.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class PaymentMethodsCell: UITableViewCell {
    
    var paymentCardTextField = STPPaymentCardTextField()
    var paymentMethod: PaymentMethod? {
        didSet {
            let params = STPCardParams()
            if let method = self.paymentMethod {
                if let cardNumber = method.last4 {
                    mainLabel.text = "•••• \(cardNumber)"
                }
                if let brand = method.brand?.lowercased() {
                    let methodStyle = CardType(dictionary: brand)
                    if let prefix = methodStyle.prefix {
                        params.number = prefix
                    }
                }
                paymentCardTextField.cardParams = STPPaymentMethodCardParams(cardSourceParams: params)
                if let image = paymentCardTextField.brandImage {
                    iconButton.setImage(image, for: .normal)
                }
                if method.defaultCard {
                    defaultButton.alpha = 1
                } else {
                    defaultButton.alpha = 0
                }
            }
        }
    }
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLUE
        button.alpha = 0
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var newCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add payment method", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.contentHorizontalAlignment = .left
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var defaultButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.GREEN_PIGMENT.withAlphaComponent(0.2)
        button.setTitle("Default", for: .normal)
        button.setTitleColor(Theme.GREEN_PIGMENT, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH6
        button.layer.cornerRadius = 25/2
        button.isUserInteractionEnabled = false
        button.alpha = 0
        
        return button
    }()
    
    var checkmark: UIButton = {
        let image = UIImage(named: "Checkmark")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25/2
        button.backgroundColor = Theme.GREEN_PIGMENT
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.alpha = 0
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(iconButton)
        addSubview(plusButton)
        addSubview(mainLabel)
        addSubview(arrowButton)
        addSubview(newCardButton)
        addSubview(defaultButton)
        addSubview(checkmark)
        
        iconButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        iconButton.heightAnchor.constraint(equalTo: iconButton.widthAnchor).isActive = true
        iconButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 16).isActive = true
        mainLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        newCardButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        newCardButton.leftAnchor.constraint(equalTo: plusButton.rightAnchor, constant: 12).isActive = true
        newCardButton.sizeToFit()
        
        defaultButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        defaultButton.leftAnchor.constraint(equalTo: mainLabel.rightAnchor, constant: 12).isActive = true
        defaultButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        defaultButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        checkmark.rightAnchor.constraint(equalTo: arrowButton.rightAnchor).isActive = true
        checkmark.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor).isActive = true
        
    }
    
    func newCard() {
        newCardButton.alpha = 1
        plusButton.alpha = 1
        defaultButton.alpha = 0
        iconButton.alpha = 0
        mainLabel.alpha = 0
        arrowButton.alpha = 0
    }
    
    func oldCard() {
        newCardButton.alpha = 0
        plusButton.alpha = 0
        iconButton.alpha = 1
        mainLabel.alpha = 1
        arrowButton.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

