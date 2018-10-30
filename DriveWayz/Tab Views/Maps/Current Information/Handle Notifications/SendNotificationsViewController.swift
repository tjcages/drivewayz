//
//  SendNotificationsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 10/8/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
import UserNotifications
import MapboxStatic

class SendNotificationsViewController: UIViewController {
    
    var timestamp: Double?
    var hours: Int?
    var currentParkingID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        checkCurrentParking()
    }
    
    func checkCurrentParking() {
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observe(.childAdded, with: { (snapshot) in
                self.currentParkingID = snapshot.key
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    currentParking = true
                    self.timestamp = dictionary["timestamp"] as? Double
                    self.hours = dictionary["hours"] as? Int
                    if notificationSent == false {
                        self.setupNotifications()
                        notificationSent = true
                    }
                }
            }, withCancel: nil)
            currentRef.observe(.childRemoved, with: { (snapshot) in
                currentParking = false
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                //delete
            }, withCancel: nil)
        } else {
            return
        }
    }
    
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                let endParkingAction = UNNotificationAction(identifier: "endParking", title: "Confirm you have left", options: [])
                let category = UNNotificationCategory(identifier: "actionCategory", actions: [endParkingAction], intentIdentifiers: [], options: [])
                let center = UNUserNotificationCenter.current()
                center.setNotificationCategories([category])
            }
        }
    }
    
    func sendNotifications(location: CLLocation) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let mapboxCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let camera = SnapshotCamera(lookingAtCenter: mapboxCoordinate, zoomLevel: 17.0)
        let options = SnapshotOptions(styleURL: URL(string: "mapbox://styles/tcagle717/cjjnibq7002v22sowhbsqkg22")!, camera: camera, size: CGSize(width: 288, height: 200))
        let markerOverlay = Marker(
            coordinate: mapboxCoordinate,
            size: .small,
            iconName: "car"
        )
        markerOverlay.color = Theme.PACIFIC_BLUE
        options.overlays = [markerOverlay]
        let content = UNMutableNotificationContent()
        let secondContent = UNMutableNotificationContent()
        let thirdContent = UNMutableNotificationContent()
        let fourthContent = UNMutableNotificationContent()
        
        let mapboxAccessToken = "pk.eyJ1IjoidGNhZ2xlNzE3IiwiYSI6ImNqam5pNzBqcDJnaW8zcHQ3eTV5OXVuODcifQ.WssB7L7fBh8YdR4G_K2OsQ"
        let snapshot = Snapshot(options: options, accessToken: mapboxAccessToken)
        let identifier = ProcessInfo.processInfo.globallyUniqueString
        
        if let attachment = UNNotificationAttachment.create(identifier: identifier, image: snapshot.image!, options: nil) {
            content.attachments = [attachment]
        }
        if let secondAttachment = UNNotificationAttachment.create(identifier: identifier, image: snapshot.image!, options: nil) {
            secondContent.attachments = [secondAttachment]
        }
        if let thirdAttachment = UNNotificationAttachment.create(identifier: identifier, image: snapshot.image!, options: nil) {
            thirdContent.attachments = [thirdAttachment]
        }
        
        content.title = "Your current parking spot has expired!"
        content.subtitle = "Please move your vehicle or extend time in app."
        content.body = "Hold down for quick options!"
        content.badge = 0
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "actionCategory"
        
        secondContent.title = "You have overstayed your allotted time!"
        secondContent.body = "Please move your vehicle or you will be charged an extra hour in 15 minutes."
        secondContent.badge = 0
        secondContent.sound = UNNotificationSound.default
        secondContent.categoryIdentifier = "actionCategory"
        
        thirdContent.title = "You have been charged for an extra hour."
        thirdContent.body = "Please move your vehicle or extend time."
        thirdContent.badge = 0
        thirdContent.sound = UNNotificationSound.default
        thirdContent.categoryIdentifier = "actionCategory"
        
        fourthContent.title = "You have 20 minutes left for your parking spot"
        fourthContent.body = "Check in with the app to extend time!"
        fourthContent.badge = 0
        fourthContent.sound = UNNotificationSound.default
        
        let firstSeconds = (self.hours! * 3600) + (10 * 60)
        let secondSeconds = firstSeconds + (15 * 60)
        let thirdSeconds = firstSeconds + (30 * 60)
        let fourthSeconds = firstSeconds - (20 * 60)
        
        if seconds != nil && seconds! >= 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(firstSeconds), repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            let secondTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(secondSeconds), repeats: false)
            let secondRequest = UNNotificationRequest(identifier: "timerDone2", content: secondContent, trigger: secondTrigger)
            let thirdTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(thirdSeconds), repeats: false)
            let thirdRequest = UNNotificationRequest(identifier: "timerDone3", content: thirdContent, trigger: thirdTrigger)
            
            center.add(request) { (error) in
                if error != nil {
                    print("Error sending first notification: ", error!)
                }
            }
            center.add(secondRequest) { (error) in
                if error != nil {
                    print("Error sending second notification: ", error!)
                }
            }
            center.add(thirdRequest) { (error) in
                if error != nil {
                    print("Error sending third notification: ", error!)
                }
            }
            if fourthSeconds > 0 {
                let fourthTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fourthSeconds), repeats: false)
                let fourthRequest = UNNotificationRequest(identifier: "timerDone4", content: fourthContent, trigger: fourthTrigger)
                center.add(fourthRequest) { (error) in
                    if error != nil {
                        print("Error sending fourth notification: ", error!)
                    }
                }
            }
        }
    }

}


extension SendNotificationsViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "endParking":
            print("Action Second Tapped")
            self.endCurrentParking()
        default:
            print("Action Second Tapped")
            self.endCurrentParking()
            break
        }
        completionHandler()
    }
    
    func endCurrentParking() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("currentParking")
        let parkingRef = Database.database().reference().child("parking").child(self.currentParkingID).child("Current").child(currentUser)
        ref.removeValue()
        parkingRef.removeValue()
        
        timerStarted = false
        notificationSent = false
        currentParking = false
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
