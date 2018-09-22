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
import GoogleMaps
import MapboxStatic

var timerStarted: Bool = false
var currentParking: Bool = false
var notificationSent: Bool = false

 var seconds: Int?

class CurrentParkingViewController: UIViewController {
    
    var timestamp: Double?
    var hours: Int?
    var timerTest : Timer?
    var delegate: notificationOptions?
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var timeRemaining: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Theme.PRIMARY_DARK_COLOR
        label.textAlignment = .left
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        configureNotifications()
        checkCurrentParking()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer.invalidate()
        if let userID = Auth.auth().currentUser?.uid {
            let currentRef = Database.database().reference().child("users").child(userID).child("currentParking")
            currentRef.observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    currentParking = true
                    let refreshTimestamp = dictionary["timestamp"] as? Double
                    let refreshHours = dictionary["hours"] as? Int
                    let currentTimestamp = NSDate().timeIntervalSince1970
                    seconds = (Int((refreshTimestamp?.rounded())!) + (refreshHours! * 3600)) - Int(currentTimestamp.rounded())
                    seconds = seconds! + (10 * 60)
                    
                    self.runTimer()
                }
            }
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        container.addSubview(timeRemaining)
        timeRemaining.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        timeRemaining.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        timeRemaining.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        timeRemaining.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
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
                    let parkingRef = Database.database().reference().child("parking").child(parkingID!)
                    parkingRef.observeSingleEvent(of: .value, with: { (pull) in
                        if let pullRef = pull.value as? [String:AnyObject] {
                            let address = pullRef["parkingAddress"] as? String
                    
                            if notificationSent == false {
                                notificationSent = true
                                self.startTimerNotification(address: address!)
                            }
                        }
                    })
                }
            }, withCancel: nil)
            currentRef.observe(.childRemoved, with: { (snapshot) in
                currentParking = false
                
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
                            let refreshTimestamp = stamp["timestamp"] as? Double
                            let refreshHours = stamp["hours"] as? Int
                            if timerStarted == false {
                                timerStarted = true
                                if currentParking == true {
                                    let currentTimestamp = NSDate().timeIntervalSince1970
                                    let seconds = (Int((refreshTimestamp?.rounded())!) + (refreshHours! * 3600)) - Int(currentTimestamp.rounded())
                                    
                                    if seconds >= 0 {
                                        if self.timerTest == nil {
                                            self.timerTest =  Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(self.prepareEndParking), userInfo: nil, repeats: false)
                                            RunLoop.main.add(self.timerTest!, forMode: RunLoopMode.commonModes)
                                        }
                                    }
                                }
                            }
                        }
                    }, withCancel: nil)
                }
            }
        }
    }
    
    func startTiming() {
        if currentParking == true {
            let currentTimestamp = NSDate().timeIntervalSince1970
            let seconds = (Int((timestamp?.rounded())!) + (hours! * 3600)) - Int(currentTimestamp.rounded())

            if seconds >= 0 {
                if timerTest == nil {
                    timerTest =  Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(prepareEndParking), userInfo: nil, repeats: false)
                    RunLoop.main.add(timerTest!, forMode: RunLoopMode.commonModes)
                }
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
    
    func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in
            //
        }
        let endParkingAction = UNNotificationAction(identifier: "endParking", title: "Confirm you have left", options: [])
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [endParkingAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func startTimerNotification(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("Couldn't find location")
                    return
            }
            let mapboxCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let camera = SnapshotCamera(lookingAtCenter: mapboxCoordinate, zoomLevel: 16.0)
            let options = SnapshotOptions(styleURL: URL(string: "mapbox://styles/tcagle717/cjjnibq7002v22sowhbsqkg22")!, camera: camera, size: CGSize(width: 288, height: 200))
            let markerOverlay = Marker(
                coordinate: mapboxCoordinate,
                size: .small,
                iconName: "car"
            )
            markerOverlay.color = Theme.PRIMARY_COLOR
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
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "actionCategory"
            
            secondContent.title = "You have overstayed your allotted time!"
            secondContent.body = "Please move your vehicle or you will be charged an extra hour in 15 minutes."
            secondContent.badge = 0
            secondContent.sound = UNNotificationSound.default()
            secondContent.categoryIdentifier = "actionCategory"
            
            thirdContent.title = "You have been charged for an extra hour."
            thirdContent.body = "Please move your vehicle or extend time."
            thirdContent.badge = 0
            thirdContent.sound = UNNotificationSound.default()
            thirdContent.categoryIdentifier = "actionCategory"
            
            fourthContent.title = "You have 20 minutes left for your parking spot"
            fourthContent.body = "Check in with the app to extend time!"
            fourthContent.badge = 0
            fourthContent.sound = UNNotificationSound.default()
            
            let firstSeconds = (self.hours! * 3600) + (10 * 60)
            let secondSeconds = firstSeconds + (15 * 60)
            let thirdSeconds = firstSeconds + (30 * 60)
            let fourthSeconds = firstSeconds - (20 * 60)
            
            if seconds! >= 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(firstSeconds), repeats: false)
                let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                let secondTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(secondSeconds), repeats: false)
                let secondRequest = UNNotificationRequest(identifier: "timerDone2", content: secondContent, trigger: secondTrigger)
                let thirdTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(thirdSeconds), repeats: false)
                let thirdRequest = UNNotificationRequest(identifier: "timerDone3", content: thirdContent, trigger: thirdTrigger)
                
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        print("Error sending first notification: ", error!)
                    }
                }
                UNUserNotificationCenter.current().add(secondRequest) { (error) in
                    if error != nil {
                        print("Error sending second notification: ", error!)
                    }
                }
                UNUserNotificationCenter.current().add(thirdRequest) { (error) in
                    if error != nil {
                        print("Error sending third notification: ", error!)
                    }
                }
                if fourthSeconds > 0 {
                    let fourthTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fourthSeconds), repeats: false)
                    let fourthRequest = UNNotificationRequest(identifier: "timerDone4", content: fourthContent, trigger: fourthTrigger)
                    UNUserNotificationCenter.current().add(fourthRequest) { (error) in
                        if error != nil {
                            print("Error sending fourth notification: ", error!)
                        }
                    }
                }
            }
        }
    }
    
    @objc func prepareEndParking() {
    
        print("Will end parking time")
    
    }
    
    var timer = Timer()
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds! >= 0 {
            seconds! = seconds! - 1
            timeRemaining.text = timeString(time: TimeInterval(seconds!))
        } else {
            timeRemaining.text = "Times up"
        }
        if timeRemaining.text == "Times up" {
            timeRemaining.textColor = Theme.HARMONY_COLOR
        } else {
            timeRemaining.textColor = Theme.PRIMARY_DARK_COLOR
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        if hours == 1 {
            return String(format: "%01i hour %02i minutes", arguments: [hours, minutes])
        } else if hours >= 10 {
            return String(format: "%02i hours %02i minutes", arguments: [hours, minutes])
        } else if hours == 0 {
            return String(format: "%02i minutes", arguments: [minutes])
        } else {
            return String(format: "%01i hours %02i minutes", arguments: [hours, minutes])
        }
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
        case "endParking":
            print("Action Second Tapped")
            self.endCurrentParking()
            self.delegate?.sendLeaveReview()
        default:
            break
        }
        completionHandler()
    }
    
    func endCurrentParking() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser).child("currentParking")
        ref.removeValue()
        
        
        timerStarted = false
        notificationSent = false
        currentParking = false
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}


extension UNNotificationAttachment {
    
    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = UIImagePNGRepresentation(image) else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}
