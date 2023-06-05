import Global
import Data
import UIKit

import FirebaseCore
import FirebaseMessaging
import Mixpanel
import RxKakaoSDKCommon
import RxKakaoSDKAuth
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        RxKakaoSDK.initSDK(appKey: "41248bd7434ad5d295065a3fc85577ea")
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        FirebaseService.shared.start()
        
        #if DEBUG
        let token = SecretKey.mixpanelDevToken
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        #else
        let token = SecretKey.mixpanelProdToken
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        #endif
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaultsManager.shared.fcmToken = fcmToken
        print("✅ fcmToken", fcmToken ?? "nil")
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
}
