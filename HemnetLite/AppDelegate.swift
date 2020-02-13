import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)

        let navigationController = UINavigationController()

        let listViewController = PropertiesListViewController(viewModel: PropertiesListViewModelImpl(), openDetails: { property in
            let detailsVC = PropertyDetailsViewController(property: property)
            DispatchQueue.main.async {
                navigationController.pushViewController(detailsVC, animated: true)
            }
        })

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        navigationController.pushViewController(listViewController, animated: false)

        return true
    }
}
