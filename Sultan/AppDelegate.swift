
import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = LoaderViewController {
            let vc = UIHostingController(rootView: MenuView())
            self.window?.rootViewController = NavigationController(rootViewController: vc)
        }
        self.window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}


class NavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
}
