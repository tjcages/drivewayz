//
//  ReviewViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 3/5/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    var delegate: HandleCurrent?
    lazy var bottomAnchor: CGFloat = cancelBottomHeight
    var shouldDismiss: Bool = true
    
    var cellHeight: CGFloat = 53
    var extraPadding: CGFloat = 32
    
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                shouldDismiss = false
                panBottomAnchor.isActive = false
//                scrollView.isScrollEnabled = true
                expandController()
            } else {
                shouldDismiss = true
                panBottomAnchor.isActive = true
//                scrollView.isScrollEnabled = false
                minimizeController()
            }
        }
    }
    
    var isAddingNote: Bool = false {
        didSet {
            if isAddingNote {
                expandAddNote()
            } else {
                minimizeAddNote()
            }
        }
    }
    
    var defaultPositiveReasons: [String] = ["Useful description", "Nice penis", "Butt plugs?", "Easy to find", "Short walking distance"]
    var defaultNegativeReasons: [String] = ["Nice penis", "Butt plugs?", "Poop my panties", "Short"]
    
    var reasons: [String] = [] {
        didSet {
            prepareReasons()
        }
    }
    var reasonSplit: [Int: [String]] = [:]
    var selectedReasons: [String] = []

    lazy var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 4
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var lightContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return view
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        var attrs = [
        NSAttributedString.Key.font : Fonts.SSPRegularH2,
        NSAttributedString.Key.foregroundColor : Theme.WHITE,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        var attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:"Skip", attributes: attrs)
        attributedString.append(buttonTitleStr)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        button.layer.cornerRadius = 20
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH1
        label.text = "Feedback"
        
        return label
    }()
    
    var titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        
        return view
    }()
    
    var pullButton: UIButton = {
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
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH25
        label.text = "How did we do?"
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        label.text = "Did we help alleviate parking hassles or not so much?"
        label.numberOfLines = 2
        
        return label
    }()
    
    var thumbsDownButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 48
        let image = UIImage(named: "thumbsdown_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isSelected = false
        button.addTarget(self, action: #selector(thumbButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var thumbsUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.LINE_GRAY
        button.layer.cornerRadius = 48
        let image = UIImage(named: "thumbsup_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.isSelected = false
        button.addTarget(self, action: #selector(thumbButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var layout: LeftAlignedCollectionViewFlowLayout = {
        let layout = LeftAlignedCollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        return layout
    }()
    
    lazy var reasonPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = .clear
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(ReviewReasonCell.self, forCellWithReuseIdentifier: "identifier")
        picker.isScrollEnabled = false
        picker.alpha = 0
        
        return picker
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.alpha = 0
        
        return view
    }()
    
    var addNoteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add a note", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH4
        button.alpha = 0
        button.addTarget(self, action: #selector(addANotePressed), for: .touchUpInside)
        
        return button
    }()
    
    var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.font = Fonts.SSPRegularH3
        view.textColor = Theme.BLACK
        view.keyboardAppearance = .dark
        view.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        view.delegate = self
        view.alpha = 0
        
        return view
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.text = "Add a note"
        label.alpha = 0
        
        return label
    }()
    
    var addExitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.setTitle("Done", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 2
        button.alpha = 0
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reasonPicker.delegate = self
        reasonPicker.dataSource = self
        textView.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(sender:)))
        pan.cancelsTouchesInView = false
        view.addGestureRecognizer(pan)
        
        setupViews()
        setupInformation()
        setupExpanded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.skipButton.alpha = 1
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        skipButton.alpha = 0
    }
    
    var panBottomAnchor: NSLayoutConstraint!
    var reasonHeightAnchor: NSLayoutConstraint!
    var reasonTopAnchor: NSLayoutConstraint!
    
    var thumbsDownRightAnchor: NSLayoutConstraint!
    var thumbsUpLeftAnchor: NSLayoutConstraint!
    var thumbsTopAnchor: NSLayoutConstraint!
    var thumbsDownLeftAnchor: NSLayoutConstraint!
    var thumbsUpSmallAnchor: NSLayoutConstraint!
    
    var textTopAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        blurView.addSubview(container)
        container.addSubview(lightContainer)
        
        view.addSubview(pullButton)
        pullButton.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -16).isActive = true
        pullButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        pullButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(skipButton)
        skipButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        skipButton.sizeToFit()
        
        lightContainer.addSubview(thumbsDownButton)
        lightContainer.addSubview(thumbsUpButton)
        lightContainer.addSubview(reasonPicker)
        view.addSubview(line)
        lightContainer.addSubview(addNoteButton)
        lightContainer.addSubview(textView)
        lightContainer.addSubview(informationLabel)
        view.addSubview(addExitButton)
        
        thumbsTopAnchor = thumbsDownButton.topAnchor.constraint(equalTo: lightContainer.topAnchor, constant: 32)
            thumbsTopAnchor.isActive = true
        thumbsDownRightAnchor = thumbsDownButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -16)
            thumbsDownRightAnchor.isActive = true
        thumbsDownButton.widthAnchor.constraint(equalTo: thumbsDownButton.heightAnchor).isActive = true
        thumbsDownButton.heightAnchor.constraint(equalToConstant: 96).isActive = true
        thumbsDownLeftAnchor = thumbsDownButton.leftAnchor.constraint(equalTo: container.leftAnchor)
            thumbsDownLeftAnchor.isActive = false
        
        thumbsUpButton.centerYAnchor.constraint(equalTo: thumbsDownButton.centerYAnchor).isActive = true
        thumbsUpLeftAnchor = thumbsUpButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 16)
            thumbsUpLeftAnchor.isActive = true
        thumbsUpButton.widthAnchor.constraint(equalTo: thumbsDownButton.heightAnchor).isActive = true
        thumbsUpButton.heightAnchor.constraint(equalToConstant: 96).isActive = true
        thumbsUpSmallAnchor = thumbsUpButton.leftAnchor.constraint(equalTo: thumbsDownButton.rightAnchor, constant: -20)
            thumbsUpSmallAnchor.isActive = false
        
        reasonPicker.anchor(top: nil, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        reasonTopAnchor = reasonPicker.topAnchor.constraint(equalTo: lightContainer.topAnchor, constant: 120)
            reasonTopAnchor.isActive = true
        reasonHeightAnchor = reasonPicker.heightAnchor.constraint(equalToConstant: 45)
            reasonHeightAnchor.isActive = true
        
        line.anchor(top: reasonPicker.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 1)
        
        addNoteButton.anchor(top: line.bottomAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        textTopAnchor = textView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20)
            textTopAnchor.priority = UILayoutPriority.defaultLow
            textTopAnchor.isActive = true
        textView.anchor(top: nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
        
    }
    
    var containerTopAnchor: NSLayoutConstraint!
    var containerLeftAnchor: NSLayoutConstraint!
    var containerRightAnchor: NSLayoutConstraint!
    var containerExpandedTopAnchor: NSLayoutConstraint!
    var containerHeightAnchor: NSLayoutConstraint!
    var containerBottomAnchor: NSLayoutConstraint!
    
    var lightContainerHeightAnchor: NSLayoutConstraint!
    var subLabelBottomAnchor: NSLayoutConstraint!
    
    func setupInformation() {
        
        container.addSubview(subLabel)
        container.addSubview(mainLabel)
        
        subLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        subLabelBottomAnchor = subLabel.bottomAnchor.constraint(equalTo: lightContainer.topAnchor, constant: -32)
            subLabelBottomAnchor.isActive = true
        subLabel.sizeToFit()
        
        mainLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -16).isActive = true
        mainLabel.sizeToFit()
        
        lightContainer.anchor(top: nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        lightContainerHeightAnchor = lightContainer.heightAnchor.constraint(equalToConstant: 160)
            lightContainerHeightAnchor.isActive = true
        
        addExitButton.centerYAnchor.constraint(equalTo: subLabel.centerYAnchor).isActive = true
        addExitButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        addExitButton.widthAnchor.constraint(equalTo: addExitButton.heightAnchor).isActive = true
        addExitButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    var titleTopAnchor: NSLayoutConstraint!
    var titleLeftAnchor: NSLayoutConstraint!
    
    var mainTopAnchor: NSLayoutConstraint!
    var mainBottomAnchor: NSLayoutConstraint!
    var mainKeyboardAnchor: NSLayoutConstraint!
    
    var informationTopAnchor: NSLayoutConstraint!
    
    func setupExpanded() {
        
        view.addSubview(titleContainer)
        titleContainer.addSubview(backButton)
        titleContainer.addSubview(titleLabel)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        titleLeftAnchor = titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
            titleLeftAnchor.isActive = true
        titleLabel.sizeToFit()
        switch device {
        case .iphoneX:
            titleTopAnchor = titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 32)
                titleTopAnchor.isActive = true
        case .iphone8:
            titleTopAnchor = titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20)
                titleTopAnchor.isActive = true
        }
        
        titleContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: backButton.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 0, height: 0)
        
        informationLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -8).isActive = true
        informationTopAnchor = informationLabel.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 20)
            informationTopAnchor.isActive = false
        informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        informationLabel.sizeToFit()
        
        view.addSubview(mainButton)
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainTopAnchor = mainButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
            mainTopAnchor.isActive = true
        mainBottomAnchor = mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: cancelBottomHeight)
            mainBottomAnchor.isActive = false
        mainKeyboardAnchor = mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            mainKeyboardAnchor.isActive = false
        
        panBottomAnchor = container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomAnchor)
            panBottomAnchor.isActive = true
        containerLeftAnchor = container.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
            containerLeftAnchor.isActive = true
        containerRightAnchor = container.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
            containerRightAnchor.isActive = true
        containerTopAnchor = container.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -20)
            containerTopAnchor.isActive = true
        containerHeightAnchor = container.heightAnchor.constraint(equalToConstant: 444)
            containerHeightAnchor.isActive = false
        containerBottomAnchor = container.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -20)
            containerBottomAnchor.isActive = false
        switch device {
        case .iphoneX:
            containerExpandedTopAnchor = container.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 200)
                containerExpandedTopAnchor.isActive = false
        case .iphone8:
            containerExpandedTopAnchor = container.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 150)
                containerExpandedTopAnchor.isActive = false
        }
        
    }
    
    @objc func mainButtonPressed() {
        dismissView()
    }
    
    func expandController() {
        UIView.animateKeyframes(withDuration: animationOut * 2, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.lightContainerHeightAnchor.constant = 354
                self.containerTopAnchor.isActive = false
                self.containerLeftAnchor.constant = 20
                self.containerRightAnchor.constant = -20
                self.containerExpandedTopAnchor.isActive = true
                self.containerHeightAnchor.isActive = true
                self.subLabelBottomAnchor.constant = -20
                
                self.mainLabel.text = nil
                self.blurView.backgroundColor = Theme.WHITE
                self.pullButton.alpha = 0
                self.thumbsDownButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.thumbsUpButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.thumbsDownRightAnchor.constant = 0
                self.thumbsUpLeftAnchor.constant = 0
                self.thumbsTopAnchor.constant = 20
                
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.5) {
                self.mainTopAnchor.isActive = false
                self.mainBottomAnchor.isActive = true
                self.titleContainer.alpha = 1
                self.mainButton.alpha = 1
                self.reasonPicker.alpha = 1
                self.line.alpha = 1
                self.addNoteButton.alpha = 1
                self.subLabel.text = "Help us improve by telling us what you liked most"
                
                self.view.layoutIfNeeded()
            }
        }) { (success) in
            //
        }
    }
    
    func minimizeController() {
        UIView.animateKeyframes(withDuration: animationIn * 2, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.mainTopAnchor.isActive = true
                self.mainBottomAnchor.isActive = false
                self.containerTopAnchor.isActive = true
                self.containerLeftAnchor.constant = 10
                self.containerRightAnchor.constant = -10
                self.containerExpandedTopAnchor.isActive = false
                self.subLabelBottomAnchor.constant = -20
                
                self.titleContainer.alpha = 0
                self.mainButton.alpha = 0
                self.reasonPicker.alpha = 0
                self.line.alpha = 0
                self.addNoteButton.alpha = 0
                self.subLabel.text = "Did we help alleviate parking hassles or not so much?"
                
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
                self.containerHeightAnchor.isActive = false
                self.lightContainerHeightAnchor.constant = 160
                
                self.mainLabel.text = "How did we do?"
                self.blurView.backgroundColor = .clear
                self.pullButton.alpha = 1
                self.thumbsDownButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.thumbsUpButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.thumbsDownRightAnchor.constant = -16
                self.thumbsUpLeftAnchor.constant = 16
                self.thumbsTopAnchor.constant = 32
                
                self.view.layoutIfNeeded()
            }
        }) { (success) in
            //
        }
    }
    
    @objc func thumbButtonPressed(sender: UIButton) {
        if !isExpanded { isExpanded = true }
        if isAddingNote { isAddingNote = false }
        
        sender.isSelected = true
        if sender == thumbsUpButton {
            thumbsDownButton.isSelected = false
        } else {
            thumbsUpButton.isSelected = false
        }
        
        if self.thumbsUpButton.isSelected {
            self.reasons = self.defaultPositiveReasons
            if let text = self.subLabel.text, text.contains("Help us improve") {
                self.subLabel.text = "Help us improve by telling us what you liked most"
            }
        } else {
            self.reasons = self.defaultNegativeReasons
            if let text = self.subLabel.text, text.contains("Help us improve") {
                self.subLabel.text = "Help us improve by telling us what problems you experienced"
            }
        }
        
        animateThumbs()
    }
    
    func animateThumbs() {
        let thumbs = [thumbsUpButton, thumbsDownButton]
        UIView.animateOut(withDuration: animationIn, animations: {
            for thumb in thumbs {
                if thumb.isSelected {
                    thumb.backgroundColor = Theme.BLACK
                    thumb.tintColor = Theme.WHITE
                } else {
                    thumb.backgroundColor = Theme.LINE_GRAY
                    thumb.tintColor = Theme.BLACK
                }
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            //
        }
    }
    
    @objc func addANotePressed() {
        isAddingNote = true
    }
    
    func expandAddNote() {
        UIView.transition(with: reasonPicker, duration: 0.5, options: .showHideTransitionViews, animations: {
            self.reasons = self.selectedReasons
            self.reasonPicker.reloadData()
        }, completion: nil)
        
        subLabel.text = "Add a note"
        thumbsDownRightAnchor.isActive = false
        thumbsUpLeftAnchor.isActive = false
        thumbsDownLeftAnchor.isActive = true
        thumbsUpSmallAnchor.isActive = true
        thumbsTopAnchor.constant = 0
        reasonTopAnchor.constant = 90
        lightContainerHeightAnchor.constant = 376
        UIView.animateOut(withDuration: animationOut, animations: {
            self.thumbsDownButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.thumbsUpButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.addNoteButton.alpha = 0
            self.addExitButton.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animateOut(withDuration: animationOut, animations: {
                self.textView.alpha = 1
            }) { (success) in
                self.textView.becomeFirstResponder()
            }
        }
    }
    
    func minimizeAddNote() {
        UIView.transition(with: reasonPicker, duration: 0.5, options: .showHideTransitionViews, animations: {
            self.reasons = self.defaultPositiveReasons
            self.reasonPicker.reloadData()
        }, completion: nil)
        
        subLabel.text = "Help us improve by telling us what you liked most"
        lightContainerHeightAnchor.constant = 354
        UIView.animateOut(withDuration: animationOut, animations: {
            self.textView.alpha = 0
            self.addExitButton.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.thumbsDownRightAnchor.isActive = true
            self.thumbsUpLeftAnchor.isActive = true
            self.thumbsDownLeftAnchor.isActive = false
            self.thumbsUpSmallAnchor.isActive = false
            self.thumbsTopAnchor.constant = 20
            self.reasonTopAnchor.constant = 120
            UIView.animateOut(withDuration: animationOut, animations: {
                self.thumbsDownButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.thumbsUpButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.addNoteButton.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func backButtonPressed() {
        if isAddingNote {
            view.endEditing(true)
            isAddingNote = false
        } else {
            isExpanded = false
        }
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
        delegate?.restartBookingProcess()
        UIView.animateOut(withDuration: animationOut, animations: {
            tabDimmingView.alpha = 0
        }, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}

extension ReviewViewController: UITextViewDelegate {
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let height = keyboardViewEndFrame.height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            mainBottomAnchor.isActive = true
            mainKeyboardAnchor.isActive = false
        } else {
            mainBottomAnchor.isActive = false
            mainKeyboardAnchor.isActive = true
            mainKeyboardAnchor.constant = -height - 16
        }
        UIView.animate(withDuration: animationOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        containerLeftAnchor.constant = 0
        containerRightAnchor.constant = 0
        titleTopAnchor.constant = -40
        titleLeftAnchor.constant = 64
        containerHeightAnchor.isActive = false
        containerBottomAnchor.isActive = true
        informationTopAnchor.isActive = true
        switch device {
        case .iphoneX:
            containerExpandedTopAnchor.constant = -reasonHeightAnchor.constant - 20
        case .iphone8:
            containerExpandedTopAnchor.constant = -reasonHeightAnchor.constant - 50
        }
        UIView.animateOut(withDuration: animationOut, animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.container.layer.shadowOpacity = 0.0
            self.titleContainer.backgroundColor = Theme.BLACK
            self.titleLabel.textColor = Theme.WHITE
            self.informationLabel.alpha = 1
            self.reasonPicker.alpha = 0
            self.line.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            lightContentStatusBar()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        containerLeftAnchor.constant = 20
        containerRightAnchor.constant = -20
        titleLeftAnchor.constant = 20
        containerHeightAnchor.isActive = true
        containerBottomAnchor.isActive = false
        informationTopAnchor.isActive = false
        switch device {
        case .iphoneX:
            containerExpandedTopAnchor.constant = 200
            titleTopAnchor.constant = 32
        case .iphone8:
            containerExpandedTopAnchor.constant = 150
            titleTopAnchor.constant = 20
        }
        UIView.animateOut(withDuration: animationOut, animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.container.layer.shadowOpacity = 0.2
            self.titleContainer.backgroundColor = Theme.WHITE
            self.titleLabel.textColor = Theme.BLACK
            self.informationLabel.alpha = 0
            self.reasonPicker.alpha = 1
            self.line.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            defaultContentStatusBar()
        }
    }
    
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func prepareReasons() {
        selectedReasons.removeAll()
        reasonSplit.removeAll()
        let maxWidth = phoneWidth - 80
        var section: Int = 0
        var currentWidth: CGFloat = 0
        var reasonArray: [String] = []
        
        for reason in reasons {
            var width = reason.width(withConstrainedHeight: 45, font: Fonts.SSPRegularH4) + extraPadding
            if isAddingNote { width = width * 0.8 }
            currentWidth += width
            if currentWidth > maxWidth {
                section += 1
                currentWidth = width
                reasonArray = []
            }
            reasonArray.append(reason)
            reasonSplit[section] = reasonArray
        }
        reasonPicker.reloadData()
        reasonHeightAnchor.constant = CGFloat(reasonSplit.capacity) * cellHeight
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return reasonSplit.capacity
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let reasonSection = reasonSplit[section] {
            return reasonSection.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let reasonSection = reasonSplit[indexPath.section] {
            let string = reasonSection[indexPath.row]
            let width = string.width(withConstrainedHeight: cellHeight, font: Fonts.SSPRegularH4) + extraPadding
            return CGSize(width: width, height: cellHeight)
        }
        return CGSize(width: 170, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! ReviewReasonCell

        if let reasonSection = reasonSplit[indexPath.section] {
            let string = reasonSection[indexPath.row]
            cell.mainLabel.text = string
            cell.reasonSelected = false
            
            if isAddingNote {
                cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } else {
                cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ReviewReasonCell
        
        if let string = cell.mainLabel.text {
            if selectedReasons.contains(string) {
                cell.reasonSelected = false
                selectedReasons = selectedReasons.filter { $0 != string }
            } else {
                cell.reasonSelected = true
                selectedReasons.append(string)
            }
        }
    }
    
}

class ReviewReasonCell: UICollectionViewCell {
    
    var reasonSelected: Bool = false {
        didSet {
            animateTaps()
        }
    }
    
    var container: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.STANDARD_GRAY
        view.layer.cornerRadius = 2
        view.isSelected = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setAnchorPoint(.zero)
        
        setupViews()
    }
    
    func setupViews() {

        addSubview(container)
        addSubview(mainLabel)
        
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
        mainLabel.sizeToFit()
        
    }
    
    func animateTaps() {
        UIView.animateOut(withDuration: animationIn, animations: {
            if self.reasonSelected {
                self.container.backgroundColor = Theme.BLACK
                self.mainLabel.textColor = Theme.WHITE
            } else {
                self.container.backgroundColor = Theme.LINE_GRAY
                self.mainLabel.textColor = Theme.BLACK
            }
        }) { (success) in
            //
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
