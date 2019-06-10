//
//  QuickHostViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 5/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class QuickHostViewController: UIViewController {
    
    var delegate: handleInviteControllers?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.layer.cornerRadius = 8
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
        
        setupViews()
    }
    
    func setupViews() {
        
        
        
    }
    
    func openController() {
        UIView.animate(withDuration: animationIn, animations: {
            self.view.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func closeController() {
        UIView.animate(withDuration: animationIn, animations: {
            
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: animationIn) {
                self.view.alpha = 0
            }
        }
    }
    
}
