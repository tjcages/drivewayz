//
//  NewVehicleViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

var keyboardHeight: CGFloat = 0.0

class NewVehicleView: UIViewController {
    
    var delegate: updateVehicleMethod?
    var vehicleMethods: [Vehicles] = []
    var labelTitles: [String] = ["Car make", "Car model", "Year", "License plate"]
    var enteredValues: [String] = ["", "", "", ""] {
        didSet {
            if !self.enteredValues.contains("") {
                changeButtonEnabled(enabled: true)
            } else {
                changeButtonEnabled(enabled: false)
            }
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = "New vehicle"
        controller.setBackButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return controller
    }()
    
    var optionsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(NewVehicleCell.self, forCellReuseIdentifier: "cellId")
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.backgroundColor = .red
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.isUserInteractionEnabled = false
        button.setTitle("Save vehicle", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTable.delegate = self
        optionsTable.dataSource = self
        
        view.backgroundColor = Theme.WHITE

        setupContainer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = optionsTable.cellForRow(at: indexPath) as? NewVehicleCell {
            cell.mainTextView.lineTextView?.becomeFirstResponder()
        }
    }

    var mainButtonBottomAnchor: NSLayoutConstraint!
    
    func setupContainer() {
        
        view.addSubview(gradientController.view)
        gradientController.scrollView.addSubview(optionsTable)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        optionsTable.anchor(top: gradientController.scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 400)
        
        view.addSubview(buttonView)
        view.addSubview(mainButton)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainButtonBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48)
            mainButtonBottomAnchor.isActive = true
        
        buttonView.anchor(top: mainButton.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func changeButtonEnabled(enabled: Bool) {
        if enabled {
            mainButton.backgroundColor = Theme.DARK_GRAY
            mainButton.setTitleColor(Theme.WHITE, for: .normal)
            mainButton.isUserInteractionEnabled = true
        }
        else {
            mainButton.backgroundColor = lineColor
            mainButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
            mainButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func saveButtonPressed() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        changeButtonEnabled(enabled: false)
        gradientController.loadingLine.alpha = 1
        gradientController.loadingLine.startAnimating()
        
        // Use the token in the next step
        let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles")
        let timestamp = Date().timeIntervalSince1970
        
        var data = ["make": enteredValues[0], "model": enteredValues[1], "year": enteredValues[2], "license": enteredValues[3], "timestamp": timestamp, "default": true] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = db.addDocument(data: data, completion: { (err) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            if let documentId = ref?.documentID {
                data["fingerprint"] = documentId
                let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles").document(documentId)
                db.setData(data)
                
                let ref = Database.database().reference().child("users").child(userId).child("selectedVehicle").child("vehicles")
                ref.updateChildValues(data)
            }
            
            // Set all other vehicles to false for default
            for method in self.vehicleMethods {
                if let fingerprint = method.fingerprint, var dictionary = method.dictionary {
                    dictionary["default"] = false
                    let db = Firestore.firestore().collection("stripe_customers").document(userId).collection("vehicles").document(fingerprint)
                    db.setData(dictionary)
                }
            }

            self.changeButtonEnabled(enabled: true)
            self.gradientController.loadingLine.alpha = 0
            self.gradientController.loadingLine.endAnimating()
            self.backButtonPressed()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension NewVehicleView: VehicleCellDelegate {
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(tag: Int, dismiss: Bool) {
        let indexPath = IndexPath(row: tag, section: 0)
        guard let cell = optionsTable.cellForRow(at: indexPath) as? NewVehicleCell else { return }
        if dismiss {
            gradientController.scrollView.setContentOffset(.zero, animated: true)
            mainButtonBottomAnchor.constant = -48
            UIView.animate(withDuration: animationOut) {
                self.view.layoutIfNeeded()
            }
            return
        } else {
            gradientController.scrollView.scrollToView(view: cell.mainLabel, animated: true, offset: 16)
            if tag == (labelTitles.count - 1) {
                mainButtonBottomAnchor.constant = -keyboardHeight - 16
            } else {
                mainButtonBottomAnchor.constant = -48
            }
            UIView.animate(withDuration: animationOut) {
                self.view.layoutIfNeeded()
            }
            return
        }
    }
    
}

// List all steps
extension NewVehicleView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NewVehicleCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.tag = indexPath.row
        
        if indexPath.row < labelTitles.count {
            cell.mainLabel.text = labelTitles[indexPath.row]
            
            if indexPath.row == 2 {
                cell.mainTextView.textViewAutcapitalizationType = .sentences
                cell.mainTextView.textViewKeyboardType = .numberPad
            } else if indexPath.row == 3 {
                cell.mainTextView.textViewAutcapitalizationType = .allCharacters
                cell.mainTextView.textViewKeyboardType = .default
            } else {
                cell.mainTextView.textViewAutcapitalizationType = .sentences
                cell.mainTextView.textViewKeyboardType = .default
            }
        }
        
        cell.textChanged {[weak tableView] (_) in
            DispatchQueue.main.async {
                tableView?.beginUpdates()
                if let value = cell.mainTextView.lineTextView?.text {
                    self.enteredValues[cell.tag] = value
                }
                tableView?.endUpdates()
            }
        }
        
        return cell
    }

}

// Use a class protocol for delegates so weak properties can be used
protocol VehicleCellDelegate: class {
    func adjustForKeyboard(tag: Int, dismiss: Bool)
}

class NewVehicleCell: UITableViewCell {
    
    weak var delegate: VehicleCellDelegate?
    var textChanged: ((String) -> Void)?
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.text = "Test"
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var mainTextView: LineInputAccessoryView = {
        let view = LineInputAccessoryView()
        view.textViewFont = Fonts.SSPSemiBoldH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineUnselectedColor = Theme.OFF_WHITE
        view.lineTextView?.tintColor = Theme.BLUE
        view.backgroundColor = Theme.OFF_WHITE
        view.textViewKeyboardType = .default
        view.lineTextView?.placeholderLabel.alpha = 0
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainTextView.lineTextView?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setupViews()
    }
    
    var messageTopAnchor: NSLayoutConstraint!
    var messageLeftAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(mainLabel)
        addSubview(mainTextView)
        
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        mainTextView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        mainTextView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewVehicleCell: UITextViewDelegate {
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.adjustForKeyboard(tag: tag, dismiss: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.adjustForKeyboard(tag: tag, dismiss: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboard = keyboardSize.height
            keyboardHeight = keyboard
        }
    }
    
}
