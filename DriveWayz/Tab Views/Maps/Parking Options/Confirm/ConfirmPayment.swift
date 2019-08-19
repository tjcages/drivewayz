//
//  ConfirmPayment.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Stripe

extension ConfirmViewController: STPPaymentContextDelegate {
    
    @objc func confirmPurchasePressed(sender: UIButton) {
//        self.paymentInProgress = true
//        self.paymentContext.requestPayment()
        
        self.paymentInProgress = true /////////////////////////////////////PAYMENT NOT SETUP
        self.setupNotifications()
        delayWithSeconds(2) {
            self.paymentInProgress = false
        }
    }
    
//    func sendPushNotification() {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        if let parkingUserID = parking?.id, let type = parking?.mainType {
//            let ref = Database.database().reference().child("users").child(userID)
//            ref.observeSingleEvent(of: .value) { (snapshot) in
//                if let dictionary = snapshot.value as? [String: Any] {
//                    guard let name = dictionary["name"] as? String else { return }
//                    let nameArray = name.split(separator: " ")
//                    if let firstName = nameArray.first {
//                        let title = "\(String(firstName)) has parked in your \(type) parking space"
//                        let subtitle = "Open to see more details"
//
//                        let sender = PushNotificationSender()
//                        sender.sendPushNotification(toUser: parkingUserID, title: title, subtitle: subtitle)
//                    }
//                }
//            }
//        }
//    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Reload related components
        reloadPaymentButtonContent()
        reloadRequestRideButton()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        guard let text = self.totalCostLabel.text?.replacingOccurrences(of: "$", with: "") else { return }
        guard let costs = Double(text) else { return }
//        let pennies = 50
        let pennies = Int(costs * 100)
        paymentContext.paymentAmount = pennies
        MyAPIClient.sharedClient.completeCharge(paymentResult,
                                                amount: pennies,
                                                completion: completion)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        switch status {
        case .error:
            print(error?.localizedDescription as Any)
            self.sendAlert(title: "Error", message: "The payment could not be proccessed. Please try again later.")
        case .success:
            self.setupNotifications()
        case .userCancellation:
            return
        }
    }
    
    @objc func handlePaymentButtonTapped() {
        self.paymentContext.presentPaymentOptionsViewController()
    }
    
    func reloadPaymentButtonContent() {
        guard let selectedPaymentMethod = paymentContext.selectedPaymentOption else {
            // Show default image, text, and color
            //            paymentButton.setImage(#imageLiteral(resourceName: "Payment"), for: .normal)
            userInformationNumbers = "No payment linked"
            userInformationImage = UIImage()
            paymentButton.setTitle("Payment", for: .normal)
            paymentButton.setTitleColor(Theme.BLUE, for: .normal)
            return
        }
        
        // Show selected payment method image, label, and darker color
        userInformationNumbers = selectedPaymentMethod.label
        userInformationImage = selectedPaymentMethod.image
        paymentButton.setImage(selectedPaymentMethod.image, for: .normal)
        paymentButton.setTitle(selectedPaymentMethod.label, for: .normal)
        paymentButton.setTitleColor(Theme.BLACK, for: .normal)
    }
    
    func reloadRequestRideButton() {
        // Show disabled state
        mainButton.backgroundColor = Theme.DARK_GRAY
        self.mainButton.setTitle("Purchase Spot", for: .normal)
        mainButton.setTitleColor(.white, for: .normal)
        //        requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
        mainButton.isEnabled = false
        
        switch rideRequestState {
        case .none:
            // Show enabled state
            mainButton.backgroundColor = Theme.STRAWBERRY_PINK
            self.mainButton.setTitle("Purchase Spot", for: .normal)
            mainButton.setTitleColor(.white, for: .normal)
            //            requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            mainButton.isEnabled = true
        case .requesting:
            // Show loading state
            mainButton.backgroundColor = Theme.DARK_GRAY
            mainButton.setTitle("···", for: .normal)
            mainButton.setTitleColor(.white, for: .normal)
            mainButton.setImage(nil, for: .normal)
            mainButton.isEnabled = false
        case .active:
            // Show completion state
            mainButton.backgroundColor = .white
            mainButton.setTitle("Working", for: .normal)
            mainButton.setTitleColor(Theme.PACIFIC_BLUE, for: .normal)
            mainButton.setImage(nil, for: .normal)
            mainButton.isEnabled = true
        }
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
