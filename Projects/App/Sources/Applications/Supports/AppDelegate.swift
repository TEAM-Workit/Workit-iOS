import UIKit

import RxKakaoSDKCommon
import RxKakaoSDKAuth
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        RxKakaoSDK.initSDK(appKey: "41248bd7434ad5d295065a3fc85577ea")
        return true
    }
}
