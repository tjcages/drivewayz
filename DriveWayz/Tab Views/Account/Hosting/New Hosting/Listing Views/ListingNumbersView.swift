//
//  ListingNumbersView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ListingNumbersView: UIViewController {
    
    var delegate: HandleListingDetails?
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Number of spots"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH3
        
        return label
    }()
    
    var mainTextView: UITextView = {
        let view = UITextView()
        view.textColor = Theme.DARK_GRAY
        view.font = Fonts.SSPRegularH2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.keyboardType = .numberPad
        view.tintColor = .clear
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        
        return view
    }()
    
    var textViewLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = lineColor
        
        return view
    }()
    
    lazy var bubbleArrow: BubbleArrow = {
        let view = BubbleArrow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.message = "Please enter how many spots are being listed first."
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.rightTriangle()
        view.horizontalTriangle()
        view.label.font = Fonts.SSPRegularH5
        view.alpha = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        mainTextView.delegate = self

        setupViews()
        createToolbar()
    }
    
    var textViewWidthAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(mainTextView)
        view.addSubview(textViewLine)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        mainTextView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainTextView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        textViewWidthAnchor = mainTextView.widthAnchor.constraint(equalToConstant: 32)
            textViewWidthAnchor.isActive = true
        
        textViewLine.anchor(top: nil, left: mainTextView.leftAnchor, bottom: mainTextView.bottomAnchor, right: mainTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        view.addSubview(bubbleArrow)
        bubbleArrow.leftAnchor.constraint(equalTo: mainTextView.rightAnchor, constant: 32).isActive = true
        bubbleArrow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bubbleArrow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        bubbleArrow.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainTextView.becomeFirstResponder()
    }

}

extension ListingNumbersView: UITextViewDelegate {
    
    // Build the 'Done' button to dismiss keyboard
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = Theme.DARK_GRAY
        toolBar.sizeToFit()
        toolBar.tintColor = Theme.WHITE
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: Fonts.SSPSemiBoldH4], for: UIControl.State.normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        mainTextView.inputAccessoryView = toolBar
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.unselectViews()
        delegate?.selectView(view: view)
        textViewLine.backgroundColor = Theme.BLUE
        if bubbleArrow.alpha == 1 {
            UIView.animate(withDuration: animationIn) {
                self.bubbleArrow.alpha = 0
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.unselectViews()
        textViewLine.backgroundColor = lineColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let width = text.width(withConstrainedHeight: 46, font: Fonts.SSPRegularH2)
            textViewWidthAnchor.constant = width + 24
            delegate?.monitorNumberSpots(text: text)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
