//
//  LineInputTextView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/13/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class LineInputAccessoryView: UIView {
    
    var lineUnselectedColor: UIColor = Theme.BACKGROUND_GRAY
    var lineSelectedColor: UIColor = Theme.BLUE
    
    var backgroundUnselectedColor: UIColor = Theme.LINE_GRAY
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 4
        let origImage = UIImage(named: "exit")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.isHidden = true
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        return button
    }()
    
    var textViewFont = Fonts.SSPRegularH3 {
        didSet {
            lineTextView?.font = textViewFont
        }
    }
    var textViewText = "" {
        didSet {
            lineTextView?.text = textViewText
        }
    }
    var textViewKeyboardType: UIKeyboardType = .numberPad {
        didSet {
            lineTextView?.keyboardType = textViewKeyboardType
        }
    }
    var textViewAutcapitalizationType: UITextAutocapitalizationType = .sentences {
        didSet {
            lineTextView?.autocapitalizationType = textViewAutcapitalizationType
        }
    }
    var textViewAlignment: NSTextAlignment = .left {
        didSet {
            lineTextView?.textAlignment = textViewAlignment
        }
    }
    
    let lineSeparatorView = UIView()
    var lineTextView: LineTextView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = backgroundUnselectedColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextEditing), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextEnd), name: UITextView.textDidEndEditingNotification, object: nil)
        
        lineTextView = LineTextView()
        lineTextView?.font = textViewFont
        lineTextView?.text = textViewText
        lineTextView?.keyboardType = textViewKeyboardType
        lineTextView?.textAlignment = textViewAlignment
        
        addSubview(lineTextView!)
        lineTextView?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lineTextView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lineTextView?.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        lineTextView?.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(deleteButton)
        deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        //        deleteButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor).isActive = true

        layoutIfNeeded()
        lineTextView?.centerVertically()
        
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
        if lineTextView != nil {
            if lineTextView!.isFirstResponder {
                lineSeparatorView.backgroundColor = lineSelectedColor
                backgroundColor = lineSelectedColor.withAlphaComponent(0.1)
            }
        }
    }
    
    @objc func handleTextChange() {
        if let textView = lineTextView {
            deleteButton.isHidden = textView.text.isEmpty
        } else {
            deleteButton.isHidden = true
        }
    }
    
    @objc func deletePressed() {
        lineTextView?.text = nil
        lineTextView?.showPlaceholderLabel()
        deleteButton.isHidden = true
    }
    
    func clearCommentTextField() {
        deletePressed()
        endEditing(true)
    }
    
    @objc func handleTextEnd() {
        lineSeparatorView.backgroundColor = lineUnselectedColor
        backgroundColor = backgroundUnselectedColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
