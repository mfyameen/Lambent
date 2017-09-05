import UIKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        prepareApplication()
        let launches = UserDefaults.standard.integer(forKey: "launch") + 1
        UserDefaults.standard.set(launches, forKey: "launch")
        return true
    }
    
    override init() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        prepareApplication()
    }
    
    private func prepareApplication() {
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        let titleAttributes =  [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)]
        navigationController.navigationBar.titleTextAttributes = titleAttributes
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor.backgroundColor()
        window?.makeKeyAndVisible()
    }
}

