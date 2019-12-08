//
//  SendBookingIssuesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/3/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class SendBookingIssuesViewController: UIViewController {
    
    var FAQString: String?
    var FAQ: FAQs? {
        didSet {
            if let faq = FAQ {
                if let mainInformation = faq.mainInformation {
                    titleLabel.alpha = 1
                    subtitleLabel.alpha = 1
                    for information in mainInformation {
                        if information == mainInformation.first {
                            subtitleLabel.text = information
                        } else {
                            guard let text = self.subtitleLabel.text else { return }
                            subtitleLabel.text = text + "\n\n" + information
                        }
                    }
                }
                if let contactSupport = faq.contactSupport {
                    supportButton.setTitle(contactSupport, for: .normal)
                    contactButton()
                } else {
                    noContactButton()
                }
                if let supportText = faq.supportText {
                    supportTextLabel.text = supportText
                    self.supportText()
                } else {
                    noSupportText()
                }
                openFeedback()
            }
        }
    }
    
    var userLiked: Bool = false {
        didSet {
            if userLiked == true {
                if userDisliked == true {
                    userDisliked = false
                }
                likeButton.tintColor = Theme.BLUE
                likeButton.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
                sendFeedbackToDatabase(like: true, add: true)
                expandAlert(title: "Thanks for your feedback!", color: Theme.BLUE)
            } else {
                likeButton.tintColor = Theme.DARK_GRAY
                likeButton.backgroundColor = lineColor
                sendFeedbackToDatabase(like: true, add: false)
            }
        }
    }
    var userDisliked: Bool = false {
        didSet {
            if userDisliked == true {
                if userLiked == true {
                    userLiked = false
                }
                dislikeButton.tintColor = Theme.BLUE
                dislikeButton.backgroundColor = Theme.BLUE.withAlphaComponent(0.2)
                sendFeedbackToDatabase(like: false, add: true)
                expandAlert(title: "Thanks for your feedback!", color: Theme.BLUE)
                openDislikeFeeback()
            } else {
                dislikeButton.tintColor = Theme.DARK_GRAY
                dislikeButton.backgroundColor = lineColor
                sendFeedbackToDatabase(like: false, add: false)
                closeDislikeFeedback()
            }
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
        label.text = "Help"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH1
        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return label
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Review my fare or fees"
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        view.numberOfLines = 2
        view.alpha = 0
        
        return view
    }()
    
    var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.PRUSSIAN_BLUE
        view.numberOfLines = 100
        view.text = ""
        view.alpha = 0
        
        return view
    }()
    
    var supportTextLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        view.text = "Support text"
        view.numberOfLines = 2
        view.alpha = 0
        
        return view
    }()
    
    var supportTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.tintColor = Theme.BLUE
        view.font = Fonts.SSPRegularH4
        view.textColor = Theme.BLACK
        view.isScrollEnabled = false
        view.keyboardAppearance = .dark
        view.alpha = 0
        
        return view
    }()
    
    var supportTextLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.alpha = 0
        
        return view
    }()
    
    var supportButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.DARK_GRAY
        button.setTitle("Contact support", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.alpha = 0
        button.addTarget(self, action: #selector(sendHelpMessage), for: .touchUpInside)
        
        return button
    }()
    
    var helpfulLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY
        view.text = "Was this page helpful?"
        view.textAlignment = .center
        view.alpha = 0
        
        return view
    }()
    
    var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.layer.cornerRadius = 20
        let image = UIImage(named: "likeIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.imageEdgeInsets = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)
        button.addTarget(self, action: #selector(helpfulButtonPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var dislikeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.layer.cornerRadius = 20
        let image = UIImage(named: "dislikeIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.imageEdgeInsets = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)
        button.addTarget(self, action: #selector(helpfulButtonPressed(sender:)), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    var feedbackAlert: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLUE
        button.setTitle("Thanks for your feeback!", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH5
        button.layer.cornerRadius = 20
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.2
        button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        button.alpha = 0
        
        return button
    }()
    
    var feedbackTextLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.DARK_GRAY.withAlphaComponent(0.6)
        view.text = "Please provide feedback (optional)"
        view.numberOfLines = 2
        view.alpha = 0
        
        return view
    }()
    
    var feedbackTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.tintColor = Theme.BLUE
        view.font = Fonts.SSPRegularH4
        view.textColor = Theme.BLACK
        view.isScrollEnabled = false
        view.keyboardAppearance = .dark
        view.alpha = 0
        
        return view
    }()
    
    var feedbackTextLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.alpha = 0
        
        return view
    }()
    
    var feedbackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = lineColor
        button.setTitle("Submit feedback", for: .normal)
        button.setTitleColor(Theme.DARK_GRAY, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        button.alpha = 0
        button.addTarget(self, action: #selector(feebackSubmitted), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setInformation(question: String) {
        loadingLine.startAnimating()
        if question != "" {
            FAQString = question
            let ref = Database.database().reference().child("FrequentlyAskedQuestions").child("Answers").child(question)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let faqs = FAQs(dictionary: dictionary)
                    self.FAQ = faqs
                    self.loadingLine.endAnimating()
                }
            }, withCancel: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        supportTextView.delegate = self
        feedbackTextView.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
        setupTitles()
        
        setupTextViews()
        createToolbar()
        setupButtons()
        
        setupHelpful()
    }
    
    var gradientHeightAnchor: CGFloat = 100
    
    func setupViews() {
        
        view.addSubview(scrollView)
        view.addSubview(gradientContainer)
        gradientContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        switch device {
        case .iphone8:
            gradientContainer.heightAnchor.constraint(equalToConstant: self.gradientHeightAnchor).isActive = true
        case .iphoneX:
            gradientContainer.heightAnchor.constraint(equalToConstant: self.gradientHeightAnchor).isActive = true
        }
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1000)
        scrollView.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
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
        
        view.addSubview(feedbackAlert)
        feedbackAlert.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 16).isActive = true
        feedbackAlert.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feedbackAlert.widthAnchor.constraint(equalToConstant: 200).isActive = true
        feedbackAlert.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupTitles() {
        
        gradientContainer.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        scrollView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: 52).isActive = true
        titleLabel.sizeToFit()
        
        scrollView.addSubview(subtitleLabel)
        subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        subtitleLabel.sizeToFit()
        
    }
    
    func setupTextViews() {
        
        scrollView.addSubview(supportTextLabel)
        supportTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        supportTextLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32).isActive = true
        supportTextLabel.sizeToFit()
        
        scrollView.addSubview(supportTextView)
        supportTextView.topAnchor.constraint(equalTo: supportTextLabel.bottomAnchor, constant: 8).isActive = true
        supportTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        supportTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        supportTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        supportTextView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        scrollView.addSubview(supportTextLine)
        supportTextLine.leftAnchor.constraint(equalTo: supportTextView.leftAnchor).isActive = true
        supportTextLine.rightAnchor.constraint(equalTo: supportTextView.rightAnchor).isActive = true
        supportTextLine.bottomAnchor.constraint(equalTo: supportTextView.bottomAnchor).isActive = true
        supportTextLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    var supportTextAnchor: NSLayoutConstraint!
    var noSupportTextAnchor: NSLayoutConstraint!
    
    func setupButtons() {
        
        scrollView.addSubview(supportButton)
        supportTextAnchor = supportButton.topAnchor.constraint(equalTo: supportTextView.bottomAnchor, constant: 32)
            supportTextAnchor.isActive = true
        noSupportTextAnchor = supportButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32)
            noSupportTextAnchor.isActive = false
        supportButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        supportButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        supportButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }
    
    var contactButtonAnchor: NSLayoutConstraint!
    var noContactButtonAnchor: NSLayoutConstraint!
    
    func setupHelpful() {
        
        scrollView.addSubview(helpfulLabel)
        helpfulLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contactButtonAnchor = helpfulLabel.topAnchor.constraint(equalTo: supportButton.bottomAnchor, constant: 48)
            contactButtonAnchor.isActive = true
        noContactButtonAnchor = helpfulLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48)
            noContactButtonAnchor.isActive = false
        helpfulLabel.sizeToFit()
        
        scrollView.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: helpfulLabel.bottomAnchor, constant: 24).isActive = true
        likeButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -12).isActive = true
        likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(dislikeButton)
        dislikeButton.topAnchor.constraint(equalTo: helpfulLabel.bottomAnchor, constant: 24).isActive = true
        dislikeButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 12).isActive = true
        dislikeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor).isActive = true
        dislikeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(feedbackTextLabel)
        feedbackTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        feedbackTextLabel.topAnchor.constraint(equalTo: dislikeButton.bottomAnchor, constant: 32).isActive = true
        feedbackTextLabel.sizeToFit()
        
        scrollView.addSubview(feedbackTextView)
        feedbackTextView.topAnchor.constraint(equalTo: feedbackTextLabel.bottomAnchor, constant: 8).isActive = true
        feedbackTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        feedbackTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        feedbackTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        feedbackTextView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        scrollView.addSubview(feedbackTextLine)
        feedbackTextLine.leftAnchor.constraint(equalTo: feedbackTextView.leftAnchor).isActive = true
        feedbackTextLine.rightAnchor.constraint(equalTo: feedbackTextView.rightAnchor).isActive = true
        feedbackTextLine.bottomAnchor.constraint(equalTo: feedbackTextView.bottomAnchor).isActive = true
        feedbackTextLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        scrollView.addSubview(feedbackButton)
        feedbackButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 32).isActive = true
        feedbackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        feedbackButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        feedbackButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }
    
    func supportText() {
        supportTextAnchor.isActive = true
        noSupportTextAnchor.isActive = false
        supportTextLabel.alpha = 1
        supportTextView.alpha = 1
        supportTextLine.alpha = 1

        contactButton()
        supportButton.setTitle("Contact support", for: .normal)
        supportButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
        supportButton.backgroundColor = lineColor
        supportButton.isUserInteractionEnabled = false
    }
    
    func noSupportText() {
        supportTextAnchor.isActive = false
        noSupportTextAnchor.isActive = true
        supportTextLabel.alpha = 0
        supportTextView.alpha = 0
        supportTextLine.alpha = 0
        supportButton.setTitleColor(Theme.WHITE, for: .normal)
        supportButton.backgroundColor = Theme.DARK_GRAY
        supportButton.isUserInteractionEnabled = true
    }
    
    func contactButton() {
        contactButtonAnchor.isActive = true
        noContactButtonAnchor.isActive = false
        supportButton.alpha = 1
    }
    
    func noContactButton() {
        contactButtonAnchor.isActive = false
        noContactButtonAnchor.isActive = true
        supportButton.alpha = 0
    }
    
    func openFeedback() {
        helpfulLabel.alpha = 1
        likeButton.alpha = 1
        dislikeButton.alpha = 1
    }
    
    func openDislikeFeeback() {
        feedbackTextLabel.alpha = 1
        feedbackTextView.alpha = 1
        feedbackTextLine.alpha = 1
        feedbackButton.alpha = 1
        scrollView.contentSize.height = scrollView.contentSize.height + 100
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - view.frame.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func closeDislikeFeedback() {
        feedbackTextLabel.alpha = 0
        feedbackTextView.alpha = 0
        feedbackTextLine.alpha = 0
        feedbackButton.alpha = 0
        scrollView.contentSize.height = scrollView.contentSize.height - 100
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func expandAlert(title: String, color: UIColor) {
        feedbackAlert.backgroundColor = color
        feedbackAlert.setTitle(title, for: .normal)
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.feedbackAlert.alpha = 1
            self.feedbackAlert.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (success) in
            delayWithSeconds(2, completion: {
                UIView.animate(withDuration: animationOut, animations: {
                    self.feedbackAlert.alpha = 0
                    self.feedbackAlert.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                })
            })
        }
    }
    
    @objc func helpfulButtonPressed(sender: UIButton) {
        if sender == likeButton {
            if userLiked == false {
                userLiked = true
            } else {
                userLiked = false
            }
        } else if sender == dislikeButton {
            if userDisliked == false {
                userDisliked = true
            } else {
                userDisliked = false
            }
        }
    }
    
    func sendFeedbackToDatabase(like: Bool, add: Bool) {
        if let search = self.FAQString {
            let ref = Database.database().reference().child("FrequentlyAskedQuestions").child("Answers").child(search)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let faqs = FAQs(dictionary: dictionary)
                    if like {
                        if add {
                            if let likes = faqs.like {
                                ref.updateChildValues(["like": likes + 1])
                            } else {
                                ref.updateChildValues(["like": 1])
                            }
                        } else {
                            if let likes = faqs.like {
                                ref.updateChildValues(["like": likes - 1])
                            } else {
                                ref.updateChildValues(["like": 0])
                            }
                        }
                    } else {
                        if add {
                            if let dislikes = faqs.dislike {
                                ref.updateChildValues(["dislike": dislikes + 1])
                            } else {
                                ref.updateChildValues(["dislike": 1])
                            }
                        } else {
                            if let dislikes = faqs.dislike {
                                ref.updateChildValues(["dislike": dislikes - 1])
                            } else {
                                ref.updateChildValues(["dislike": 0])
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func feebackSubmitted() {
        guard let feedback = self.feedbackTextView.text else { return }
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        loadingLine.startAnimating()
        if let question = self.FAQString {
            let ref = Database.database().reference().child("FrequentlyAskedQuestions").child("Answers").child(question).child("Feedback")
            ref.updateChildValues([currentUser: feedback])
            loadingLine.endAnimating()
            expandAlert(title: "Submitted feedback", color: Theme.BLUE)
            closeDislikeFeedback()
        }
    }
    
    @objc func backButtonPressed() {
        loadingLine.endAnimating()
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension SendBookingIssuesViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.BLUE.withAlphaComponent(0.1)
        supportTextLine.backgroundColor = Theme.BLUE
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = Theme.LIGHT_GRAY.withAlphaComponent(0.2)
        supportTextLine.backgroundColor = lineColor
    }
    
    // Determine the size of the textview so that it adjusts as the user types
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: phoneWidth - 40, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let estimatedHeight = estimatedSize.height
        if textView == self.feedbackTextView {
            if textView.text != "" {
                feedbackButton.backgroundColor = Theme.DARK_GRAY
                feedbackButton.setTitleColor(Theme.WHITE, for: .normal)
                feedbackButton.isUserInteractionEnabled = true
            } else {
                feedbackButton.backgroundColor = lineColor
                feedbackButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                feedbackButton.isUserInteractionEnabled = false
            }
        } else {
            if textView.text != "" {
                supportButton.backgroundColor = Theme.DARK_GRAY
                supportButton.setTitleColor(Theme.WHITE, for: .normal)
                supportButton.isUserInteractionEnabled = true
            } else {
                supportButton.backgroundColor = lineColor
                supportButton.setTitleColor(Theme.DARK_GRAY, for: .normal)
                supportButton.isUserInteractionEnabled = false
            }
        }
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedHeight >= 110 {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    // Handle when the keyboard is activated so that the textview is always visible
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.tintColor = Theme.WHITE
        toolBar.layer.borderColor = Theme.DARK_GRAY.withAlphaComponent(0.4).cgColor
        toolBar.layer.borderWidth = 0.5
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        supportTextView.inputAccessoryView = toolBar
        feedbackTextView.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}


extension SendBookingIssuesViewController {
    
    @objc func sendHelpMessage() {
        supportButton.alpha = 0.5
        supportButton.isUserInteractionEnabled = false
        
        guard var message = supportTextView.text else { return }
        if supportTextView.alpha != 0 {
            message = titleLabel.text! + ":\n" + message
        } else {
            message = titleLabel.text!
        }
        
        if message != "" && message != "Contact us" {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    guard let name = dictionary["name"] as? String else { return }
                    guard let deviceID = dictionary["DeviceID"] as? String else { return }
                    var email = ""
                    if let mail = dictionary["email"] as? String {
                        email = mail
                    }
                    var picture = ""
                    if let photo = dictionary["picture"] as? String {
                        picture = photo
                    }
                    let timestamp = Date().timeIntervalSince1970
                    let values = ["name": name,
                                  "email": email,
                                  "timestamp": timestamp,
                                  "message": message,
                                  "context": "Help",
                                  "deviceID": deviceID,
                                  "fromID": userID,
                                  "picture": picture,
                                  "communicationsStatus": "Recent"
                        ] as [String : Any]
                    
                    let messageRef = Database.database().reference().child("DrivewayzMessages").child(userID).childByAutoId()
                    messageRef.updateChildValues(values)
                    
                    messageRef.updateChildValues(values, withCompletionBlock: { (error, snap) in
                        if let key = snap.key {
                            let childRef = Database.database().reference().child("Messages").child(key)
                            childRef.updateChildValues(values, withCompletionBlock: { (error, success) in
                                self.supportButton.alpha = 1
                                self.supportButton.isUserInteractionEnabled = true
                                self.view.endEditing(true)
                                self.expandAlert(title: "Contacted support", color: Theme.GREEN_PIGMENT)
                                self.supportTextView.text = ""
                                delayWithSeconds(2, completion: {
                                    self.backButtonPressed()
                                    
                                    delayWithSeconds(1, completion: {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerForNotifications"), object: nil)
                                    })
                                })
                            })
                        }
                    })
                }
            }
        } else {
            expandAlert(title: "Issue sending", color: Theme.STRAWBERRY_PINK)
            supportButton.alpha = 1.0
            supportButton.isUserInteractionEnabled = true
        }
    }
    
}
