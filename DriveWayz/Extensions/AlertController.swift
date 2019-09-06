//
//  AlertController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/5/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

func pushQuickAlert(title: String, message: String) {
    delayWithSeconds(0.6) {
        if let topController = UIApplication.topViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            topController.present(alert, animated: true) {
                delayWithSeconds(2, completion: {
                    topController.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
}
