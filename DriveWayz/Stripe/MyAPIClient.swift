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

    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        email: String,
//                        shippingAddress: STPAddress?,
//                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        let params: [String: Any] = [
            "amount": amount,
            "email": email,
            "currency": "USD"
        ]
//        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
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

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            "email": userEmail!,
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
    
    func createAccountKey() {
        var ipAddress: String = ""
        if let addr = getWiFiAddress() {
            ipAddress = addr
        } else {
            print("No WiFi address")
        }
        
        let url = self.backendURL.appendingPathComponent("account_keys")
        Alamofire.request(url, method: .post, parameters: [
            "routingNumber": "110000000",
            "accountNumber": "000123456789",
            
            "birthDay": 02,
            "birthMonth": 06,
            "birthYear": 1997,
            
            "addressLine1": "9670 Red Oakes pl.",
            "addressLine2": "",
            "addressCity": "Highlands Ranch",
            "addressState": "CO",
            "addressPostalCode": "80126",
            
            "firstName": "Allison",
            "lastName": "MacMillan",
            "type": "individual",
            "ssnLast4": 5678,
            
            "ip": ipAddress,
            "api_version": "2015-10-12",
            "email": userEmail!,
            "phoneNumber": "3033033033"
            ])
            
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    self.updateUserProfile(userAccount: json as! String)
                case .failure(let error):
                    print(error, "failure")
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

}
