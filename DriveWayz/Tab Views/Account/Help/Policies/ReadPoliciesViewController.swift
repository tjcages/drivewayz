//
//  ReadPoliciesViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import WebKit

class ReadPoliciesViewController: UIViewController, WKNavigationDelegate {
    
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
    
    lazy var container: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var rulesView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.alpha = 0
        view.decelerationRate = .fast
        
        return view
    }()
    
    var Url: URL? {
        didSet {
            self.loadingLine.startAnimating()
            if let url = self.Url, url.absoluteString != "" {
                self.webView.load(URLRequest(url: url))
                self.rulesView.alpha = 0
            } else {
                self.webView.alpha = 0
                self.rulesView.alpha = 1
                self.loadingLine.endAnimating()
            }
        }
    }
    
    var regulationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.DARK_GRAY
        label.text = "Rules and regulations"
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var regulationsSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = "When deciding whether to become a Drivewayz host, it's important for you to understand how the laws work in your city."
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 10
        
        return label
    }()
    
    var regulations1ImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-magnifier")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var regulations2ImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-document")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var regulations3ImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "flat-folder")
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var regulationsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    var regulationsSubLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.PRUSSIAN_BLUE
        label.text = """
        Some cities have laws that restrict your ability to host paying guests for short periods. These laws are often part of a city's zoning or administrative codes. In many cities, you must register, get a permit, or obtain a license before you list your property or accept guests. Certain types of short-term bookings may be prohibited altogether. Local governments vary greatly in how they enforce these laws. Penalties may include fines or other enforcement.
        
        These rules can be confusing. We're working with governments around the world to clarify these rules so that everyone has a clear understanding of what the laws are.
        
        In some tax jurisdictions, Drivewayz will take care of calculating, collecting, and remitting local occupancy tax on your behalf. Occupancy tax is calculated differently in every jurisdiction, and we’re moving as quickly as possible to extend this benefit to more hosts around the globe.
        
        Please review your local laws before listing your space on Drivewayz. By accepting our Terms of Service and activating a listing, you certify that you will follow your local laws and regulations.
        """
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 100
        
        return label
    }()
    
    var loadingLine: LoadingLine = {
        let view = LoadingLine()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        webView.navigationDelegate = self
        
        setupViews()
        setupRegulations()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        self.view.addSubview(webView)
        self.view.addSubview(rulesView)
        self.view.addSubview(darkView)
        self.view.addSubview(backButton)
        
        webView.topAnchor.constraint(equalTo: backButton.topAnchor, constant: -6).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        rulesView.contentSize = CGSize(width: phoneWidth, height: 1200)
        rulesView.topAnchor.constraint(equalTo: darkView.bottomAnchor).isActive = true
        rulesView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        rulesView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        rulesView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        darkView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        darkView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        darkView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        darkView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16).isActive = true
        
        darkView.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: darkView.bottomAnchor).isActive = true
        loadingLine.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingLine.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switch device {
        case .iphone8:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 28).isActive = true
        case .iphoneX:
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48).isActive = true
        }
        
    }
    
    func setupRegulations() {
        
        rulesView.addSubview(regulationsLabel)
        regulationsLabel.topAnchor.constraint(equalTo: rulesView.topAnchor, constant: 24).isActive = true
        regulationsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        regulationsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        regulationsLabel.sizeToFit()
        
        rulesView.addSubview(regulationsSubLabel)
        regulationsSubLabel.topAnchor.constraint(equalTo: regulationsLabel.bottomAnchor, constant: 16).isActive = true
        regulationsSubLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        regulationsSubLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        regulationsSubLabel.sizeToFit()
        
        rulesView.addSubview(regulationsView)
        rulesView.addSubview(regulations1ImageView)
        rulesView.addSubview(regulations2ImageView)
        rulesView.addSubview(regulations3ImageView)
        
        regulations1ImageView.topAnchor.constraint(equalTo: regulationsSubLabel.bottomAnchor, constant: 32).isActive = true
        regulations1ImageView.rightAnchor.constraint(equalTo: regulations2ImageView.leftAnchor, constant: -48).isActive = true
        regulations1ImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        regulations1ImageView.heightAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        
        regulations2ImageView.topAnchor.constraint(equalTo: regulationsSubLabel.bottomAnchor, constant: 32).isActive = true
        regulations2ImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        regulations2ImageView.widthAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        regulations2ImageView.heightAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        
        regulations3ImageView.topAnchor.constraint(equalTo: regulationsSubLabel.bottomAnchor, constant: 32).isActive = true
        regulations3ImageView.leftAnchor.constraint(equalTo: regulations2ImageView.rightAnchor, constant: 48).isActive = true
        regulations3ImageView.widthAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        regulations3ImageView.heightAnchor.constraint(equalTo: regulations1ImageView.widthAnchor).isActive = true
        
        regulationsView.centerYAnchor.constraint(equalTo: regulations1ImageView.centerYAnchor).isActive = true
        regulationsView.leftAnchor.constraint(equalTo: regulations1ImageView.leftAnchor, constant: -24).isActive = true
        regulationsView.rightAnchor.constraint(equalTo: regulations3ImageView.rightAnchor, constant: 24).isActive = true
        regulationsView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        rulesView.addSubview(regulationsSubLabel2)
        regulationsSubLabel2.topAnchor.constraint(equalTo: regulationsView.bottomAnchor, constant: 24).isActive = true
        regulationsSubLabel2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        regulationsSubLabel2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        regulationsSubLabel2.sizeToFit()

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        self.loadingLine.endAnimating()
    }
    
    @objc func backButtonPressed() {
        self.loadingLine.endAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
