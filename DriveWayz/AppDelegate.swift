//
//  AppDelegate.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseInvites
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import Stripe
import FacebookCore
import UserNotifications

var device: Device = .iphone8

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static let NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send"
    static var DEVICEID = String()
    static let SERVERKEY = "AAAAKKQVLOw:APA91bED4Od7cmdQ4f_dNTxAqMGIs65CZnQoU0T36u9MIEjzbjCLTrv6NYuWE-3AoQDiZqt_hSXbgjqPFQDuNbt37KBbnWmCd6FsiVWSJrlIQaIhvcJNflotw9GF0JYpRj-EVtgz6riU"
    
    private let baseURLString: String = "https://boiling-shore-28466.herokuapp.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .default
        
        detectDevice()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
        
        GMSServices.provideAPIKey("AIzaSyCSdL_pkLxeCh2GsYlLAxn3NPHVI4KA3f0")
        GMSPlacesClient.provideAPIKey("AIzaSyCSdL_pkLxeCh2GsYlLAxn3NPHVI4KA3f0")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_D5D2xLIBELH4ZlTwigJEWyKF"
//        STPPaymentConfiguration.shared().appleMerchantIdentifier = "your apple merchant identifier"
        
        _ = self.window!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let startUpViewController = mainStoryboard.instantiateViewController(withIdentifier: "LaunchAnimationsViewController") as! LaunchAnimationsViewController

        window!.rootViewController = startUpViewController
        window!.makeKeyAndVisible()
        
        STPTheme.default().accentColor = Theme.PRIMARY_COLOR
        
        UIApplication.shared.applicationIconBadgeNumber = 0
//        application.registerForRemoteNotifications()
        
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                AppDelegate.DEVICEID = (result?.token)!
                self.connectToFCM()
                guard let currentUser = Auth.auth().currentUser?.uid else { return }
                let ref = Database.database().reference().child("users").child(currentUser)
                ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
            }
        })
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = Stripe.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        }
        else {
            return self.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "")
        }
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        
        return Invites.handleUniversalLink(url) { invite, error in
            // ...
        }
    }
    
    // This method is where you handle URL opens if you are using univeral link URLs (eg "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = Stripe.handleURLCallback(with: url)
                
                if (stripeHandled) {
                    return true
                }
                else {
                }
            }
            
        }
        return false
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        CurrentParkingViewController().stopTimerTest()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        timerStarted = false
        CurrentParkingViewController().restartDatabaseTimer()
        startTimer()
        let notificationController = NotifyUpcomingViewController()
        notificationController.checkForUpcoming()
    }
    
    func startTimer() {
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
                            let currentTimestamp = NSDate().timeIntervalSince1970
                            seconds = (Int((refreshTimestamp?.rounded())!) + (refreshHours! * 3600)) - Int(currentTimestamp.rounded())
                        }
                    }, withCancel: nil)
                }
            }
        }
    }
    
    func detectDevice() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                device = .iphone8
            case 1334:
                print("iPhone 6/6S/7/8")
                device = .iphone8
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                device = .iphone8
            case 2436:
                print("iPhone X")
                device = .iphoneX
            default:
                print("unknown")
                device = .iphone8
            }
        }
    }
}


extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                AppDelegate.DEVICEID = (result?.token)!
                self.connectToFCM()
            }
        })
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                AppDelegate.DEVICEID = (result?.token)!
                self.connectToFCM()
            }
        })
    }
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    }
    
    func connectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound]) 
    }
    
}








