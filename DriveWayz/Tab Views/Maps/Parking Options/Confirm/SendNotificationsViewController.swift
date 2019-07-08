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

extension ConfirmViewController: UNUserNotificationCenterDelegate {
    
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                let alert = UIAlertController(title: "Notifications are currently disabled.", message: "Please allow notifications to know when your parking duration has ended or you will be charged an overstay fee.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true)
            } else {
                center.getNotificationSettings { (settings) in
                    if settings.authorizationStatus != .authorized {
                        let alert = UIAlertController(title: "Notifications are currently disabled.", message: "Please allow notifications to know when your parking duration has ended or you will be charged an overstay fee.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                        self.present(alert, animated: true)
                    } else {
                        let endParkingAction = UNNotificationAction(identifier: "endParking", title: "Confirm you have left", options: [])
                        let category = UNNotificationCategory(identifier: "actionCategory", actions: [endParkingAction], intentIdentifiers: [], options: [])
                        let center = UNUserNotificationCenter.current()
                        center.setNotificationCategories([category])
                        DispatchQueue.main.async {
                            self.postToDatabase()
                        }
                    }
                }
            }
        }
    }
    
    func sendNotifications(latitude: CLLocationDegrees, longitude: CLLocationDegrees, seconds: TimeInterval) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
        center.removeAllDeliveredNotifications()
        
        let mapboxCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = SnapshotCamera(lookingAtCenter: mapboxCoordinate, zoomLevel: 15.0)
        let options = SnapshotOptions(styleURL: URL(string: "mapbox://styles/tcagle717/cjjnibq7002v22sowhbsqkg22")!, camera: camera, size: CGSize(width: 288, height: 200))
        let markerOverlay = Marker(
            coordinate: mapboxCoordinate,
            size: .small,
            iconName: "home"
        )
        markerOverlay.color = Theme.BLUE
        options.overlays = [markerOverlay]
        
        let firstContent = UNMutableNotificationContent()
        let secondContent = UNMutableNotificationContent()
        let thirdContent = UNMutableNotificationContent()
        let fourthContent = UNMutableNotificationContent()
        let fifthContent = UNMutableNotificationContent()
        let sixthContent = UNMutableNotificationContent()
        
        let mapboxAccessToken = "pk.eyJ1IjoidGNhZ2xlNzE3IiwiYSI6ImNqam5pNzBqcDJnaW8zcHQ3eTV5OXVuODcifQ.WssB7L7fBh8YdR4G_K2OsQ"
        let snapshot = Snapshot(options: options, accessToken: mapboxAccessToken)
        var startIndex: Int = 0
        if seconds < 15 * 60 && seconds >= 0 { //under 15 minutes
            startIndex = 1
        } else if seconds <= 0 {
            self.sendLateNotification()
            return
        } else {
            startIndex = 0
        }
        for index in startIndex...5 {
            if index == 0 {
                let endingSeconds = seconds - (15 * 60)
                
                firstContent.title = "You have 15 minutes left for your parking space"
                firstContent.body = "Please move your vehicle soon or extend time in app"
                firstContent.badge = 0
                firstContent.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(endingSeconds), repeats: false)
                let request = UNNotificationRequest(identifier: "firstNotificationIdentifier", content: firstContent, trigger: trigger)
                center.add(request) { (error) in
                    if error != nil {
                        print("Error sending first notification: ", error!)
                    }
                }
            } else if index == 1 {
                let endingSeconds = seconds
                if let attachment = UNNotificationAttachment.create(identifier: "secondNotificationIdentifier", image: snapshot.image!, options: nil) {
                    secondContent.attachments = [attachment]
                    secondContent.title = "Your current parking spot has expired!"
                    secondContent.subtitle = "Please move your vehicle or extend time in app"
                    secondContent.body = "Hold down for quick options"
                    secondContent.badge = 1
                    secondContent.sound = UNNotificationSound.default
                    secondContent.categoryIdentifier = "actionCategory"
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(endingSeconds), repeats: false)
                    let request = UNNotificationRequest(identifier: "secondNotificationIdentifier", content: secondContent, trigger: trigger)
                    center.add(request) { (error) in
                        if error != nil {
                            print("Error sending second notification: ", error!)
                        }
                    }
                }
            } else if index == 2 {
                let endingSeconds = seconds + (5 * 60)
                if let attachment = UNNotificationAttachment.create(identifier: "thirdNotificationIdentifier", image: snapshot.image!, options: nil) {
                    thirdContent.attachments = [attachment]
                    thirdContent.title = "You have overstayed your allotted time"
                    thirdContent.subtitle = "Please move your vehicle or the rate will double"
                    thirdContent.body = "Hold down for quick options"
                    thirdContent.badge = 0
                    thirdContent.sound = UNNotificationSound.default
                    thirdContent.categoryIdentifier = "actionCategory"
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(endingSeconds), repeats: false)
                    let request = UNNotificationRequest(identifier: "thirdNotificationIdentifier", content: thirdContent, trigger: trigger)
                    center.add(request) { (error) in
                        if error != nil {
                            print("Error sending third notification: ", error!)
                        }
                    }
                }
            } else if index == 3 {
                let endingSeconds = seconds + (15 * 60)
                if let attachment = UNNotificationAttachment.create(identifier: "fourthNotificationIdentifier", image: snapshot.image!, options: nil) {
                    fourthContent.attachments = [attachment]
                    fourthContent.title = "The overstay rate has begun"
                    fourthContent.body = "Please move your vehicle or extend time in app"
                    fourthContent.badge = 0
                    fourthContent.sound = UNNotificationSound.default
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(endingSeconds), repeats: false)
                    let request = UNNotificationRequest(identifier: "fourthNotificationIdentifier", content: fourthContent, trigger: trigger)
                    center.add(request) { (error) in
                        if error != nil {
                            print("Error sending fourth notification: ", error!)
                        }
                    }
                }
            } else if index == 4 {
                let endingSeconds = seconds + (60 * 60)
                if let attachment = UNNotificationAttachment.create(identifier: "fifthNotificationIdentifier", image: snapshot.image!, options: nil) {
                    fifthContent.attachments = [attachment]
                    fifthContent.title = "You have overstayed your spot by an hour"
                    fifthContent.body = "The host has been contacted and may decide to remove your vehicle"
                    fifthContent.badge = 0
                    fifthContent.sound = UNNotificationSound.default
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(endingSeconds), repeats: false)
                    let request = UNNotificationRequest(identifier: "fifthNotificationIdentifier", content: fifthContent, trigger: trigger)
                    center.add(request) { (error) in
                        if error != nil {
                            print("Error sending fifth notification: ", error!)
                        }
                    }
                }
            } else if index == 5 {
                let endingSeconds = seconds + (120 * 60)
                if let attachment = UNNotificationAttachment.create(identifier: "sixthNotificationIdentifier", image: snapshot.image!, options: nil) {
                    sixthContent.attachments = [attachment]
                    sixthContent.title = "You have overstayed your spot by two hours"
                    sixthContent.body = "The host has been contacted and may decide to remove your vehicle"
                    sixthContent.badge = 0
                    sixthContent.sound = UNNotificationSound.default
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(endingSeconds), repeats: false)
                    let request = UNNotificationRequest(identifier: "sixthNotificationIdentifier", content: sixthContent, trigger: trigger)
                    center.add(request) { (error) in
                        if error != nil {
                            print("Error sending sixth notification: ", error!)
                        }
                    }
                }
            }
        }
        print("successfully sent notifications")
//        let identifier = ProcessInfo.processInfo.globallyUniqueString
    }

    func sendLateNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let endingSeconds = (15 * 60)
        
        let firstContent = UNMutableNotificationContent()
        firstContent.title = "You have overstayed your reservation by 15 minutes"
        firstContent.body = "Please move your vehicle soon or extend time in app"
        firstContent.badge = 0
        firstContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(endingSeconds), repeats: false)
        let request = UNNotificationRequest(identifier: "extraNotificationIdentifier", content: firstContent, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error sending extra notification: ", error!)
            }
        }
    }
    
}


extension ConfirmViewController {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "endParking":
            print("Action Second Tapped")
//            self.endCurrentParking()
        default:
            print("Action Second Tapped")
//            self.endCurrentParking()
            break
        }
        completionHandler()
    }
    
    func endCurrentParking() {
//        guard let currentUser = Auth.auth().currentUser?.uid else {return}
//        let ref = Database.database().reference().child("users").child(currentUser).child("currentParking")
//        let parkingRef = Database.database().reference().child("parking").child(self.currentParkingID).child("Current").child(currentUser)
//        ref.removeValue()
//        parkingRef.removeValue()
//
//        timerStarted = false
//        notificationSent = false
//        currentParking = false
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
