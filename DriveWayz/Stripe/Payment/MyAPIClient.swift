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

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
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
    
    
    
    var checkedCustomerKey: Bool = false

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        if let currentUser = Auth.auth().currentUser?.uid {
            if self.checkedCustomerKey == false {
                self.checkedCustomerKey = true
                let checkRef = Database.database().reference().child("users").child(currentUser)
                checkRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        var email = dictionary["email"] as? String
                        if email == "" {
                            guard let name = dictionary["name"] as? String else { return }
                            email = name
                        }
                        self.account = dictionary["accountID"] as? String
                        
                        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
                        if let emails = email {
                            Alamofire.request(url, method: .post, parameters: [
                                "api_version": "2018-09-24",
                                "email": emails
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
                    }
                }, withCancel: nil)
            }
        }
    }
    
    func createAccountKey(routingNumber: String, accountNumber: String, addressLine1: String, addressCity: String, addressState: String, addressPostalCode: String, firstName: String, lastName: String, ssnLast4: String, email: String, birthDay: String, birthMonth: String, birthYear: String, completion: @escaping(Bool) -> ()) {
        var ipAddress: String = ""
        if let addr = getWiFiAddress() {
            ipAddress = addr
        } else {
            ipAddress = "1.160.10.240"
            print("No WiFi address")
        }

        let url = self.backendURL.appendingPathComponent("account_keys")
        var values = [
            "routingNumber": routingNumber,
            "accountNumber": accountNumber,
            
            "birthDay": birthDay,
            "birthMonth": birthMonth,
            "birthYear": birthYear,
            
            "addressLine1": addressLine1,
            //            "addressLine2": addressLine2,
            "addressCity": addressCity,
            "addressState": addressState,
            "addressPostalCode": addressPostalCode,
            
            "firstName": firstName,
            "lastName": lastName,
            "type": "individual",
            "ssnLast4": ssnLast4,
            
            "ip": ipAddress,
            "api_version": "2018-05-21",
            "email": email,
            //            "phoneNumber": phoneNumber
        ]
        
        Alamofire.request(url, method: .post, parameters: values)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    if let accountNumber = values["accountNumber"], let routingNumber = values["routingNumber"] {
                        let account = String(accountNumber.suffix(4))
                        let routing = String(routingNumber.suffix(4))
                        values["accountNumber"] = account
                        values["routingNumber"] = routing
                        let timestamp = Date().timeIntervalSince1970
                        values["timestamp"] = "\(timestamp)"
                        values["accountID"] = (json as! String)
                        values.removeValue(forKey: "ip")
                        self.updateUserProfile(userAccount: json as! String, values: values)
                    }
                    self.displayAlert(title: "Success!", message: "You have successfully linked up your bank account and can now start transfering money.")
                    completion(true)
                case .failure(let error):
                    self.displayAlert(title: "Error", message: "There was a problem linking up your bank account. Please review your submitted information.")
                    print(error, "failure")
                    completion(false)
                }
        }
    }
    
//    var success: String? = "Success"
//
    func transferToBank(account: String, funds: Double, completion: @escaping(Bool) -> ()) {
        let amount = Double(funds) * 100
//        let amount = Double(funds)
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
                    completion(true)
                case .failure(let error):
                    print(error, "failure")
                    self.displayAlert(title: "Error", message: "There was a problem sending the funds to your account. Please contact Drivewayz to resolve this issue.")
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
    
    private func updateUserProfile(userAccount: String, values: [String: String]) {
        let currentUser = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("users").child(currentUser!)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if (dictionary["Accounts"] as? [String: Any]) != nil {
                    userRef.child("Accounts").updateChildValues(["secondaryAccountID": userAccount])
                    let ref = Database.database().reference().child("PayoutAccounts").child(userAccount)
                    ref.updateChildValues(values)
                } else {
                    userRef.child("Accounts").updateChildValues(["accountID": userAccount])
                    let ref = Database.database().reference().child("PayoutAccounts").child(userAccount)
                    ref.updateChildValues(values)
                }
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        MyAPIClient.showMessage(title: title, msg: message)
    }
    
    static func showMessage(title: String, msg: String) {
        if title == "Success!" {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (success) in
                UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            }))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
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
