//
//  MainScreenController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/3/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import CoreLocation

protocol MainScreenDelegate {
    func closeMainScreen()
    func openBookings()
}

var mainBarNormalHeight: CGFloat = 260 {
    didSet {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "readjustMainBar"), object: nil)
    }
}

enum MainBarRecents: CGFloat {
    case noRecents = 260
    case oneRecents = 340
    case twoRecents = 444
}

class MainScreenController: UIViewController {
    
    var delegate: HandleMainScreenDelegate?
    var centerCoordinate: CLLocationCoordinate2D?
    let loadingline = DashingLine()
    
    var greeting: String = "" {
        didSet {
            greetingLabel.text = greeting
        }
    }
    
    var recents: CLPlacemark? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var mainBarRecents: MainBarRecents = .noRecents {
        didSet {
            mainBarNormalHeight = self.mainBarRecents.rawValue
        }
    }
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var slideBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.LINE_GRAY
        
        return view
    }()
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Good evening"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var searchView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        
        return button
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where are you headed?"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "search_lined")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.backgroundColor = Theme.GRAY_WHITE_4
        button.layer.cornerRadius = 16
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recommended"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(RecentsCell.self, forCellReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        view.backgroundColor = Theme.WHITE
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.layer.shadowColor = Theme.BLACK.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.16
        
        NotificationCenter.default.addObserver(self, selector: #selector(setData), name: UIApplication.significantTimeChangeNotification, object: nil)

        setData()
        setupViews()
        setupRecents()
        
        mainBarRecents = .oneRecents // TESTING
    }
    
    var greetingTopAnchor: NSLayoutConstraint!
    var searchHeightAnchor: NSLayoutConstraint!
    var searchTopAnchor: NSLayoutConstraint!

    func setupViews() {
        
        view.addSubview(container)
        container.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        container.addSubview(slideBar)
        container.addSubview(line)
        
        slideBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slideBar.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 4)
        
        line.anchor(top: slideBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(greetingLabel)
        view.addSubview(searchView)
        
        greetingTopAnchor = greetingLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20)
            greetingTopAnchor.isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        greetingLabel.sizeToFit()
        
        searchView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        searchHeightAnchor = searchView.heightAnchor.constraint(equalToConstant: 60)
            searchHeightAnchor.isActive = true
        searchTopAnchor = searchView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20)
            searchTopAnchor.isActive = true
        
        searchView.addSubview(searchLabel)
        searchView.addSubview(searchButton)
        
        searchLabel.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 20).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchLabel.sizeToFit()
        
        searchButton.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -14).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor).isActive = true
        
    }
    
    func setupRecents() {
        
        container.addSubview(subLabel)
        container.addSubview(tableView)
        
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 32).isActive = true
        subLabel.sizeToFit()
        
        tableView.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func determineCity(location: CLLocation) {
        loadingline.position = CGPoint(x: 0, y: self.line.center.y)
        loadingline.strokeColor = Theme.BLUE_DARK.cgColor
        view.layer.addSublayer(loadingline)
        loadingline.animate()
        
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            guard let placemark = placemarks as? [CLPlacemark] else {
                delayWithSeconds(2) {
                    self.loadingline.endAnimate()
                }
                return
            }
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self.recents = placemark
                
                delayWithSeconds(2) {
                    self.loadingline.endAnimate()
                }
            }
        })
    }
    
    @objc func setData() {
        let time = Date()
        let greeting = check(time: time)
        
        let name = UserDefaults.standard.string(forKey: "userName") ?? ""
        let nameArray = name.split(separator: " ")
        if nameArray.count > 0 {
            let userName = String(nameArray[0])
            if name != "" {
                self.greeting = "Good \(greeting), \(userName)"
            } else {
                self.greeting = "Good \(greeting)"
            }
        } else {
            self.greeting = "Good \(greeting)"
        }
    }
    
    func check(time: Date) -> String {
        let hour = Calendar.current.component(.hour, from: time)
        
        switch hour {
        case 6..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
        }
    }

}

extension MainScreenController: MainScreenDelegate {
    
    func transitionToSearch(percent: CGFloat) {
        if percent == 1 {
            expandSearch()
        } else if percent == 0 {
            dismissSearch()
        } else {
            if canPanMainView {
                searchLabel.alpha = 1 - percent
                searchButton.alpha = 1 - percent
                greetingTopAnchor.constant = 20 + 66 * percent
                searchHeightAnchor.constant = 60 - 20 * percent
                searchTopAnchor.constant = 20 + 48 * percent
                view.layoutIfNeeded()
            }
        }
    }
    
    func expandSearch() {
        greetingLabel.text = "Where are you headed?"
        UIView.animateOut(withDuration: animationOut, animations: {
            self.searchLabel.alpha = 0
            self.searchButton.alpha = 0
            self.greetingTopAnchor.constant = 86
            self.searchHeightAnchor.constant = 40
            self.searchTopAnchor.constant = 68
            self.view.layoutIfNeeded()
        }) { (success) in
            self.presentSearchController()
        }
    }
    
    func dismissSearch() {
        greetingLabel.text = greeting
        UIView.animateOut(withDuration: animationOut, animations: {
            self.searchLabel.alpha = 1
            self.searchButton.alpha = 1
            self.greetingTopAnchor.constant = 20
            self.searchHeightAnchor.constant = 60
            self.searchTopAnchor.constant = 20
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closeMainScreen() {
        delegate?.showWelcomeBanner()
        delegate?.closeSearch(parking: false)
    }
    
    func openBookings() {
        delegate?.openBookings() // NEED TO DETERMINE LOCATION
    }
    
    func presentSearchController() {
        let controller = MainSearchController()
        controller.delegate = self
        controller.centerCoordinate = centerCoordinate
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
}

extension MainScreenController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecentsCell
        cell.selectionStyle = .none
        cell.line.alpha = 0
        
        if let placemark = recents {
            if let locality = placemark.subLocality, let city = placemark.postalAddress?.city, let state = placemark.postalAddress?.state {
                cell.mainLabel.text = locality
                cell.subLabel.text = "\(city), \(state)"
            } else if let locality = placemark.locality, let city = placemark.postalAddress?.city, let state = placemark.postalAddress?.state {
                cell.mainLabel.text = locality
                cell.subLabel.text = "\(city), \(state)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openBookings() // NEED TO DETERMINE LOCATION
    }
    
}
