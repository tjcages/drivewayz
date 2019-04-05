//
//  SearchSummaryViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 4/1/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class SearchSummaryViewController: UIViewController {
    
    let maxWidth: CGFloat = 327
    var shouldBeLoading: Bool = true
    
    var toText: String = "Folsom Field" {
        didSet {
            if let dotRange = toText.range(of: ",") {
                toText.removeSubrange(dotRange.lowerBound..<toText.endIndex)
            }
            self.toLabel.text = toText
            self.determineSizing()
        }
    }
    
    var searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "Current location"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.text = "Folsom Field"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var searchLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.4

        setupViews()
        determineSizing()
    }
    
    func determineSizing() {
        guard let fromText = self.fromLabel.text, let toText = self.toLabel.text else { return }
        var fromWidth = fromText.width(withConstrainedHeight: 25, font: Fonts.SSPRegularH4)
        let toWidth = toText.width(withConstrainedHeight: 25, font: Fonts.SSPRegularH4)
        if fromWidth > maxWidth/2 - 12 {
           fromWidth = maxWidth/2 - 12
        }
        self.fromWidthAnchor.constant = fromWidth
        self.searchBarWidthAnchor.constant = fromWidth + toWidth + 104
        if self.searchBarWidthAnchor.constant > maxWidth {
            self.searchBarWidthAnchor.constant = maxWidth
        }
        self.view.layoutIfNeeded()
    }

    var fromWidthAnchor: NSLayoutConstraint!
    var searchBarWidthAnchor: NSLayoutConstraint!
    
    var loadingParkingLeftAnchor: NSLayoutConstraint!
    var loadingParkingRightAnchor: NSLayoutConstraint!
    var loadingParkingWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(searchBarView)
        self.view.addSubview(fromSearchLine)
        self.view.addSubview(fromLabel)
        self.view.addSubview(toLabel)
        
        searchBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        searchBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        searchBarWidthAnchor = searchBarView.widthAnchor.constraint(equalToConstant: 327)
            searchBarWidthAnchor.isActive = true
        searchBarView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        fromLabel.leftAnchor.constraint(equalTo: searchBarView.leftAnchor, constant: 16).isActive = true
        fromLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -2).isActive = true
        fromWidthAnchor = fromLabel.widthAnchor.constraint(equalToConstant: maxWidth)
            fromWidthAnchor.isActive = true
        fromLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        toLabel.rightAnchor.constraint(equalTo: searchBarView.rightAnchor, constant: -16).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -2).isActive = true
        toLabel.leftAnchor.constraint(equalTo: fromSearchLine.rightAnchor, constant: 8).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        fromSearchLine.bottomAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: -8).isActive = true
        fromSearchLine.leftAnchor.constraint(equalTo: fromLabel.rightAnchor, constant: 8).isActive = true
        fromSearchLine.widthAnchor.constraint(equalToConstant: 49.4).isActive = true
        fromSearchLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        searchBarView.addSubview(searchLine)
        searchLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        searchLine.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor).isActive = true
        loadingParkingLeftAnchor = searchLine.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            loadingParkingLeftAnchor.isActive = true
        loadingParkingRightAnchor = searchLine.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            loadingParkingRightAnchor.isActive = false
        loadingParkingWidthAnchor = searchLine.widthAnchor.constraint(equalToConstant: 0)
            loadingParkingWidthAnchor.isActive = true
        
    }
    
    func loadingParking() {
        if shouldBeLoading == true {
            self.loadingParkingWidthAnchor.constant = 100
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                self.loadingParkingLeftAnchor.isActive = false
                self.loadingParkingRightAnchor.isActive = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (success) in
                    self.loadingParkingWidthAnchor.constant = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: { (success) in
                        self.loadingParkingLeftAnchor.isActive = true
                        self.loadingParkingRightAnchor.isActive = false
                        self.view.layoutIfNeeded()
                        self.loadingParking()
                    })
                })
            }
        }
    }
    
    var fromSearchLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        let size: CGFloat = 2.0
        let color = Theme.WHITE
        let start: CGFloat = 4.2
        let difference: CGFloat = 8.2
        
        let dot1 = UIView(frame: CGRect(x: start, y: 0.0, width: size, height: size))
        dot1.backgroundColor = color
        dot1.layer.cornerRadius = size/2
        view.addSubview(dot1)
        
        let dot2 = UIView(frame: CGRect(x: start + difference, y: 0.0, width: size, height: size))
        dot2.backgroundColor = color
        dot2.layer.cornerRadius = size/2
        view.addSubview(dot2)
        
        let dot3 = UIView(frame: CGRect(x: start + difference * 2, y: 0.0, width: size, height: size))
        dot3.backgroundColor = color
        dot3.layer.cornerRadius = size/2
        view.addSubview(dot3)
        
        let dot4 = UIView(frame: CGRect(x: start + difference * 3, y: 0.0, width: size, height: size))
        dot4.backgroundColor = color
        dot4.layer.cornerRadius = size/2
        view.addSubview(dot4)
        
        let dot5 = UIView(frame: CGRect(x: start + difference * 4, y: 0.0, width: size, height: size))
        dot5.backgroundColor = color
        dot5.layer.cornerRadius = size/2
        view.addSubview(dot5)
        
        let dot6 = UIView(frame: CGRect(x: start + difference * 5, y: 0.0, width: size, height: size))
        dot6.backgroundColor = color
        dot6.layer.cornerRadius = size/2
        view.addSubview(dot6)
        
        return view
    }()
    
}
