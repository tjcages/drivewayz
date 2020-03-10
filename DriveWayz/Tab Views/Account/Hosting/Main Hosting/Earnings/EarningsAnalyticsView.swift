//
//  EarningsAnalyticsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/14/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class EarningsAnalyticsView: UIViewController {

    var hostListing: ParkingSpots? {
        didSet {
            if let parking = hostListing {
                
            }
        }
    }
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SSPRegularH4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_WHITE
        label.text = "Parking analytics"
        
        return label
    }()

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var analyticsView1: AnalyticsBoxView = {
        let view = AnalyticsBoxView()
        view.earningsLabel.text = "50"
        view.mainLabel.text = "Unique views \nthis week"
        
        return view
    }()
    
    var analyticsView2: AnalyticsBoxView = {
        let view = AnalyticsBoxView()
        view.earningsLabel.text = "2.4x"
        view.mainLabel.text = "Average parking \nincrease"
        
        return view
    }()
    
    lazy var notificationsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PaymentsCell.self, forCellReuseIdentifier: "cellId")
        view.clipsToBounds = true
        view.backgroundColor = Theme.WHITE
        view.separatorStyle = .none
        view.isScrollEnabled = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationsTable.delegate = self
        notificationsTable.dataSource = self
        
        setupViews()
    }
    
    var selectionCenterAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(subLabel)
        view.addSubview(analyticsView1)
        view.addSubview(analyticsView2)
        view.addSubview(container)
        
        subLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        analyticsView1.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.centerXAnchor, paddingTop: 16, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        analyticsView1.heightAnchor.constraint(equalTo: analyticsView1.widthAnchor, multiplier: 0.7).isActive = true
        
        analyticsView2.anchor(top: analyticsView1.topAnchor, left: view.centerXAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 14, width: 0, height: 0)
        analyticsView2.heightAnchor.constraint(equalTo: analyticsView2.widthAnchor, multiplier: 0.7).isActive = true
        
        container.anchor(top: analyticsView1.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(notificationsTable)
        notificationsTable.anchor(top: container.topAnchor, left: view.leftAnchor, bottom: container.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

}

extension EarningsAnalyticsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.WHITE
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Show more"
        label.textColor = Theme.BLUE
        label.font = Fonts.SSPSemiBoldH3
        
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.sizeToFit()
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: 1))
        line.backgroundColor = Theme.LINE_GRAY
        view.addSubview(line)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PaymentsCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        cell.selectionStyle = .none        
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
