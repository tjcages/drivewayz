//
//  PictureAlertView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/28/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PictureAlertView: UIViewController {

    var delegate: HandleHostPictures?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldPan: Bool = true

    var newOptions: [String] = ["Highlight space", "Cancel"]
    var oldOptions: [String] = ["Delete"]
    var options: [String] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight + cancelBottomHeight * 2))
        
        return view
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
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
    
    let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.BLACK
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        view.alpha = 0
        
        return view
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(minimizeImage), for: .touchUpInside)
//        button.alpha = 0
        
        return button
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Drag the corners of the highlighted region over the spot"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm Image", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.BLACK
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.alpha = 0
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .center
        label.text = "Use this to mark the boundaries of where drivers can park."
        label.alpha = 0
        label.numberOfLines = 2
        
        return label
    }()
    
    var dotsView: PictureHighlightView = {
        let controller = PictureHighlightView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dimView.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    var profitsBottomAnchor: NSLayoutConstraint!
    var gradientTopAnchor: NSLayoutConstraint!
    var imageBottomAnchor: NSLayoutConstraint!
    var imageWidthAnchor: NSLayoutConstraint!
    
    var bottomTopAnchor: NSLayoutConstraint!
    var bottomNormalAnchor: NSLayoutConstraint!
    var bottomBottomAnchor: NSLayoutConstraint!
    var bottomWidthAnchor: NSLayoutConstraint!
    var bottomHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(dimView)
        view.addSubview(bottomContainer)
        view.addSubview(optionsTableView)
        
        optionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        optionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        optionsTableView.heightAnchor.constraint(equalToConstant: CGFloat(options.count * 60)).isActive = true
        profitsBottomAnchor = optionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight)
            profitsBottomAnchor.isActive = true
        
        bottomContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomNormalAnchor = bottomContainer.bottomAnchor.constraint(equalTo: optionsTableView.bottomAnchor)
            bottomNormalAnchor.isActive = true
        bottomWidthAnchor = bottomContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16)
            bottomWidthAnchor.isActive = true
        bottomHeightAnchor = bottomContainer.heightAnchor.constraint(equalToConstant: CGFloat(options.count * 60))
            bottomHeightAnchor.isActive = true
        bottomBottomAnchor = bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            bottomBottomAnchor.isActive = false

        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageWidthAnchor = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16)
            imageWidthAnchor.isActive = true
        imageBottomAnchor = imageView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -16)
            imageBottomAnchor.isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.225).isActive = true
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(gradientContainer)
        gradientContainer.addSubview(exitButton)
        gradientContainer.addSubview(mainLabel)
        
        gradientContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gradientContainer.heightAnchor.constraint(equalToConstant: gradientHeight).isActive = true
        
        exitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 48).isActive = true
        }
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        bottomContainer.addSubview(mainButton)
        bottomContainer.addSubview(informationLabel)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 16, paddingRight: 20, width: 0, height: 56)
        
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        informationLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -16).isActive = true
        informationLabel.sizeToFit()
        bottomTopAnchor = bottomContainer.topAnchor.constraint(equalTo: informationLabel.topAnchor, constant: -20)
            bottomTopAnchor.isActive = false
        
        imageView.addSubview(dotsView.view)
        dotsView.view.anchor(top: imageView.topAnchor, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func mainButtonPressed() {
        dotsView.takeScreenshot()
        let image = imageView.takeScreenshot()
        dismiss(animated: true) {
            self.delegate?.saveHighlightedScreenshot(image: image)
        }
    }
    
    func expandImage() {
        shouldPan = false
        imageBottomAnchor.constant = 0
        imageWidthAnchor.constant = 0
        bottomWidthAnchor.constant = 0
        bottomHeightAnchor.isActive = false
        bottomNormalAnchor.isActive = false
        bottomBottomAnchor.isActive = true
        bottomTopAnchor.isActive = true
        UIView.animate(withDuration: animationIn, animations: {
            self.view.backgroundColor = Theme.BLACK
            self.pullButton.alpha = 0
            self.optionsTableView.alpha = 0
            self.bottomContainer.layer.cornerRadius = 0
            self.imageView.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn, animations: {
                self.mainButton.alpha = 1
                self.informationLabel.alpha = 1
                self.gradientContainer.alpha = 1
            }) { (success) in
                self.dotsView.startPan()
                UIView.animate(withDuration: animationIn) {
                    self.dotsView.view.alpha = 1
                }
            }
        }
    }
    
    @objc func minimizeImage() {
        shouldPan = true
        UIView.animate(withDuration: animationIn, animations: {
            self.dotsView.view.alpha = 0
            self.mainButton.alpha = 0
            self.informationLabel.alpha = 0
            self.gradientContainer.alpha = 0
        }) { (success) in
            self.imageBottomAnchor.constant = -16
            self.imageWidthAnchor.constant = -16
            self.bottomWidthAnchor.constant = -16
            self.bottomHeightAnchor.isActive = true
            self.bottomNormalAnchor.isActive = true
            self.bottomBottomAnchor.isActive = false
            self.bottomTopAnchor.isActive = false
            UIView.animate(withDuration: animationIn, animations: {
                self.view.backgroundColor = .clear
                self.pullButton.alpha = 1
                self.optionsTableView.alpha = 1
                self.bottomContainer.layer.cornerRadius = 8
                self.imageView.layer.cornerRadius = 8
                self.view.layoutIfNeeded()
            }) { (success) in
                //
            }
        }
    }
    
    @objc func viewPanned(sender: UIPanGestureRecognizer) {
        if shouldPan {
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
                    self.dismissView()
                }
            } else if state == .ended {
                let difference = abs(self.profitsBottomAnchor.constant) + self.bottomAnchor
                if difference >= 160 {
                    self.dismissView()
                } else {
                    self.profitsBottomAnchor.constant = self.bottomAnchor
                    UIView.animate(withDuration: animationOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    @objc func dismissView() {
        if shouldPan {
            delegate?.removeDim()
            dismiss(animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension PictureAlertView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.backgroundColor = .clear

        cell.textLabel?.font = Fonts.SSPRegularH4
        cell.textLabel?.textAlignment = .center
        if indexPath.row == (options.count - 1) {
            cell.textLabel?.textColor = Theme.SALMON
        } else {
            cell.textLabel?.textColor = Theme.BLACK
        }
        
        if options.count > indexPath.row {
            cell.textLabel?.text = options[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath)
        if let text = cell?.textLabel?.text {
            if text == "Highlight space" {
                expandImage()
            } else if text == "Delete" {
                delegate?.deleteImage()
                dismissView() 
            } else {
                dismissView()
            }
        }
    }
    
}
