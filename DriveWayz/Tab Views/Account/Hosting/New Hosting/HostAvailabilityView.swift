//
//  HostAvailabilityView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/30/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

protocol NewHostAvailabilityDelegate {
    func changeTimeRange(times: [Date])
    func addRangePressed()
    func removeRangePressed()
    func removeDim()
    
    func moveToPrice()
}

class HostAvailabilityView: UIViewController {
    
    var options: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var timeRange: [Date] = []
    
    var selectedIndex: Int = 0
    var selectedTimes: [Int: [Date]] = [:]

    lazy var gradientController: GradientContainerView = {
        let controller = GradientContainerView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.mainLabel.text = ""
        controller.setBackButton()
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
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: abs(cancelBottomHeight * 2), right: 0)
        
        return view
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.BLACK
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.BLACK.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var sliderController: AvailabilitySliderView = {
        let controller = AvailabilitySliderView()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        controller.view.alpha = 0
        controller.delegate = self
        
        return controller
    }()
    
    lazy var helpButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "helpIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openHelp), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()
    
    var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customVerticalColor(topColor: Theme.BACKGROUND_GRAY.withAlphaComponent(0), bottomColor: Theme.BACKGROUND_GRAY)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: abs(cancelBottomHeight * 2) + 16)
        background.zPosition = 10
        view.layer.addSublayer(background)
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    lazy var optionsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(AvailabilityCell.self, forCellReuseIdentifier: "cellId")
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.separatorStyle = .none
        view.keyboardDismissMode = .interactive
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.alpha = 0
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: gradientHeight, right: 0)
        
        return view
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.message = "Please set your availability for every day of the week"
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.verticalTriangle()
        view.centerTriangle()
        view.label.font = Fonts.SSPRegularH4
        view.alpha = 0
        
        return view
    }()
    
    let paging: ProgressPagingDisplay = {
        let view = ProgressPagingDisplay()
        view.changeProgress(index: 2)
        view.alpha = 0
        
        return view
    }()
    
    // Rest of the Host Signup process
    var hostCostController = HostPriceView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        scrollView.delegate = self
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(progressTapped))
        paging.addGestureRecognizer(tap)

        setupViews()
        setupControllers()
    }
    
    @objc func progressTapped() {
        let controller = HostProgressView()
        controller.shouldDismiss = true
        controller.progressController.thirdStep()
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gradientController.scrollView.scrollToTop(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gradientController.mainLabel.text == "" {
            gradientController.animateText(text: "Set availability")
            delayWithSeconds(animationOut) {
                self.gradientController.setSublabel(text: "When is the spot available?")
                UIView.animate(withDuration: animationIn) {
                    self.paging.alpha = 1
                    self.view.layoutIfNeeded()
                }
                if self.nextButton.tintColor != Theme.WHITE {
                    self.showNextButton()
                }
                self.animate()
            }
        } else {
           removeDim()
           showNextButton()
       }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scrollView.scrollToTop(animated: true)
    }
    
    var nextButtonBottomAnchor: NSLayoutConstraint!
    var nextButtonKeyboardAnchor: NSLayoutConstraint!
    var nextButtonRightAnchor: NSLayoutConstraint!

    func setupViews() {
        
        view.addSubview(gradientController.view)
        view.addSubview(scrollView)
        
        gradientController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        gradientController.view.addSubview(paging)
        paging.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paging.centerYAnchor.constraint(equalTo: gradientController.backButton.centerYAnchor).isActive = true
        paging.widthAnchor.constraint(equalToConstant: 86).isActive = true
        paging.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(blurView)
        blurView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: abs(cancelBottomHeight * 2) + 16)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        nextButtonBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            nextButtonBottomAnchor.isActive = true
        nextButtonKeyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            nextButtonKeyboardAnchor.isActive = false
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: phoneWidth/2)
            nextButtonRightAnchor.isActive = true
        
        gradientController.view.addSubview(helpButton)
        helpButton.centerYAnchor.constraint(equalTo: gradientController.backButton.centerYAnchor).isActive = true
        helpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        helpButton.heightAnchor.constraint(equalTo: helpButton.widthAnchor).isActive = true
        helpButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    var sliderHeightAnchor: NSLayoutConstraint!
    var bubbleArrowTopAnchor: NSLayoutConstraint!
    
    func setupControllers() {
        
        scrollView.contentSize = CGSize(width: phoneWidth, height: 1000)
        scrollView.anchor(top: gradientController.gradientContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(sliderController.view)
        sliderController.view.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        sliderHeightAnchor = sliderController.view.heightAnchor.constraint(equalToConstant: 292)
            sliderHeightAnchor.isActive = true
        
        scrollView.addSubview(optionsTableView)
        optionsTableView.anchor(top: sliderController.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(bubbleArrow)
        bubbleArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bubbleArrow.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 72).isActive = true
        bubbleArrowTopAnchor = bubbleArrow.bottomAnchor.constraint(equalTo: scrollView.topAnchor)
            bubbleArrowTopAnchor.isActive = true

        view.addSubview(dimView)
    }
    
    @objc func nextButtonPressed() {
        let check = checkTimeSelection()
        if !check {
            let value = selectedTimes.count
                if value > 0 {
                    let index = IndexPath(row: value, section: 0)
                    optionsTableView.backgroundColor = Theme.SALMON.withAlphaComponent(0.2)
                    let frame = optionsTableView.rectForRow(at: index)
                    let y = optionsTableView.convert(frame, to: scrollView).minY + 8
            
                    bubbleArrowTopAnchor.constant = y
                } else {
                    let y = optionsTableView.frame.minY + 56
                    bubbleArrowTopAnchor.constant = y
                }
                UIView.animate(withDuration: animationIn, animations: {
                    self.bubbleArrow.alpha = 1
                    self.view.layoutIfNeeded()
                }) { (success) in
                    
                }
        } else {
            confirmAvailability()
        }
    }
    
    func confirmAvailability() {
        dimBackground()
        let controller = ConfirmAvailabilityView()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func moveToPrice() {
        mainTypeState = .price
        hideNextButton(completion: {})
        delayWithSeconds(animationOut + animationIn/2) {
            self.dimBackground()
            self.navigationController?.pushViewController(self.hostCostController, animated: true)
        }
    }
    
    func changeTimeRange(times: [Date]) {
        timeRange = times
    }
    
    func checkTimeSelection() -> Bool {
        if selectedTimes.count != 7 {
            return false
        } else {
            return true
        }
    }
    
    @objc func backButtonPressed() {
        mainTypeState = .pictures
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openHelp() {
        dimBackground()
        let controller = AvailabilityInformationController()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func showNextButton() {
        nextButton.alpha = 1
        nextButtonRightAnchor.constant = phoneWidth/2
        view.layoutIfNeeded()
        
        nextButtonRightAnchor.constant = -20
        UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationOut, delay: 0, options: .curveEaseOut, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                if mainTypeState == .pictures {
                    self.nextButton.tintColor = Theme.BLACK
                } else {
                    self.nextButton.tintColor = Theme.WHITE
                }
            }) { (success) in
                self.nextButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func hideNextButton(completion: @escaping() -> Void) {
        UIView.animate(withDuration: animationIn, delay: 0, options: .curveEaseOut, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: -0.2, y: 0.2)
            self.nextButton.tintColor = Theme.BLACK
        }) { (success) in
            self.nextButtonRightAnchor.constant = -phoneWidth * 1.5
            UIView.animate(withDuration: animationIn, delay: animationIn/2, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                completion()
            }
        }
    }
    
    func animate() {
        UIView.animate(withDuration: animationOut, animations: {
            self.sliderController.view.alpha = 1
            self.optionsTableView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func dimBackground() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0.7
        }
    }
    
    func removeDim() {
        UIView.animate(withDuration: animationIn) {
            self.dimView.alpha = 0
        }
    }

}

extension HostAvailabilityView: NewHostAvailabilityDelegate {
    
    func addRangePressed() {
        sliderHeightAnchor.constant = 260
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    func removeRangePressed() {
        sliderHeightAnchor.constant = 292
        UIView.animate(withDuration: animationIn) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension HostAvailabilityView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let range = selectedTimes[indexPath.row], range.count == 4 {
            return 116
        } else {
            return 92
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.BACKGROUND_GRAY
        
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Select day to set time range"
        
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.sizeToFit()
        
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AvailabilityCell
        cell.selectionStyle = .none
        
        if options.count > indexPath.row {
            cell.mainLabel.text = options[indexPath.row]
        }
        
        if let range = selectedTimes[indexPath.row] {
            cell.dates = range
        } else {
            cell.cellUnselected()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.backgroundColor = .clear
        bubbleArrow.alpha = 0
        
        let cell = tableView.cellForRow(at: indexPath) as! AvailabilityCell
        cell.dates = timeRange
        selectedTimes[selectedIndex] = timeRange
        
        // Update the height for all the cells
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

extension HostAvailabilityView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        let state = scrollView.panGestureRecognizer.state
        if state == .changed {
            if translation > 0 && translation < 60 {
                let percent = translation/60
                gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight - (gradientController.gradientNewHeight - gradientHeight + 60) * percent
                gradientController.subLabelBottom.constant = gradientController.subHeight * percent
                gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1 - 0.2 * percent, y: 1 - 0.2 * percent)
                if percent >= 0 && percent <= 0.3 {
                    let percentage = percent/0.3
                    gradientController.subLabel.alpha = 1 - 1 * percentage
                    paging.alpha = 1 - 1 * percentage
                } else if percent >= 0 {
                    gradientController.subLabel.alpha = 0
                    paging.alpha = 0
                }
            }
        } else {
            if translation < 0 && gradientController.gradientHeightAnchor.constant != gradientController.gradientNewHeight {
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
        gradientController.subLabelBottom.constant = 0
        gradientController.gradientHeightAnchor.constant = gradientController.gradientNewHeight
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.gradientController.subLabel.alpha = 1
            self.paging.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func scrollMinimized() {
        gradientController.subLabelBottom.constant = gradientController.subHeight
        gradientController.gradientHeightAnchor.constant = gradientHeight - 60
        UIView.animate(withDuration: animationOut, animations: {
            self.gradientController.mainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.gradientController.subLabel.alpha = 0
            self.paging.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
}

