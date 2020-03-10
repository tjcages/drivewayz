//
//  CommentInputTextView.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 1/3/18.
//  Copyright © 2018 Lets Build That App. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Message"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        returnKeyType = .done
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
        
        if text == "\n" {
            dismissKeyboard()
        }
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





