//
//  PayoutIssueHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PayoutIssueHelpView: UIViewController {
    
    var delegate: HelpMenuDelegate?

    var allOptions: FrequentlyAskedQuestions? {
        didSet {
            if let options = self.allOptions {
                if let questions = options.questionTopics {
                    self.options = [:]
                    for question in questions {
                        let title = question.title
                        if title == "Payment Information" {
                            self.options[title] = question.questions
                            if let count = question.questions?.count {
                                optionsHeightAnchor.constant += CGFloat(63 + count * 60)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var options: [String: [QuestionsStruct]] = [:] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.setExitButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollView.isHidden = true
        
        return controller
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(HelpCell.self, forCellReuseIdentifier: "cellId")
        view.isScrollEnabled = false
        
        return view
    }()
    
    func observeHelp() {
        gradientController.loadingLine.startAnimating()
        let ref = Database.database().reference().child("FrequentlyAskedQuestions")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let FAQ = FrequentlyAskedQuestions(dictionary: dictionary)
                self.allOptions = FAQ
                
                self.gradientController.loadingLine.endAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.OFF_WHITE
        
        scrollView.delegate = self
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupViews()
        observeHelp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text != "Help" {
            gradientController.setMainLabel(text: "Help")
        }
    }
    
    var optionsHeightAnchor: NSLayoutConstraint! {
        didSet {
            view.layoutIfNeeded()
        }
    }
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(scrollView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1600)
        scrollView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        optionsHeightAnchor = optionsTableView.heightAnchor.constraint(equalToConstant: 0)
            optionsHeightAnchor.isActive = true
        
    }

    @objc func exitHostResponsibilities() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        delegate?.removeDim()
        dismiss(animated: true) {
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension PayoutIssueHelpView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let count = options.first?.value.count {
                return count
            }
        } else if section == 1 {
            if let count = options.dropFirst().first?.value.count {
                return count
            }
        }
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let array = options.first?.value {
                if array.count > indexPath.row {
                    let title = array[indexPath.row].title
                    let lines = calculateMaxLines(text: title)
                    if lines > 1 {
                        optionsHeightAnchor.constant += 20
                        return 80
                    } else {
                        return 60
                    }
                } else {
                    return 60
                }
            }
        } else if indexPath.section == 1 {
            if let array = options.dropFirst().first?.value {
                if array.count > indexPath.row {
                    let title = array[indexPath.row].title
                    let lines = calculateMaxLines(text: title)
                    if lines > 1 {
                        optionsHeightAnchor.constant += 20
                        return 80
                    } else {
                        return 60
                    }
                } else {
                    return 60
                }
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        if section == 0 {
            label.text = options.first?.key
        } else if section == 1 {
            label.text = options.dropFirst().first?.key
        }
        
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.sizeToFit()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! HelpCell
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if indexPath.section == 0 {
            if let array = options.first?.value {
                if array.count > indexPath.row {
                    cell.subOption = array[indexPath.row]
                }
            }
        } else if indexPath.section == 1 {
            if let array = options.dropFirst().first?.value {
                if array.count > indexPath.row {
                    cell.subOption = array[indexPath.row]
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! HelpCell
        if let key = cell.subOption?.key, let title = cell.titleLabel.text {
            let controller = SendBookingIssuesViewController()
            controller.setInformation(question: key)
            controller.titleLabel.text = title
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func calculateMaxLines(text: String) -> Int {
        let font = Fonts.SSPRegularH4
        let maxSize = CGSize(width: (phoneWidth - 72), height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
}


extension PayoutIssueHelpView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientHeight - percent * 60
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
            } else if translation <= -60 {
                gradientController.backButton.sendActions(for: .touchUpInside)
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientHeight {
                scrollExpanded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation >= 55 {
            scrollMinimized()
        } else {
            scrollExpanded()
        }
    }
    
    func scrollExpanded() {
        gradientController.gradientHeightAnchor.constant = gradientHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}
