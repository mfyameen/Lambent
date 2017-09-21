import UIKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        prepareApplication()
        let launches = UserDefaults.standard.integer(forKey: "launch") + 1
        UserDefaults.standard.set(false, forKey: "requested review")
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
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor.backgroundColor()
        window?.makeKeyAndVisible()
        configureGoogleAnalytics()
    }
    
    private func configureGoogleAnalytics() {
        guard let gai = GAI.sharedInstance() else { assert(false, "Google Analytics not configured correctly") }
        gai.tracker(withTrackingId: "UA-106810868-1")
        gai.trackUncaughtExceptions = true
        gai.logger.logLevel = .verbose
    }
}

