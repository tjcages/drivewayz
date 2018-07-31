//
//  AppDelegate.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import Stripe
import FacebookCore
import UserNotifications

var device: Device = .iphone8

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let baseURLString: String = "https://boiling-shore-28466.herokuapp.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .default
        UNUserNotificationCenter.current().delegate = self
        detectDevice()
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyCSdL_pkLxeCh2GsYlLAxn3NPHVI4KA3f0")
        GMSPlacesClient.provideAPIKey("AIzaSyCSdL_pkLxeCh2GsYlLAxn3NPHVI4KA3f0")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_D5D2xLIBELH4ZlTwigJEWyKF"
        
//        STPPaymentConfiguration.shared().appleMerchantIdentifier = "your apple merchant identifier"
        
        let loginViewController = StartUpViewController()
        UIApplication.shared.statusBarStyle = .lightContent
        
        window!.rootViewController = loginViewController
        window!.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UserDefaults.standard.bool(forKey: "isUserLoggedIn") != true {
                
                let loginViewController = StartUpViewController()
                UIApplication.shared.statusBarStyle = .lightContent
                
                self.window!.rootViewController = loginViewController
                self.window!.makeKeyAndVisible()
                
            }
            else {
                
                let containerViewController = TabViewController()
                UIApplication.shared.statusBarStyle = .default
                
                self.window!.rootViewController = containerViewController
                self.window!.makeKeyAndVisible()
            }
        }
        
        STPTheme.default().accentColor = Theme.PRIMARY_COLOR
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
            // This was not a stripe url, do whatever url handling your app
            // normally does, if any.
        }
        
        return false
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


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // called when user interacts with notification (app not running in foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {
        
        // do something with the notification
        print(response.notification.request.content.userInfo)
        
        // the docs say you should execute this asap
        return completionHandler()
    }
    
    // called if app is running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
        notification: UNNotification, withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // show alert while app is running in foreground
        return completionHandler(UNNotificationPresentationOptions.alert)
    }
}

