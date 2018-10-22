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
                    self.timestamp = dictionary["timestamp"] as? Double
                    self.hours = dictionary["hours"] as? Int
                    if timerStarted == false {
                        timerStarted = true
                        self.startTiming()
                    }
                    if notificationSent == false {
                        notificationSent = true
                    }
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
                                    let seconds = (Int((refreshTimestamp?.rounded())!) + (refreshHours! * 3600) + (600)) - Int(currentTimestamp.rounded())
                                    
                                    if seconds >= 0 {
                                        if self.timerTest == nil {
                                            self.timerTest =  Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(self.prepareEndParking), userInfo: nil, repeats: false)
                                            RunLoop.main.add(self.timerTest!, forMode: RunLoop.Mode.common)
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
                    RunLoop.main.add(timerTest!, forMode: RunLoop.Mode.common)
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
    
    var timer = Timer()
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds! > 0 {
            seconds! = seconds! - 1
            timeRemaining.text = timeString(time: TimeInterval(seconds!))
            timeRemaining.textColor = Theme.PRIMARY_DARK_COLOR
        } else {
            timeRemaining.text = "Times up"
            timeRemaining.textColor = Theme.HARMONY_COLOR
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
    
    
    @objc func prepareEndParking() {
        print("Will end parking time")
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
            guard let imageData = image.pngData() else {
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
