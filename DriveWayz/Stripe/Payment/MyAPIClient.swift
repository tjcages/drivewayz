//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import Firebase

class MyAPIClient: NSObject, STPEphemeralKeyProvider {
    
    var account: String?
    var email: String?

    let backendBaseURL: String? = "https://boiling-shore-28466.herokuapp.com"
    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    var backendURL: URL {
        if let urlString = self.backendBaseURL, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    enum RequestRideError: Error {
        case missingBaseURL
        case invalidResponse
    }

    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        let params: [String: Any] = [
            "amount": amount,
            "currency": "USD"
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
    
    enum CustomerKeyError: Error {
        case missingBaseURL
        case invalidResponse
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let email = dictionary["email"] as? String
                    let name = dictionary["name"] as? String
                    self.account = dictionary["accountID"] as? String
            
                    let url = self.baseURL.appendingPathComponent("ephemeral_keys")
                    Alamofire.request(url, method: .post, parameters: [
                        "api_version": "2018-09-24",
                        "email": email!,
                        "description": name!
                        ])
                        .validate(statusCode: 200..<300)
                        .responseJSON { responseJSON in
                            switch responseJSON.result {
                            case .success(let json):
                                completion(json as? [String: AnyObject], nil)
                            case .failure(let error):
                                completion(nil, error)
                            }
                        }
                }
            }, withCancel: nil)
        }
    }
    
    func createAccountKey(routingNumber: String, accountNumber: String, birthDay: String, birthMonth: String, birthYear: String, addressLine1: String, addressLine2: String, addressCity: String, addressState: String, addressPostalCode: String, firstName: String, lastName: String, ssnLast4: String, phoneNumber: String) {
        var ipAddress: String = ""
        if let addr = getWiFiAddress() {
            ipAddress = addr
        } else {
            print("No WiFi address")
        }
        
        let url = self.backendURL.appendingPathComponent("account_keys")
        Alamofire.request(url, method: .post, parameters: [
            "routingNumber": routingNumber,
            "accountNumber": accountNumber,
            
            "birthDay": birthDay,
            "birthMonth": birthMonth,
            "birthYear": birthYear,
            
            "addressLine1": addressLine1,
            "addressLine2": addressLine2,
            "addressCity": addressCity,
            "addressState": addressState,
            "addressPostalCode": addressPostalCode,
            
            "firstName": firstName,
            "lastName": lastName,
            "type": "individual",
            "ssnLast4": ssnLast4,
            
            "ip": ipAddress,
            "api_version": "2018-05-21",
            "email": userEmail!,
            "phoneNumber": phoneNumber
            ])
            
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    self.updateUserProfile(userAccount: json as! String)
                    self.displayAlert(title: "Success!", message: "You have successfully linked up your bank account and can now start accepting payments.")
                case .failure(let error):
                    self.displayAlert(title: "Error", message: "There was a problem linking up your bank account. Please review your submitted information.")
                    print(error, "failure")
                }
        }
    }
    
//    var success: String? = "Success"
//
    func transferToBank(account: String, funds: Double) {
        let amount = Double(funds) * 100
        let url = self.backendURL.appendingPathComponent("transfer")
        Alamofire.request(url, method: .post, parameters: [
            "account": account,
            "currency": "USD",
            "amount": Int(amount)
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print(json)
                    self.setFundsToZero()
                    self.displayAlert(title: "Transfer Complete", message: "The funds have been transfered to your account and should be available within 2-3 days.")
                case .failure(let error):
                    print(error, "failure")
                    self.displayAlert(title: "Error", message: "There was a problem sending the funds to your account.")
                }
        }
    }

    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    private func updateUserProfile(userAccount: String) {
        let currentUser = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("users").child(currentUser!)
        userRef.updateChildValues(["accountID": userAccount])
    }
    
    var count: Int = 0
    private func setFundsToZero() {
        if let currentUser = Auth.auth().currentUser?.uid {
            let checkRef = Database.database().reference().child("users").child(currentUser)
            checkRef.observeSingleEvent(of: .value, with: { (snap) in
                if let dictionary = snap.value as? [String:AnyObject] {
                    if let oldFunds = dictionary["userFunds"] as? Double {
                            checkRef.updateChildValues(["userFunds": 0])
                            checkRef.child("payments").observeSingleEvent(of: .value, with: { (snapshot) in
                                self.count =  Int(snapshot.childrenCount)
                                let payRef = checkRef.child("payments").child("\(self.count)")
                                let timestamp = NSDate().timeIntervalSince1970
                                payRef.updateChildValues(["deposit": oldFunds, "currentFunds": 0, "hours": 0, "timestamp": timestamp])
                            }, withCancel: nil)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func displayAlert(title: String, message: String) {
        MyAPIClient.showMessage(title: title, msg: message)
    }
    
    static func showMessage(title: String, msg: String) {
        if title == "Success!" {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (success) in
                UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            }))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
