// import UIKit
// import Flutter
// import Firebase
// import KakaoSDKAuth
// import KakaoSDKCommon

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
    
//     if let appKey = Bundle.main.object(forInfoDictionaryKey: "c17f0f1bc6e039d488fb5264fdf93a10") as? String {
//             KakaoSDKCommon.initSDK(appKey: appKey)
//         }
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

//   override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//     var result = false
    
//     NSLog("URL = \(url.absoluteString)");
    
//     if url.absoluteString.hasPrefix("kakao"){
//       result = super.application(app, open: url, options: options)
//     }
//     if !result {}
//     return result
//   }
// }

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
