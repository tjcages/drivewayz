//
//  CustomNumbersView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/25/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class CustomNumbersView: UIViewController {

    var delegate: HandleListingDetails?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    var maxSpots: Int = 0 {
        didSet {
            while totalSpots > maxSpots {
                totalSpots -= 1
                enteredValues[(enteredValues.count - 1)] = nil
            }
        }
    }
    
    var totalSpots: Int = 1 {
        didSet {
            optionsTableView.reloadData()
            
            let index = IndexPath(row: self.totalSpots - 1, section: 0)
            self.optionsTableView.selectRow(at: index, animated: true, scrollPosition: .bottom)
            self.tableView(self.optionsTableView, didSelectRowAt: index)
            
            mainButton.setTitle("Confirm Spot Numbers (\(totalSpots))", for: .normal)
            
            if totalSpots > 3 {
                shouldDismiss = false
            }
        }
    }

    var enteredValues: [Int: Int] = [:]
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        
        return view
    }()
    
    lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.alpha = 0
        
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
        
        return button
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Confirm Spot Numbers (1)", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        label.text = "Custom numbers"
        
        return label
    }()

    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CustomNumberCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        view.separatorStyle = .none
        
        return view
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.alpha = 0
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.setTitle("Back", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.message = "Can only set custom numbers for the total number of spots."
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.verticalTriangle()
        view.rightTriangle()
        view.label.font = Fonts.SSPRegularH4
        view.alpha = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dismissKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delayWithSeconds(animationIn/2) {
            let index = IndexPath(row: self.totalSpots - 1, section: 0)
            self.optionsTableView.selectRow(at: index, animated: true, scrollPosition: .bottom)
            self.tableView(self.optionsTableView, didSelectRowAt: index)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: animationIn) {
            self.statusView.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.statusView.alpha = 0
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    var tableViewHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(container)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        container.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        cancelButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        profitsBottomAnchor = cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight)
            profitsBottomAnchor.isActive = true
        
        view.addSubview(mainButton)
        view.addSubview(nextButton)
        view.addSubview(backButton)
        
        view.addSubview(optionsTableView)
        view.addSubview(mainLabel)
        
        mainButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        nextButton.anchor(top: mainButton.topAnchor, left: backButton.rightAnchor, bottom: mainButton.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        backButton.anchor(top: mainButton.topAnchor, left: view.leftAnchor, bottom: mainButton.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 120, height: 0)
        
        optionsTableView.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, width: 0, height: 0)
        tableViewHeight = optionsTableView.heightAnchor.constraint(equalToConstant: 56)
            tableViewHeight.isActive = true
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: optionsTableView.topAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20).isActive = true
        
        view.addSubview(statusView)
        statusView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(bubbleArrow)
        bubbleArrow.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8).isActive = true
        bubbleArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bubbleArrow.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        view.layoutIfNeeded()
    }
    
    @objc func mainButtonPressed() {
        var values: [Int] = enteredValues.values.sorted()
        while values.count > totalSpots {
            values = values.dropLast()
        }
        delegate?.saveCutomNumbers(numbers: values)
        dismissView()
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: self.view).y
        if state == .changed {
            self.profitsBottomAnchor.constant = self.bottomAnchor + translation/1.5
            self.view.layoutIfNeeded()
            if translation >= 160 || translation <= -320 {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
                if self.shouldDismiss == true {
                    self.dismissView()
                }
            }
        } else if state == .ended {
            self.view.endEditing(true)
            let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
            if difference >= 160 {
                if self.shouldDismiss == true {
                    self.dismissView()
                    self.profitsBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            } else {
                self.profitsBottomAnchor.constant = self.bottomAnchor
                UIView.animate(withDuration: animationOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func nextButtonPressed() {
        bubbleArrow.alpha = 0
        if maxSpots >= (totalSpots + 1) {
            totalSpots += 1
        } else {
            UIView.animate(withDuration: animationIn, animations: {
                self.bubbleArrow.alpha = 1
            }) { (success) in
                delayWithSeconds(3) {
                    if self.bubbleArrow.alpha == 1 {
                        UIView.animate(withDuration: animationIn) {
                            self.bubbleArrow.alpha = 0
                        }
                    }
                }
            }
        }
    }
    
    @objc func backButtonPressed() {
        bubbleArrow.alpha = 0
        if totalSpots > 1 {
            totalSpots -= 1
        }
    }
    
    @objc func dismissView() {
        dismissKeyboard()
        delegate?.removeDim()
        delegate?.unselectViews()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        bubbleArrow.alpha = 0
        dismissKeyboard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension CustomNumbersView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = CGFloat(56 * totalSpots)
        view.layoutIfNeeded()
        
        return totalSpots
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomNumberCell
        cell.selectionStyle = .none
        
        cell.tag = indexPath.row + 1
        cell.removeRangeButton.tag = cell.tag
        cell.delegate = self
        cell.titleLabel.text = "Spot \(indexPath.row + 1)"
        cell.removeRangeButton.addTarget(self, action: #selector(removeValue(sender:)), for: .touchUpInside)
        
        if let value = enteredValues[cell.tag] {
            cell.mainTextView.text = String(value)
            let width = cell.mainTextView.text.width(withConstrainedHeight: 46, font: Fonts.SSPRegularH2)
            cell.textViewWidthAnchor.constant = width + 24
        }
        
        cell.textChanged {[weak tableView] (_) in
            DispatchQueue.main.async {
                tableView?.beginUpdates()
                if let text = cell.mainTextView.text, let value = Int(text) {
                    self.enteredValues[cell.tag] = value
                }
                tableView?.endUpdates()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bubbleArrow.alpha = 0
        let cell = tableView.cellForRow(at: indexPath) as! CustomNumberCell
        
        cell.mainTextView.becomeFirstResponder()
    }
    
}

extension CustomNumbersView: CustomNumbersCellDelegate {
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(tag: Int, dismiss: Bool) {
        if dismiss {
            profitsBottomAnchor.constant = self.bottomAnchor
            UIView.animate(withDuration: animationOut) {
                self.view.layoutIfNeeded()
            }
            return
        } else {
            profitsBottomAnchor.constant = -(keyboardHeight - 34)
            UIView.animate(withDuration: animationOut) {
                self.nextButton.alpha = 1
                self.backButton.alpha = 1
                self.mainButton.alpha = 0
                self.view.layoutIfNeeded()
            }
            return
        }
    }
    
    @objc func removeValue(sender: UIButton) {
        enteredValues[sender.tag] = nil
        for values in enteredValues {
            let key = values.key
            if key > sender.tag {
                enteredValues[key] = nil
                enteredValues[key - 1] = values.value
            }
        }
        backButtonPressed()
        if enteredValues.count == 0 {
            dismissView()
        }
    }
    
    @objc func dismissKeyboard() {
        delayWithSeconds(animationIn/2) {
            if self.profitsBottomAnchor.constant == self.bottomAnchor {
                UIView.animate(withDuration: animationOut) {
                    self.bubbleArrow.alpha = 0
                    self.nextButton.alpha = 0
                    self.backButton.alpha = 0
                    self.mainButton.alpha = 1
                }
            }
        }
    }
    
}

// Use a class protocol for delegates so weak properties can be used
protocol CustomNumbersCellDelegate: class {
    func adjustForKeyboard(tag: Int, dismiss: Bool)
    func dismissKeyboard()
}

class CustomNumberCell: UITableViewCell {
    
    weak var delegate: CustomNumbersCellDelegate?
    var textChanged: ((String) -> Void)?
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.PRUSSIAN_BLUE
        
        return view
    }()
    
    var mainTextView: UITextView = {
        let view = UITextView()
        view.textColor = Theme.DARK_GRAY
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = .clear
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        
        return view
    }()
    
    var textViewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    var removeRangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.layer.cornerRadius = 14
        button.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
        setupViews()
        createToolbar()
    }
    
    var textViewWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(mainTextView)
        addSubview(textViewLine)
        addSubview(removeRangeButton)
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.sizeToFit()
        
        mainTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        mainTextView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        textViewWidthAnchor = mainTextView.widthAnchor.constraint(equalToConstant: 32)
            textViewWidthAnchor.isActive = true
        
        textViewLine.anchor(top: nil, left: mainTextView.leftAnchor, bottom: mainTextView.bottomAnchor, right: mainTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        removeRangeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        removeRangeButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 28, height: 28)
        
    }
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.sizeToFit()
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        mainTextView.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        delegate?.dismissKeyboard()
        endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomNumberCell: UITextViewDelegate {

    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let width = textView.text.width(withConstrainedHeight: 46, font: Fonts.SSPRegularH2)
        textViewWidthAnchor.constant = width + 24
        textChanged?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
        textViewLine.backgroundColor = Theme.BLUE
        removeRangeButton.backgroundColor = Theme.WHITE
        delegate?.adjustForKeyboard(tag: tag, dismiss: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        backgroundColor = .clear
        textViewLine.backgroundColor = lineColor
        removeRangeButton.backgroundColor = lineColor
        delegate?.adjustForKeyboard(tag: tag, dismiss: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboard = keyboardSize.height
            keyboardHeight = keyboard
        }
    }
        
}

