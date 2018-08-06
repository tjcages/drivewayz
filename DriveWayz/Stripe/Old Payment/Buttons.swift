//
//  Buttons.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/25/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import UIKit
import Stripe

class HighlightingButton: UIButton {
    var highlightColor = UIColor(white: 0, alpha: 0.05)

    convenience init(highlightColor: UIColor) {
        self.init()
        self.highlightColor = highlightColor
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = self.highlightColor
            } else {
                self.backgroundColor = UIColor.clear
            }
        }
    }
}

class ReservationButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("Reserve Spot", for: .normal)
        self.setTitle("", for: .selected)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.backgroundColor = UIColor.clear
        self.alpha = 0.5
        self.translatesAutoresizingMaskIntoConstraints = false
        //        button(self, action: #selector(saveReservationButtonPressed(sender:)), for: .touchUpInside)
        self.setTitleColor(Theme.DARK_GRAY, for: .normal)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PaymentButton: UIButton  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("Payment", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.backgroundColor = UIColor.clear
        self.alpha = 0.5
        self.translatesAutoresizingMaskIntoConstraints = false
        //        button(self, action: #selector(saveReservationButtonPressed(sender:)), for: .touchUpInside)
        self.setTitleColor(Theme.DARK_GRAY, for: .normal)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BuyButton: HighlightingButton {
    var disabledColor = UIColor.lightGray
    var enabledColor = Theme.PRIMARY_COLOR

    override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? enabledColor : disabledColor
            self.setTitleColor(color, for: UIControlState())
            self.layer.borderColor = color.cgColor
            self.highlightColor = color.withAlphaComponent(0.5)
        }
    }

    convenience init(enabled: Bool, theme: STPTheme) {
        self.init()
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.setTitle("Buy", for: UIControlState())
        self.disabledColor = theme.secondaryForegroundColor
        self.enabledColor = Theme.PRIMARY_COLOR
        self.isEnabled = enabled
    }
}