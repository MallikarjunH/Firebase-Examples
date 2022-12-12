//
//  AppDelegate.swift
//  PushNotification
//
//  Created by EOO61 on 03/11/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
   // let gcmMessageIDKey = "1:851743474169:ios:dc46cc6243f9cfa352fd28"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        /*
         Register for remote notifications
         
         Either at startup, or at the desired point in your application flow, register your app for remote notifications. Call registerForRemoteNotifications as shown:
         */
        
        // START register_for_notifications
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self //for this you need to add - UNUserNotificationCenterDelegate at top (like adopting protocol)
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // END register_for_notifications
        
        /*
         // Access the registration token
         
         By default, the FCM SDK generates a registration token for the client app instance on app launch. Similar to the APNs device token, this token allows you to send targeted notifications to any particular instance of your app.
         
         In the same way that Apple platforms typically deliver an APNs device token on app start, FCM provides a registration token via FIRMessagingDelegate's messaging:didReceiveRegistrationToken: method. The FCM SDK retrieves a new or existing token during initial app launch and whenever the token is updated or invalidated. In all cases, the FCM SDK calls messaging:didReceiveRegistrationToken: with a valid token
         
         // Set the messaging delegate
         
         To receive registration tokens, implement the messaging delegate protocol and set FIRMessaging's delegate property after calling [FIRApp configure]. For example, if your application delegate conforms to the messaging delegate protocol, you can set the delegate on application:didFinishLaunchingWithOptions: to itself.
         
         */
        
        //START set_messaging_delegate
        Messaging.messaging().delegate = self //MessagingDelegate this you need to add/adopt protocol at top
        //END set_messaging_delegate
        
        return true
    }
    
    // [START refresh_token] - from MessagingDelegate protocol,
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        UserDefaults.standard.set(fcmToken, forKey: "FcmToken")
        UserDefaults.standard.synchronize()
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
    
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // ...
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        return [[.alert, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        // ...
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print(userInfo)
    }
    
    
    
    /*
    Handle silent push notifications

    When sending messages with the content_available key (equivalent to APNs's content-available, the messages will be delivered as silent notifications, waking your app in the background for tasks like background data refresh. Unlike foreground notifications, these notifications must be handled via the application(_:didReceiveRemoteNotification:fetchCompletionHandler:) method.
     */

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        return UIBackgroundFetchResult.newData
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

