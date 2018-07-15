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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyCSdL_pkLxeCh2GsYlLAxn3NPHVI4KA3f0")
        GMSPlacesClient.provideAPIKey("AIzaSyCSdL_pkLxeCh2GsYlLAxn3NPHVI4KA3f0")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_D5D2xLIBELH4ZlTwigJEWyKF"
//        STPPaymentConfiguration.shared().appleMerchantIdentifier = "your apple merchant identifier"
        
        _ = self.window!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(!isUserLoggedIn) {
            
            let startUpViewController = mainStoryboard.instantiateViewController(withIdentifier: "StartUpViewController") as! StartUpViewController
            
            window!.rootViewController = startUpViewController
            window!.makeKeyAndVisible()
            
        } else {
            
            let protectedPage = mainStoryboard.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            
            window!.rootViewController = protectedPage
            window!.makeKeyAndVisible()
            
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

