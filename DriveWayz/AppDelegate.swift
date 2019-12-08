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
import FirebaseDynamicLinks
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import Stripe
import FacebookCore
import FacebookLogin
import UserNotifications
import AFNetworking
import Solar

var device: Device = .iphone8
var solar: SolarTime = .day
let NetworkReachabilityChanged = NSNotification.Name("NetworkReachabilityChanged")
var previousNetworkReachabilityStatus: AFNetworkReachabilityStatus = .unknown

var currentBooking: Bookings?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var applicationCheck: UIApplication?
    let gcmMessageIDKey = "174551543020"
    static let NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send"
    static var DEVICEID = String()
    static let SERVERKEY = "AAAAKKQVLOw:APA91bEzWxKfKYZzgQQ59ubBKwFZ__6pZEE489XPJqJUaQmbHsLMPKWSKfvMwbFYw3hL74stguq9xLZTaxOtn5MuUAHkDWFzd50U9eoW5WUrSSbQ-pR8_cTmro44Re72uqKGPAetdXeK"
    private let baseURLString: String = "https://boiling-shore-28466.herokuapp.com"
    
    var mainController: LaunchAnimationsViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationCheck = application
        
        FirebaseApp.configure()
        checkForBooking()
        detectDevice()
        checkNetwork()
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GMSServices.provideAPIKey("AIzaSyAuHA_iLGQ5sYtI_pAdYOP6SyPcoJrZaB8")
        GMSPlacesClient.provideAPIKey("AIzaSyAuHA_iLGQ5sYtI_pAdYOP6SyPcoJrZaB8")
        STPPaymentConfiguration.shared().publishableKey = "pk_live_xPZ14HLRoxNVnMRaTi8ecUMQ"
//        STPPaymentConfiguration.shared().appleMerchantIdentifier = "your apple merchant identifier"
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        statusHeight = UIApplication.shared.statusBarFrame.height
        
        _ = self.window!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let startUpViewController = mainStoryboard.instantiateViewController(withIdentifier: "LaunchAnimationsViewController") as! LaunchAnimationsViewController
        mainController = startUpViewController
        window!.rootViewController = startUpViewController
        window!.makeKeyAndVisible()
        
        STPTheme.default().accentColor = Theme.BLUE
        
        Messaging.messaging().delegate = self
        
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            // user notifications auth
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
            UIApplication.shared.applicationIconBadgeNumber = 0
            UIApplication.shared.registerForRemoteNotifications()

            application.registerForRemoteNotifications()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(registerForRemoteNotifs), name: NSNotification.Name(rawValue: "registerForNotifications"), object: nil)
        }
        
        UITableView.appearance().separatorColor = lineColor
        
        return true
    }
    
    func checkForBooking() {
        let bookingStatus = UserDefaults.standard.string(forKey: "userBookingStatus") ?? "none"
        if bookingStatus == "currentlyBooked" {
            BookedState = .currentlyBooked
        } else if bookingStatus == "reserved" {
            BookedState = .reserved
        } else {
            BookedState = .none
        }
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID)
        ref.child("UpcomingReservations").observe(.childAdded) { (snapshot) in
            BookedState = .reserved
            UserDefaults.standard.set("reserved", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
        }
        ref.child("UpcomingReservations").observe(.childRemoved) { (snapshot) in
            BookedState = .none
            UserDefaults.standard.set("none", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
        }
        ref.child("CurrentBooking").observe(.childAdded) { (snapshot) in
            if let controller = self.mainController, let tabController = controller.tabController {
                if tabController.mapController.mainViewState != .payment {
                    BookedState = .currentlyBooked
                }
            } else {
                BookedState = .currentlyBooked
            }
            UserDefaults.standard.set("currentlyBooked", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
        }
        ref.child("CurrentBooking").observe(.childRemoved) { (snapshot) in
            BookedState = .none
            UserDefaults.standard.set("none", forKey: "userBookingStatus")
            UserDefaults.standard.synchronize()
        }
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
    
    @objc func registerForRemoteNotifs() {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if !isRegisteredForRemoteNotifications {
            if let application = applicationCheck {
                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
                UIApplication.shared.applicationIconBadgeNumber = 0
                UNUserNotificationCenter.current().delegate = self
                UIApplication.shared.registerForRemoteNotifications()
                
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
        } else {
            let stripeHandled = Stripe.handleURLCallback(with: url)
            if (stripeHandled) {
                return true
            } else {
                return (GIDSignIn.sharedInstance()?.handle(url))!
//                return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
                
                return false
                //            return self.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
            }
        }
        return false
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(currentUser)
        ref.child("Coupons").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if (dictionary["INVITE10"] as? String) != nil {
//                    let alert = UIAlertController(title: "Sorry", message: "You can only get one 10% off coupon for sharing.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    self.present(alert, animated: true)
                    return
                } else {
                    ref.child("Coupons").updateChildValues(["INVITE10": "10% off coupon!"])
                    ref.child("CurrentCoupon").updateChildValues(["invite": 10])
//                    let alert = UIAlertController(title: "Thanks for sharing!", message: "You have successfully invited your friend and recieved a 10% off coupon for your next rental.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    // This method is where you handle URL opens if you are using univeral link URLs (eg "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                if let err = error {
                    print(err.localizedDescription)
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
        }
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
        self.inputView?.endEditing(true)
        
        let date = Date()
        UserDefaults.standard.setValue(date, forKey: "lastDateOpened")
        UserDefaults.standard.synchronize()
        
        if bookingTimer != nil {
            bookingTimer!.invalidate()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        if timerStarted == true {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bookingTimerRestart"), object: nil)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        AppEventsLogger.activate(application)
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
                //                device = .iphonePlus
                device = .iphoneX
            case 2436:
                print("iPhone X")
                device = .iphoneX
            default:
                print("unknown")
                //                device = .iPad
                device = .iphoneX
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
    
}

extension AppDelegate {
    
//    // Listen for user notifications
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        completionHandler([.alert, .badge, .sound])
//    }
    
//    // listen for user notifications
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        completionHandler([.alert, .badge, .sound])
//    }
//
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        completionHandler([.alert, .badge, .sound])
//    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        completionHandler(.alert)
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        let userInfo = response.notification.request.content.userInfo
//
//        print(userInfo)
//
//        completionHandler()
//    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        let userInfo = remoteMessage.appData
//
//        print(userInfo)
//
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//    }
    
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        UIApplication.shared.applicationIconBadgeNumber = 0
//
//        completionHandler(.newData)
//    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print full message.
//        print(userInfo)
//    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        UIApplication.shared.applicationIconBadgeNumber += 1

        // Print full message
        print(userInfo)

        completionHandler(.newData)
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
//        completionHandler()
//    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                AppDelegate.DEVICEID = (result?.token)!
                
                guard let currentUser = Auth.auth().currentUser?.uid else { return }
                let ref = Database.database().reference().child("users").child(currentUser)
                ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
            }
        })
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                AppDelegate.DEVICEID = (result?.token)!
                
                guard let currentUser = Auth.auth().currentUser?.uid else { return }
                let ref = Database.database().reference().child("users").child(currentUser)
                ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
            }
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                AppDelegate.DEVICEID = (result?.token)!

                guard let currentUser = Auth.auth().currentUser?.uid else { return }
                let ref = Database.database().reference().child("users").child(currentUser)
                ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
            }
        })
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
}


extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
