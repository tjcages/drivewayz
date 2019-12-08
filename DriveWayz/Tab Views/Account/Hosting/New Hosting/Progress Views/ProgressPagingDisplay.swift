//
//  ProgressPagingDisplay.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/11/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProgressPagingDisplay: UIView {
    
    let dimAlpha: CGFloat = 0.2

    var firstSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    var secondSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.alpha = 0.2
        
        return view
    }()
    
    var thirdSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.alpha = 0.2
        
        return view
    }()
    
    var fourthSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.alpha = 0.2
        
        return view
    }()
    
    var fifthSelectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 4
        view.alpha = 0.2
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    var firstWidth: NSLayoutConstraint!
    var secondWidth: NSLayoutConstraint!
    var thirdWidth: NSLayoutConstraint!
    var fourthWidth: NSLayoutConstraint!
    var fifthWidth: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(firstSelectionLine)
        addSubview(secondSelectionLine)
        addSubview(thirdSelectionLine)
        addSubview(fourthSelectionLine)
        addSubview(fifthSelectionLine)
        
        firstSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        firstSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        firstSelectionLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        firstWidth = firstSelectionLine.widthAnchor.constraint(equalToConstant: 20)
            firstWidth.isActive = true
        
        secondSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        secondSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        secondSelectionLine.leftAnchor.constraint(equalTo: firstSelectionLine.rightAnchor, constant: 6.5).isActive = true
        secondWidth = secondSelectionLine.widthAnchor.constraint(equalToConstant: 10)
            secondWidth.isActive = true
        
        thirdSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        thirdSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        thirdSelectionLine.leftAnchor.constraint(equalTo: secondSelectionLine.rightAnchor, constant: 6.5).isActive = true
        thirdWidth = thirdSelectionLine.widthAnchor.constraint(equalToConstant: 10)
            thirdWidth.isActive = true
        
        fourthSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        fourthSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        fourthSelectionLine.leftAnchor.constraint(equalTo: thirdSelectionLine.rightAnchor, constant: 6.5).isActive = true
        fourthWidth = fourthSelectionLine.widthAnchor.constraint(equalToConstant: 10)
            fourthWidth.isActive = true
        
        fifthSelectionLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        fifthSelectionLine.heightAnchor.constraint(equalToConstant: 8).isActive = true
        fifthSelectionLine.leftAnchor.constraint(equalTo: fourthSelectionLine.rightAnchor, constant: 6.5).isActive = true
        fifthWidth = fifthSelectionLine.widthAnchor.constraint(equalToConstant: 10)
            fifthWidth.isActive = true
        
    }
    
    func testProgress() {
        changeProgress(index: 0)
        delayWithSeconds(2) {
            self.changeProgress(index: 1)
            delayWithSeconds(2) {
                self.changeProgress(index: 2)
                delayWithSeconds(2) {
                    self.changeProgress(index: 3)
                    delayWithSeconds(2) {
                        self.changeProgress(index: 4)
                    }
                }
            }
        }
    }
    
    func changeProgress(index: Int) {
        minimizeAll()
        UIView.animate(withDuration: animationOut, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if index == 0 {
                self.firstWidth.constant = 20
                self.expandView(view: self.firstSelectionLine)
                self.minimizeView(view: self.secondSelectionLine)
                self.minimizeView(view: self.thirdSelectionLine)
                self.minimizeView(view: self.fourthSelectionLine)
                self.minimizeView(view: self.fifthSelectionLine)
            } else if index == 1 {
                self.secondWidth.constant = 20
                self.minimizeView(view: self.firstSelectionLine)
                self.expandView(view: self.secondSelectionLine)
                self.minimizeView(view: self.thirdSelectionLine)
                self.minimizeView(view: self.fourthSelectionLine)
                self.minimizeView(view: self.fifthSelectionLine)
            } else if index == 2 {
                self.thirdWidth.constant = 20
                self.minimizeView(view: self.firstSelectionLine)
                self.minimizeView(view: self.secondSelectionLine)
                self.expandView(view: self.thirdSelectionLine)
                self.minimizeView(view: self.fourthSelectionLine)
                self.minimizeView(view: self.fifthSelectionLine)
            } else if index == 3 {
                self.fourthWidth.constant = 20
                self.minimizeView(view: self.firstSelectionLine)
                self.minimizeView(view: self.secondSelectionLine)
                self.minimizeView(view: self.thirdSelectionLine)
                self.expandView(view: self.fourthSelectionLine)
                self.minimizeView(view: self.fifthSelectionLine)
            } else if index == 4 {
                self.fifthWidth.constant = 20
                self.minimizeView(view: self.firstSelectionLine)
                self.minimizeView(view: self.secondSelectionLine)
                self.minimizeView(view: self.thirdSelectionLine)
                self.minimizeView(view: self.fourthSelectionLine)
                self.expandView(view: self.fifthSelectionLine)
            }
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func expandView(view: UIView) {
        view.alpha = 1
        view.backgroundColor = Theme.BLUE
    }
    
    func minimizeView(view: UIView) {
        view.alpha = dimAlpha
        view.backgroundColor = Theme.WHITE
    }
    
    func minimizeAll() {
        firstWidth.constant = 10
        secondWidth.constant = 10
        thirdWidth.constant = 10
        fourthWidth.constant = 10
        fifthWidth.constant = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

