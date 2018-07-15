//
//  CurrentParkingViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/13/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

var timerStarted: Bool = false
var currentParking: Bool = false
var notificationSent: Bool = false

class CurrentParkingViewController: UIViewController, UIScrollViewDelegate {
    
    var timestamp: Double?
    var hours: Int?
    var timerTest : Timer?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    var parkingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        
        return imageView
    }()
    
    var parkingAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.textAlignment = .center
        
        return label
    }()
    
    var complete: UIButton = {
        let complete = UIButton()
        complete.translatesAutoresizingMaskIntoConstraints = false
        complete.setTitle("Leave parking spot", for: .normal)
        complete.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        complete.backgroundColor = UIColor.clear
        complete.layer.borderColor = Theme.PRIMARY_DARK_COLOR.cgColor
        complete.layer.borderWidth = 1
        complete.layer.cornerRadius = 10
        complete.addTarget(self, action: #selector(endParking(sender:)), for: .touchUpInside)
        
        return complete
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.DARK_GRAY
        self.scrollView.delegate = self
        UNUserNotificationCenter.current().delegate = self

        setupViews()
        checkCurrentParking()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width - 40, height: self.view.frame.height)
        scrollView.topAnchor.constraint(equalTo: container.topAnchor, constant: 40).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -40).isActive = true
        scrollView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        scrollView.addSubview(parkingImage)
        parkingImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        parkingImage.centerXAnchor.constraint(lessThanOrEqualTo: scrollView.centerXAnchor).isActive = true
        parkingImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        parkingImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        scrollView.addSubview(parkingAddress)
        parkingAddress.topAnchor.constraint(equalTo: parkingImage.bottomAnchor, constant: 5).isActive = true
        parkingAddress.centerXAnchor.constraint(equalTo: parkingImage.centerXAnchor).isActive = true
        parkingAddress.widthAnchor.constraint(equalTo: parkingImage.widthAnchor).isActive = true
        parkingAddress.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(complete)
        complete.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        complete.bottomAnchor.constraint(equalTo: parkingAddress.bottomAnchor, constant: 20).isActive = true
        complete.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -80).isActive = true
        complete.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func checkCurrentParking() {
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    currentParking = true
                    let parkingID = dictionary["parkingID"] as? String
                    self.timestamp = dictionary["timestamp"] as? Double
                    self.hours = dictionary["hours"] as? Int
                    
                    if timerStarted == false {
                        timerStarted = true
                        self.startTiming()
                    }
                    if notificationSent == false {
                        notificationSent = true
                        self.startTimerNotification()
                    }
                    
                    let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                    parkingRef.observeSingleEvent(of: .value, with: { (pull) in
                        if let pullRef = pull.value as? [String:AnyObject] {
                            let address = pullRef["parkingAddress"] as? String
                            let parkingImageURL = pullRef["parkingImageURL"] as? String
                            
                            if address != "" {
                                self.parkingAddress.text = address
                            }
                            if parkingImageURL == "" {
                                self.parkingImage.image = UIImage(named: "profileprofile")
                            } else {
                                self.parkingImage.loadImageUsingCacheWithUrlString(parkingImageURL!)
                            }
                            
                        }
                    })
                }
            }, withCancel: nil)
            currentRef.observe(.childRemoved, with: { (snapshot) in
                //delete
            }, withCancel: nil)
        } else {
            return
        }
    }
    
    func restartDatabaseTimer() {
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let key = dictionary.keys
                    let stampRef = Database.database().reference().child("users").child(userID).child("currentParking").child(key.first!)
                    stampRef.observeSingleEvent(of: .value, with: { (check) in
                        if let stamp = check.value as? [String:AnyObject] {
                            currentParking = true
                            print(stamp)
                            let refreshTimestamp = stamp["timestamp"] as? Double
                            let refreshHours = stamp["hours"] as? Int
                            if timerStarted == false {
                                timerStarted = true
                                if currentParking == true {
                                    let currentTimestamp = NSDate().timeIntervalSince1970
                                    let seconds = (Int((refreshTimestamp?.rounded())!) + (refreshHours! * 3600)) - Int(currentTimestamp.rounded())
                                    
                                    if seconds >= 0 {
                                        if self.timerTest == nil {
                                            self.timerTest =  Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(self.endParkingFunc), userInfo: nil, repeats: false)
                                            RunLoop.main.add(self.timerTest!, forMode: RunLoopMode.commonModes)
                                        }
                                    } else {
                                        self.endParkingFunc()
                                    }
                                }
                            }
                        }
                    }, withCancel: nil)
                }
            }
        }
    }
    
    @objc func endParking(sender: UIButton) {
        endParkingFunc()
    }
    
    func startTiming() {
        if currentParking == true {
            let currentTimestamp = NSDate().timeIntervalSince1970
            let seconds = (Int((timestamp?.rounded())!) + (hours! * 3600)) - Int(currentTimestamp.rounded())
            
            print(seconds)
            
            if seconds >= 0 {
                if timerTest == nil {
                    timerTest =  Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(endParkingFunc), userInfo: nil, repeats: false)
                    RunLoop.main.add(timerTest!, forMode: RunLoopMode.commonModes)
                }
            } else {
                endParkingFunc()
            }
        }
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest?.invalidate()
            timerTest = nil
            timerStarted = false
        }
    }
    
    func startTimerNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Your time is up!"
        content.subtitle = "Your current parking spot is done"
        content.body = "Seriously tho"
        content.badge = 1
        
        let currentTimestamp = NSDate().timeIntervalSince1970
        let seconds = (Int((timestamp?.rounded())!) + (hours! * 3600)) - Int(currentTimestamp.rounded())
        
        if seconds >= 0 {
            if notificationSent == false {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
                let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        print("Error sending notification: ", error!)
                    }
                }
            }
        }
    }
    
    @objc func endParkingFunc() {
        print("PLEASE WORK OH GOD")
        timerStarted = false
        notificationSent = false
        currentParking = false
        
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(currentUser!).child("currentParking")
        ref.removeValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CurrentParkingViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    
}
