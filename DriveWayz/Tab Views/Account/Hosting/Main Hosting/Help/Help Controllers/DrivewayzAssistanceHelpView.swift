//
//  DrivewayzAssistanceHelpView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/20/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import CHIPageControl

class DrivewayzAssistanceHelpView: UIViewController {

    var delegate: HelpMenuDelegate?
        
    let cellWidth: CGFloat = 272
    let cellHeight: CGFloat = 192
    private var indexOfCellBeforeDragging = 0
    
    var allOptions: FrequentlyAskedQuestions? {
        didSet {
            if let options = self.allOptions {
                if let quick = options.quickTopics {
                    self.mainOptions = quick
                }
                if let question = options.questionTopics {
                    self.options = question
                }
            }
        }
    }
    
    var mainOptions: [QuickTopicsStruct] = [] {
        didSet {
            helpPicker.reloadData()
        }
    }
    
    var options: [QuestionTopicsStruct] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    
    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.setExitButton()
        controller.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        controller.scrollViewHeight = 1200
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
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Popular Topics"
        
        return label
    }()
    
    var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        return layout
    }()
    
    lazy var helpPicker: UICollectionView = {
        let picker = UICollectionView(frame: .zero, collectionViewLayout: layout)
        picker.backgroundColor = Theme.WHITE
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsHorizontalScrollIndicator = false
        picker.showsVerticalScrollIndicator = false
        picker.register(HelpOptionCell.self, forCellWithReuseIdentifier: "identifier")
        picker.decelerationRate = .fast
        picker.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 16, right: 24)
        
        return picker
    }()
    
    var pageControl: CHIPageControlPuya = {
        let pageControl = CHIPageControlPuya(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.tintColor = Theme.GRAY_WHITE_4
        pageControl.currentPageTintColor = Theme.GRAY_WHITE
        pageControl.padding = 6
        
        return pageControl
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
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        scrollView.delegate = self
        helpPicker.delegate = self
        helpPicker.dataSource = self
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
    
    var optionsHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(scrollView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1200)
        scrollView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(mainLabel)
        scrollView.addSubview(helpPicker)
        scrollView.addSubview(pageControl)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32).isActive = true
        mainLabel.sizeToFit()
        
        helpPicker.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: cellHeight + 56)
        
        pageControl.bottomAnchor.constraint(equalTo: helpPicker.bottomAnchor, constant: -12).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.sizeToFit()
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.anchor(top: helpPicker.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        optionsHeightAnchor = optionsTableView.heightAnchor.constraint(equalToConstant: 0)
            optionsHeightAnchor.isActive = true
        
    }
    
    func moveToTerms() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/terms.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToPrivacy() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/privacy.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToFAQ() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/faqs.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostPolicies() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/host-policies.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostRegulations() {
        let controller = ReadPoliciesViewController()
        controller.Url = URL(string: "http://www.drivewayz.io/rules--regulations.html")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToRelease(notes: String?) {
        let controller = ReleaseNotesView()
        controller.notes = notes
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToStarting() {
        let controller = GettingStartedView()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToHostResponsibilities() {
        let controller = HostResponsibilitiesViewController()
        controller.exitButton.addTarget(self, action: #selector(exitHostResponsibilities), for: .touchUpInside)
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.isHidden = true
        self.present(navigation, animated: true, completion: nil)
    }
    
    func moveToContact() {
        let controller = UserContactViewController()
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        controller.backButton.setImage(image, for: .normal)
        self.navigationController?.pushViewController(controller, animated: true)
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

extension DrivewayzAssistanceHelpView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = mainOptions.count
        pageControl.numberOfPages = number
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath as IndexPath) as! HelpOptionCell
        
        if mainOptions.count > indexPath.row {
            let option = mainOptions[indexPath.row]
            cell.mainOption = option
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HelpOptionCell else { return }
        if let option = cell.mainOption {
            let page = option.page
            determinePage(page: page, notes: nil)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView {
            indexOfCellBeforeDragging = indexOfMajorCell()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView != self.scrollView {
            // Stop scrollView sliding:
            targetContentOffset.pointee = scrollView.contentOffset
            // Calculate where scrollView should snap to:
            let indexOfMajorCell = self.indexOfMajorCell()
            
            // calculate conditions:
            let swipeVelocityThreshold: CGFloat = 0.5
            let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < mainOptions.count && velocity.x > swipeVelocityThreshold
            let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
            let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
            let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
            
            if didUseSwipeToSkipCell {
                let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
                let toValue = self.cellWidth * CGFloat(snapToIndex)
                
                self.pageControl.set(progress: snapToIndex, animated: true)
                // Damping equal 1 => no oscillations => decay animation:
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                }, completion: nil)
            } else {
                let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
                self.layout.collectionView!.scrollToItem(at: indexPath, at: .left, animated: true)
                
                self.pageControl.set(progress: indexOfMajorCell, animated: true)
            }
        }
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = cellWidth
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(mainOptions.count - 1, index))
        
        return safeIndex
    }
    
}

extension DrivewayzAssistanceHelpView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        optionsHeightAnchor.constant = CGFloat(47 + options.count * 60)
        view.layoutIfNeeded()
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Other Topics"
        
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
        
        if options.count > indexPath.row {
            cell.mainOption = options[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = optionsTableView.cellForRow(at: indexPath) as! HelpCell
        if let option = cell.mainOption, let title = cell.titleLabel.text {
            if let page = option.page {
                determinePage(page: page, notes: option.notes)
            } else {
                let controller = NextHelpView()
                controller.otherTopic = title
                controller.mainOption = option
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func determinePage(page: String, notes: String?) {
        if page == "privacy" {
            moveToPrivacy()
        } else if page == "terms" {
            moveToTerms()
        } else if page == "FAQ" {
            moveToFAQ()
        } else if page == "policies" {
            moveToHostPolicies()
        } else if page == "regulations" {
            moveToHostRegulations()
        } else if page == "contact" {
            moveToContact()
        } else if page == "notes" {
            moveToRelease(notes: notes)
        } else if page == "hosting" {
            moveToHostResponsibilities()
        } else if page == "start" {
            moveToStarting()
        }
    }
    
}


extension DrivewayzAssistanceHelpView: UIScrollViewDelegate {
    
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
