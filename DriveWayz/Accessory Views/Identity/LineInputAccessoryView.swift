//
//  LineInputTextView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class LineInputAccessoryView: UIView {
    
    var lineUnselectedColor: UIColor = lineColor
    var lineSelectedColor: UIColor = Theme.BLUE
    
    var textViewFont = Fonts.SSPRegularH3 {
        didSet {
            lineTextView.font = textViewFont
        }
    }
    var textViewText = "" {
        didSet {
            lineTextView.text = textViewText
        }
    }
    var textViewKeyboardType: UIKeyboardType = .numberPad {
        didSet {
            lineTextView.keyboardType = textViewKeyboardType
        }
    }
    var textViewAlignment: NSTextAlignment = .left {
        didSet {
            lineTextView.textAlignment = textViewAlignment
        }
    }
    
    fileprivate let lineSeparatorView = UIView()
    lazy var lineTextView: LineTextView = {
        let view = LineTextView()
        view.font = textViewFont
        view.text = textViewText
        view.keyboardType = textViewKeyboardType
        view.textAlignment = textViewAlignment
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = lineColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextEditing), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextEnd), name: UITextView.textDidEndEditingNotification, object: nil)
        
        addSubview(lineTextView)
        lineTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lineTextView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        lineTextView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        layoutIfNeeded()
        lineTextView.centerVertically()
        
        setupLineSeparatorView()
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupLineSeparatorView() {
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
    }
    
    @objc func handleTextEditing() {
        if lineTextView.isFirstResponder {
            lineSeparatorView.backgroundColor = lineSelectedColor
            backgroundColor = lineSelectedColor.withAlphaComponent(0.1)
        }
    }
    
    @objc func handleTextEnd() {
        lineSeparatorView.backgroundColor = lineUnselectedColor
        backgroundColor = lineColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
