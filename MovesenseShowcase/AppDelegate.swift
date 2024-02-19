import UIKit
import OSCKit


struct appGlobals {
    static var oscClient : OscClient? = nil
    static  var oscHost : String = "undefined"
}

public class OscClient {
  let instance: OSCUdpClient

    init(host: String, portNo: UInt16) {
        self.instance = OSCUdpClient(host: host, port: portNo)
  }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = TabBarViewController.sharedInstance
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let termsViewController = TermsViewController(displayAcceptAction: true)

        if Settings.isFirstLaunch {
            let introViewController = OnboardingIntroViewController(nextViewController: termsViewController)
            navigationController.pushViewController(introViewController, animated: false)
        } else if Settings.isTermsAccepted == false {
            let introViewController = OnboardingIntroViewController(nextViewController: termsViewController)
            navigationController.pushViewController(introViewController, animated: false)
            navigationController.pushViewController(termsViewController, animated: false)
        }

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        var oscTarget = "127.0.0.1:55555"
        
        print ("OSC TX set to: " ,oscTarget)
        self.openOscClient(oscTarget)
        
        return true
    }

    func openOscClient(_ targetStr: String)
    {
        var hostIP : Substring
        var portNo : UInt16
        
        var parts = targetStr.split(separator: ":")
        
        hostIP = parts[0]
        portNo = UInt16(parts[1])!
        
        appGlobals.oscClient = OscClient(host: String(hostIP), portNo: portNo)
        appGlobals.oscHost = targetStr
        print ("Setting up OSC tx client with: " ,targetStr)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of
        // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it
        // begins the transition to the background state.

        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use
        // this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state
        // information to restore your application to its current state in case it is terminated later.

        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the
        // user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made
        // on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was
        // previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       // appGlobals.oscClient?.instance.host.
    }
}
