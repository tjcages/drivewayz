//
//  LoadingLine.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class LoadingLine: UIView {
    
    var shouldBeLoading: Bool = true
    
    var loadingLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        
        return view
    }()
    
    var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var loadingLineLeftAnchor: NSLayoutConstraint!
    var loadingLineRightAnchor: NSLayoutConstraint!
    var loadingLineWidthAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    func setupViews() {
        
        self.addSubview(bottomLine)
        bottomLine.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(loadingLine)
        loadingLine.topAnchor.constraint(equalTo: bottomLine.topAnchor).isActive = true
        loadingLineLeftAnchor = loadingLine.leftAnchor.constraint(equalTo: bottomLine.leftAnchor)
            loadingLineLeftAnchor.isActive = true
        loadingLineRightAnchor = loadingLine.rightAnchor.constraint(equalTo: bottomLine.rightAnchor)
            loadingLineRightAnchor.isActive = false
        loadingLineWidthAnchor = loadingLine.widthAnchor.constraint(equalToConstant: 0)
            loadingLineWidthAnchor.isActive = true
        loadingLine.bottomAnchor.constraint(equalTo: bottomLine.bottomAnchor).isActive = true
        
    }
    
    func startAnimating() {
        if self.shouldBeLoading {
            self.loadingLine.alpha = 1
            self.loadingLineLeftAnchor.isActive = true
            self.loadingLineRightAnchor.isActive = false
            self.loadingLineWidthAnchor.constant = 0
            self.layoutIfNeeded()
            
            self.loadingLineLeftAnchor.isActive = true
            self.loadingLineRightAnchor.isActive = false
            self.loadingLineWidthAnchor.constant = phoneWidth/3
            UIView.animate(withDuration: animationOut * 2, animations: {
                self.layoutIfNeeded()
            }) { (success) in
                self.loadingLineLeftAnchor.isActive = false
                self.loadingLineRightAnchor.isActive = true
                self.loadingLineWidthAnchor.constant = phoneWidth/3
                UIView.animate(withDuration: animationOut * 1, animations: {
                    self.layoutIfNeeded()
                }) { (success) in
                    self.loadingLineLeftAnchor.isActive = false
                    self.loadingLineRightAnchor.isActive = true
                    self.loadingLineWidthAnchor.constant = 0
                    UIView.animate(withDuration: animationOut, animations: {
                        self.layoutIfNeeded()
                    }) { (success) in
                        self.startAnimating()
                    }
                }
            }
        } else {
            self.loadingLine.alpha = 0
            self.loadingLineLeftAnchor.isActive = true
            self.loadingLineRightAnchor.isActive = false
            self.loadingLineWidthAnchor.constant = 0
        }
    }
    
    func endAnimating() {
        self.shouldBeLoading = false
        delayWithSeconds(2) {
            self.shouldBeLoading = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}


extension UIView {
    
    func startSmartShining() {
        ABLoader().startSmartShining(self)
    }
    
    func stopShining() {
        ABLoader().stopSmartShining(self)
    }
    
}

