//
//  FiveStarRating.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

let kSpacing: Int = 0
let kStarSize: CGFloat = 44

class FiveStarRating: UIStackView {

    private var ratingButtons = [UIButton]()
    var rating: Int = 5 {
        didSet {
            updateButtonStates()
        }
    }
    var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        spacing = CGFloat(kSpacing)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for _ in 0..<starCount {
            let button = UIButton()
            button.backgroundColor = Theme.PRIMARY_COLOR
            
            button.setImage(#imageLiteral(resourceName: "Star Empty"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "Star Filled"), for: .highlighted)
            button.setImage(#imageLiteral(resourceName: "Star Filled"), for: [.highlighted, .selected])
            button.setImage(#imageLiteral(resourceName: "Star Filled"), for: .selected)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: kStarSize).isActive = true
            button.widthAnchor.constraint(equalToConstant: kStarSize).isActive = true
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        updateButtonStates()
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("Button is not in the array.")
        }
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        print(selectedRating)
    }
    
    func updateButtonStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
}
