//
//  PriceAdditionalView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class PriceAdditionalView: UIViewController {
    
    var delegate: HostPriceDelegate?
    let informationController = PriceInformationView()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH2
        label.numberOfLines = 5
        label.isUserInteractionEnabled = true
        
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"informationIcon")?.withRenderingMode(.alwaysTemplate)
        //Set bound to reposition
        let imageOffsetY: CGFloat = -2.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add your text to mutable string
        let text = "This price is subject to change based on public parking or events in the area  "
        let textBeforeIcon = NSMutableAttributedString(string: text)
        completeText.append(textBeforeIcon)
        //Add image to mutable string
        completeText.append(attachmentString)
//        completeText.addAttributes([NSAttributedString.Key.font: Fonts.SSPSemiBoldH3], range: NSRange(text)!)
//        completeText.addAttributes([NSAttributedString.Key.foregroundColor: Theme.DARK_GRAY], range: NSRange(text)!)
        
        label.attributedText = completeText
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Standard is comparable to parking rates in your area and typically maximizes the number of bookings."
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 5
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        mainLabel.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.sizeToFit()

        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.leftAnchor.constraint(equalTo: mainLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        
    }

    @objc func tapLabel(tap: UITapGestureRecognizer) {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"informationIcon")?.withRenderingMode(.alwaysTemplate)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        guard let range = mainLabel.text?.range(of: attachmentString.string)?.nsRange else {
            return
        }
        if tap.didTapAttributedTextInLabel(label: mainLabel, inRange: range) {
            // Substring tapped
            informationButtonPressed()
        }
    }
    
    func informationButtonPressed() {
        delegate?.dimBackground()
        informationController.modalPresentationStyle = .overFullScreen
        present(informationController, animated: true, completion: nil)
    }
    
}


