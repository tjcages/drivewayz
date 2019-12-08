//
//  HelpMenuController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/19/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol HelpMenuDelegate {
    func removeDim()
}

struct HelpMenuOption {
    let title: String
    let subtitle: String?
    let icon: UIImage?
    let action: String?
}

class HelpMenuController: UIViewController {

    var delegate: HostHelpDelegate?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    var options: [HelpMenuOption] = [] {
        didSet {
            tableViewHeight = 0
            for option in options {
                if option.subtitle != nil {
                    tableViewHeight += 92
                } else {
                    tableViewHeight += 60
                }
            }
        }
    }
    
    var allOptions: [Int: [HelpMenuOption]] = [0: [HelpMenuOption(title: "Booking issue", subtitle: "Problem with your current or most recent booking.", icon: UIImage(named: "helpIssue"), action: "Current"), HelpMenuOption(title: "Drivewayz Assistance", subtitle: nil, icon: UIImage(named: "helpAssistance"), action: nil)], 1: [HelpMenuOption(title: "Booking issue", subtitle: "Problem with your current or most recent booking.", icon: UIImage(named: "helpIssue"), action: "Current"), HelpMenuOption(title: "Reservations help", subtitle: nil, icon: UIImage(named: "helpCalendar"), action: nil)], 2: [HelpMenuOption(title: "Earnings balance issue", subtitle: nil, icon: UIImage(named: "hostEarningsIcon"), action: nil), HelpMenuOption(title: "Payment breakdown", subtitle: nil, icon: UIImage(named: "helpBreakdown"), action: nil), HelpMenuOption(title: "Payout issue", subtitle: nil, icon: UIImage(named: "helpPayment"), action: nil)], 3: [HelpMenuOption(title: "Delete listing", subtitle: "945 Diamond Street", icon: UIImage(named: "helpDelete"), action: "Active"), HelpMenuOption(title: "Drivewayz Assistance", subtitle: nil, icon: UIImage(named: "helpAssistance"), action: nil)]]
    var optionIndex: Int = 0 {
        didSet {
            if let option = allOptions[optionIndex] {
                options = option
            }
        }
    }
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var pullButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "pull-up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH2
        label.text = "Quick help"
        
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
        
    lazy var optionsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(HelpMenuCell.self, forCellReuseIdentifier: "cellId")
        view.separatorStyle = .none
        view.isScrollEnabled = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        optionsTable.delegate = self
        optionsTable.dataSource = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    var tableViewHeight: CGFloat = 0.0
    var panBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        container.addSubview(optionsTable)
        optionsTable.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: tableViewHeight)
        panBottomAnchor = optionsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight)
            panBottomAnchor.isActive = true
        
        container.addSubview(line)
        container.addSubview(mainLabel)
        
        line.anchor(top: nil, left: view.leftAnchor, bottom: optionsTable.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
        view.layoutIfNeeded()
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.panBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.panBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.panBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.panBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func dismissView() {
        delegate?.removeDim()
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension HelpMenuController: HelpMenuDelegate {
    
    func showBookingIssue() {
        hideCurrentView()
        delegate?.changeDimLevel(amount: 0.85)
        let controller = BookingIssueHelpView()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func showDrivewayzAssistance() {
        hideCurrentView()
        delegate?.changeDimLevel(amount: 0.85)
        let controller = DrivewayzAssistanceHelpView()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.isHidden = true
        present(navigation, animated: true, completion: nil)
    }
    
    func showReservationsHelp() {
        hideCurrentView()
        delegate?.changeDimLevel(amount: 0.85)
        let controller = ReservationsHelpView()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func showEarningsBalance() {
        hideCurrentView()
        delegate?.changeDimLevel(amount: 0.85)
        let controller = EarningsDisputeHelpView()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func showPaymentBreakdown() {
        hideCurrentView()
        delegate?.changeDimLevel(amount: 0.85)
        let controller = PaymentBreakdownHelpView()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func showPayoutIssue() {
        hideCurrentView()
        delegate?.changeDimLevel(amount: 0.85)
        let controller = PayoutIssueHelpView()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.isHidden = true
        present(navigation, animated: true, completion: nil)
    }
    
    func showDeleteListing() {
        hideCurrentView()
        delegate?.changeDimLevel(amount: 0.85)
        let controller = DeleteListingHelpView()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func hideCurrentView() {
        panBottomAnchor.constant = bottomAnchor + 120
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func removeDim() {
        delegate?.changeDimLevel(amount: 0.7)
        panBottomAnchor.constant = bottomAnchor
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension HelpMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if options.count > indexPath.row {
            let option = options[indexPath.row]
            if option.subtitle != nil {
                return 92
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! HelpMenuCell
        cell.selectionStyle = .none
        
        if options.count > indexPath.row {
            let option = options[indexPath.row]
            cell.option = option
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HelpMenuCell
        if let title = cell.mainLabel.text {
            if title == "Booking issue" {
                showBookingIssue()
            } else if title == "Drivewayz Assistance" {
                showDrivewayzAssistance()
            } else if title == "Reservations help" {
                showReservationsHelp()
            } else if title == "Earnings balance issue" {
                showEarningsBalance()
            } else if title == "Payment breakdown" {
                showPaymentBreakdown()
            } else if title == "Payout issue" {
                showPayoutIssue()
            } else if title == "Delete listing" {
                showDeleteListing()
            }
        }
    }
    
}

class HelpMenuCell: UITableViewCell {
    
    var option: HelpMenuOption? {
        didSet {
            if let option = option {
                mainLabel.text = option.title
                iconButton.setImage(option.icon?.withRenderingMode(.alwaysTemplate), for: .normal)
                if let subtitle = option.subtitle {
                    subLabel.text = subtitle
                    mainCenterAnchor.constant = -12
                    if subtitle.count >= 40 {
                        mainCenterAnchor.constant = -16
                        subLabel.font = Fonts.SSPRegularH5
                    } else {
                        subLabel.font = Fonts.SSPRegularH4
                    }
                } else {
                    mainCenterAnchor.constant = 0
                }
                if let action = option.action {
                    actionLabel.text = action
                    actionLabel.alpha = 1
                    subRightAnchor.isActive = false
                    subActionRightAnchor.isActive = true
                } else {
                    actionLabel.alpha = 0
                    subRightAnchor.isActive = true
                    subActionRightAnchor.isActive = false
                }
                layoutIfNeeded()
            }
        }
    }
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Theme.DARK_GRAY
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.numberOfLines = 2
        
        return label
    }()
    
    var actionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPSemiBoldH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLUE
        label.textAlignment = .right
        
        return label
    }()
    
    var mainCenterAnchor: NSLayoutConstraint!
    var subRightAnchor: NSLayoutConstraint!
    var subActionRightAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        addSubview(iconButton)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(actionLabel)
        
        iconButton.anchor(top: nil, left: leftAnchor, bottom: nil, right:  nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        mainCenterAnchor = mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            mainCenterAnchor.isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: iconButton.centerYAnchor, constant: 4).isActive = true
        subLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        subRightAnchor = subLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
            subRightAnchor.isActive = true
        subActionRightAnchor = subLabel.rightAnchor.constraint(equalTo: actionLabel.leftAnchor, constant: -20)
            subActionRightAnchor.isActive = false
        subLabel.sizeToFit()
        
        actionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        actionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        actionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        actionLabel.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
