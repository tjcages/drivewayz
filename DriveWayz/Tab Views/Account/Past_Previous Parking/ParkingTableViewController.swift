//
//  ParkingTableViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ParkingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ParkingTableCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(ParkingHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ParkingTableCell
        if indexPath.row == 0 {
            cell.parkingImage = UIImage(named: "background1")
        } else {
            cell.parkingImage = UIImage(named: "background3")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! ParkingHeaderCell
        if section > 0 {
            headerCell.headerLabelAnchor.constant = 0
        } else {
            headerCell.headerLabelAnchor.constant = (headerCell.headerLabel.text?.width(withConstrainedHeight: 40, font: Fonts.SSPSemiBoldH2))! - 16
        }
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 3 {
            return 40
        } else {
            return 0
        }
    }
    
}

class ParkingTableCell: UITableViewCell {
    
    var parkingImage: UIImage? {
        didSet {
            let image = resizeImage(image: parkingImage!, targetSize: CGSize(width: 100, height: 100))
            parkingImageView.image = image
        }
    }
    
    var parkingImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var parkingLabel: UILabel = {
        let view = UILabel()
        view.text = "Two-Car Garage"
        view.font = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var secondaryLabel: UILabel = {
        let view = UILabel()
        view.text = "Denver, CO  |  2.75 hours"
        view.font = Fonts.SSPLightH5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK.withAlphaComponent(0.6)
        
        return view
    }()
    
    var costLabel: UILabel = {
        let view = UILabel()
        view.text = "$12.38"
        view.font = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        view.textAlignment = .right
        
        return view
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var cellLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.2)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(parkingImageView)
        addSubview(parkingLabel)
        addSubview(secondaryLabel)
        addSubview(costLabel)
        addSubview(nextButton)
        addSubview(cellLine)
        
        parkingImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        parkingImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        parkingImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        parkingImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        parkingLabel.topAnchor.constraint(equalTo: parkingImageView.topAnchor, constant: -4).isActive = true
        parkingLabel.leftAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: 12).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        
        secondaryLabel.bottomAnchor.constraint(equalTo: parkingImageView.bottomAnchor, constant: -4).isActive = true
        secondaryLabel.leftAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: 12).isActive = true
        secondaryLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        secondaryLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        
        costLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        costLabel.rightAnchor.constraint(equalTo: nextButton.leftAnchor, constant: -6).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        costLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 80).isActive = true
        
        nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        cellLine.bottomAnchor.constraint(equalTo: parkingImageView.bottomAnchor, constant: 2).isActive = true
        cellLine.leftAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: 12).isActive = true
        cellLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        cellLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ParkingHeaderCell: UITableViewCell {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.SEA_BLUE
        label.font = Fonts.SSPSemiBoldH3
        label.text = "Current  | "
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH3
        label.text = "Tue, Jan 8th"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    var headerLabelAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.addSubview(headerLabel)
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        headerLabelAnchor = headerLabel.widthAnchor.constraint(equalToConstant: (headerLabel.text?.width(withConstrainedHeight: 40, font: Fonts.SSPSemiBoldH2))! - 16)
            headerLabelAnchor.isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive = true
        headerLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: headerLabel.rightAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
