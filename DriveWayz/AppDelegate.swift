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
import AFNetworking
import Solar

var device: Device = .iphone8
var solar: SolarTime = .day
let NetworkReachabilityChanged = NSNotification.Name("NetworkReachabilityChanged")
var previousNetworkReachabilityStatus: AFNetworkReachabilityStatus = .unknown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static let NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send"
    static var DEVICEID = String()
    static let SERVERKEY = "AAAAKKQVLOw:APA91bED4Od7cmdQ4f_dNTxAqMGIs65CZnQoU0T36u9MIEjzbjCLTrv6NYuWE-3AoQDiZqt_hSXbgjqPFQDuNbt37KBbnWmCd6FsiVWSJrlIQaIhvcJNflotw9GF0JYpRj-EVtgz6riU"
    private let baseURLString: String = "https://boiling-shore-28466.herokuapp.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        detectDevice()
        checkNetwork()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
        
        GMSServices.provideAPIKey("AIzaSyAuHA_iLGQ5sYtI_pAdYOP6SyPcoJrZaB8")
        GMSPlacesClient.provideAPIKey("AIzaSyAuHA_iLGQ5sYtI_pAdYOP6SyPcoJrZaB8")
        STPPaymentConfiguration.shared().publishableKey = "pk_live_xPZ14HLRoxNVnMRaTi8ecUMQ"
//        STPPaymentConfiguration.shared().appleMerchantIdentifier = "your apple merchant identifier"
        
        _ = self.window!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let startUpViewController = mainStoryboard.instantiateViewController(withIdentifier: "LaunchAnimationsViewController") as! LaunchAnimationsViewController

        window!.rootViewController = startUpViewController
        window!.makeKeyAndVisible()
        
        STPTheme.default().accentColor = Theme.PACIFIC_BLUE
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
//        application.registerForRemoteNotifications()
        
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                if let token = result?.token {
                    AppDelegate.DEVICEID = token
                    self.connectToFCM()
                    guard let currentUser = Auth.auth().currentUser?.uid else { return }
                    let ref = Database.database().reference().child("users").child(currentUser)
                    ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
                }
            }
        })
        return true
    }
    
    func checkNetwork() {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            let reachabilityStatus = AFStringFromNetworkReachabilityStatus(status)
            var reachableOrNot = ""
            var networkSummary = ""
            var reachableStatusBool = false
            
            switch (status) {
            case .reachableViaWWAN, .reachableViaWiFi:
                // Reachable.
                reachableOrNot = "Reachable"
                networkSummary = "Connected to Network"
                reachableStatusBool = true
            default:
                // Not reachable.
                reachableOrNot = "Not Reachable"
                networkSummary = "Disconnected from Network"
                reachableStatusBool = false
            }
            
            // Any class which has observer for this notification will be able to report loss of network connection
            // successfully.
            
            if (previousNetworkReachabilityStatus != .unknown && status != previousNetworkReachabilityStatus) {
                NotificationCenter.default.post(name: NetworkReachabilityChanged, object: nil, userInfo: [
                    "reachabilityStatus" : "Connection Status : \(reachabilityStatus)",
                    "reachableOrNot" : "Network Connection \(reachableOrNot)",
                    "summary" : networkSummary,
                    "reachableStatus" : reachableStatusBool
                    ])
            }
            previousNetworkReachabilityStatus = status
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = Stripe.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        }
        else {
            return self.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
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
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
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
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        CurrentParkingViewController().stopTimerTest()
        let date = Date()
        UserDefaults.standard.setValue(date, forKey: "lastDateOpened")
        UserDefaults.standard.synchronize()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        timerStarted = false
//        CurrentParkingViewController().restartDatabaseTimer()
//        startTimer()
        if let date = UserDefaults.standard.object(forKey: "lastDateOpened") as? Date {
            let currentDate = Date()
            let time = currentDate.minutes(from: date)
            if time > 30 {
                self.restartApplication()
            }
        }
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
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled(), let currentLocation = locationManager.location?.coordinate {
            let date = Date()
            let calendar = Calendar.current
            if let solarTime = Solar(coordinate: currentLocation) {
                if let sunrise = solarTime.civilSunrise?.addingTimeInterval(-1 * 3600), let sunset = solarTime.civilSunset?.addingTimeInterval(1 * 3600) {
                    let sunriseHour = calendar.component(.hour, from: sunrise.nearestHour()!)
                    let sunsetHour = calendar.component(.hour, from: sunset.nearestHour()!)
                    let dateHour = calendar.component(.hour, from: date.nearestHour()!)
                    if dateHour <= sunsetHour && dateHour >= sunriseHour {
                        solar = .day
                    } else {
                        solar = .night
                    }
                }
            }
        }
    }
    
    func restartApplication () {
        let viewController = LaunchAnimationsViewController()
        let navCtrl = UINavigationController(rootViewController: viewController)
        
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
            else {
                return
        }
        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.setNavigationBarHidden(true, animated: false)
        navCtrl.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
        
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
        
        completionHandler([.alert, .sound])
    }
    
}








