//
//  HostingGuestsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/15/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostingGuestsViewController: UIViewController {
    
    var delegate: handleHostingScroll?
    var allGuestsBool: Bool = false
    var sections = 0
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.register(GuestsTableCell.self, forCellReuseIdentifier: "Cell")
        view.register(GuestsHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 12, right: 0)
    
        return view
    }()
    
    var showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
//        button.setTitle("Show all", for: .normal)
        button.setTitle("You have not had any guests yet", for: .normal)
        button.setTitleColor(Theme.BLACK, for: .normal)
        button.titleLabel?.font = Fonts.SSPRegularH3
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
    }

    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
//        container.addSubview(tableView)
//        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        tableView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 24).isActive = true
//        tableView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        
        container.addSubview(showMoreButton)
        showMoreButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -120).isActive = true
        showMoreButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        showMoreButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        showMoreButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
}

extension HostingGuestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if allGuestsBool == true {
            sections = 0
            return self.sections
        } else {
            sections = 0
            return self.sections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GuestsTableCell
        if indexPath.row == 0 {
            cell.parkingImage = UIImage(named: "background4")
        } else {
            cell.parkingImage = UIImage(named: "background4")
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! GuestsHeaderCell
        if section > 0 {
            headerCell.headerLabelAnchor.constant = 0
        } else {
            headerCell.headerLabelAnchor.constant = (headerCell.headerLabel.text?.width(withConstrainedHeight: 40, font: Fonts.SSPSemiBoldH2))! - 16
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < self.sections - 1 {
            return 40
        } else {
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > self.view.frame.height {
            let translation = scrollView.contentOffset.y
            self.delegate?.animateScroll(translation: translation, active: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.contentOffset.y
        self.delegate?.animateScroll(translation: translation, active: false)
    }
    
}

class GuestsTableCell: UITableViewCell {
    
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
        view.layer.cornerRadius = 25
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
        return view
    }()
    
    var parkingLabel: UILabel = {
        let view = UILabel()
        view.text = "Tyler"
        view.font = Fonts.SSPRegularH3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var secondaryLabel: UILabel = {
        let view = UILabel()
        view.text = "2:15 PM to 4:30 PM"
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
    
    var cellLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.4)
        
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
        addSubview(cellLine)
        
        parkingImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        parkingImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        parkingImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        parkingImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        parkingLabel.topAnchor.constraint(equalTo: parkingImageView.topAnchor).isActive = true
        parkingLabel.leftAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: 12).isActive = true
        parkingLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        parkingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        
        secondaryLabel.bottomAnchor.constraint(equalTo: parkingImageView.bottomAnchor).isActive = true
        secondaryLabel.leftAnchor.constraint(equalTo: parkingImageView.rightAnchor, constant: 12).isActive = true
        secondaryLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        secondaryLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        
        costLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        costLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        costLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 80).isActive = true
        
        cellLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellLine.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        cellLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class GuestsHeaderCell: UITableViewCell {
    
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
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
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
