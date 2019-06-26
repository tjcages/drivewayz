//
//  MBPushNotifications.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import FirebaseDatabase
import Alamofire
import SwiftyJSON

class PushNotificationSender {
    
    func sendPushNotification(toUser: String, title: String, subtitle: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(toUser)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                guard let toDeviceID = dictionary["DeviceID"] as? String else { return }
                self.setupPushNotifications(fromDeviceID: AppDelegate.DEVICEID, toDeviceID: toDeviceID, toUserID: toUser, fromUserID: userID, title: title, subtitle: subtitle)
            }
        }
    }
    
    fileprivate func setupPushNotifications(fromDeviceID: String, toDeviceID: String, toUserID: String, fromUserID: String, title: String, subtitle: String) {
        var headers: HTTPHeaders = HTTPHeaders()

        headers = ["Content-Type": "application/json", "Authorization": "key=\(AppDelegate.SERVERKEY)"]
        let notification = ["to": "\(toDeviceID)", "notification": ["body": subtitle, "title": title, "badge": 1, "sound": "default"]] as [String:Any]

        Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            if let err = response.error {
                print(err.localizedDescription, "Error sending Push Notification")
            }
            let pushRef = Database.database().reference().child("PushNotifications").child(toUserID).childByAutoId()
            pushRef.updateChildValues(["fromDeviceID": AppDelegate.DEVICEID, "toDeviceID": toDeviceID, "toUserID": toUserID, "fromUserID": fromUserID, "title": title, "subtitle": subtitle])
        }
    }
    
}

//someone has booked a spot
//someone has left a spot
//someone has extended their duration
//someone has exceeded their stay
//there is a problem with the parking space
//host gets a notification
//someone reserves a parking space
//monthly notifications for hosts
//host hasn't checked in in two months
//someone leaves a review
//host has listed a space

