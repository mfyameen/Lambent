import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: ViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor.backgroundColor()
        window?.makeKeyAndVisible()
        
        //maybe move this to a better location?
        navigationController.navigationBar.barTintColor = UIColor.backgroundColor()
        let titleAttributes =  [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)]
        navigationController.navigationBar.titleTextAttributes = titleAttributes
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        return true
    }
}

