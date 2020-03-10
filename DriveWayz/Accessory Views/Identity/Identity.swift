//
//  Identity.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

final class IdentityButton: UIButton {
    
    var lineHeight: CGFloat = 2.0
    var unselectedLineColor = Theme.LINE_GRAY
    var selectedLineColor = Theme.BLUE
    
    var unselectedBackgroundColor = Theme.BACKGROUND_GRAY
    var selectedBackgroundColor = Theme.BLUE.withAlphaComponent(0.1)
    
    var selectedButton: Bool = false {
        didSet {
            if self.selectedButton {
                isSelected()
            } else {
                isUnselected()
            }
        }
    }
    
    lazy var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = unselectedLineColor
        
        return view
    }()
    
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = unselectedBackgroundColor
        setTitleColor(Theme.BLACK, for: .normal)
        titleLabel?.font = Fonts.SSPSemiBoldH3
        isSelected = false
        
        addSubview(line)
        line.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: lineHeight)
    }
    
    func isSelected() {
        backgroundColor = selectedBackgroundColor
        line.backgroundColor = selectedLineColor
    }
    
    func isUnselected() {
        backgroundColor = unselectedBackgroundColor
        line.backgroundColor = unselectedLineColor
    }
}
