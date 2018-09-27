//
//  NotifyUpcomingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 9/7/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class NotifyUpcomingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        checkForUpcoming()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForUpcoming() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser).child("upcomingParking")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let startTime = dictionary["startTime"] as? TimeInterval
                self.startTimerNotification(startTime: startTime!)
            }
        }
    }
    
    func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in
            //
        }
    }
    
    func startTimerNotification(startTime: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Your parking reservation is ready!"
        content.subtitle = "Open in app for directions."
        content.badge = 0
        content.sound = UNNotificationSound.default()
    
        let currentTime = Date().timeIntervalSince1970
        let seconds = startTime - currentTime
        
        if seconds >= 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("Error sending upcoming notification: ", error!.localizedDescription)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
                self.checkIfTimeStarted(startTime: startTime, seconds: seconds)
            })
        } else {
            self.checkIfTimeStarted(startTime: startTime, seconds: seconds)
        }
    }
    
    func checkIfTimeStarted(startTime: TimeInterval, seconds: TimeInterval) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUser)
        ref.child("upcomingParking").observe(.childAdded) { (snapshot) in
//            if seconds <= 0 {
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let cost = dictionary["cost"] as? Double
                    let hours = dictionary["hours"] as? Int
                    let parkingID = dictionary["parkingID"] as? String
                    
                    ref.child("currentParking").child(parkingID!).updateChildValues(["cost": cost!, "hours": hours!, "parkingID": parkingID!, "timestamp": startTime])
                    ref.child("upcomingParking").removeValue()
                    let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                    parkingRef.child("Upcoming").child(currentUser).removeValue()
                    let currentParkingRef = parkingRef.child("Current")
                    parkingRef.updateChildValues(["previousUser": currentUser, "previousCost": cost!])
                    currentParkingRef.updateChildValues([currentUser: currentUser])
                }
//            }
        }
    }
    

}
