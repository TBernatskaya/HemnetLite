import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)

        window?.rootViewController = PropertiestListViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
