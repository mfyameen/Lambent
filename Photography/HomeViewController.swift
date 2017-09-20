import UIKit

public enum Page: Int {
    case overview = 0
    case aperture = 1
    case shutter = 2
    case iso = 3
    case focal = 4
    case modes = 5
}

public enum Segment {
    case none
    case intro
    case demo
    case practice
    
    var value: Int {
        switch self {
        case .none: return 0
        case .intro: return 0
        case .demo: return 1
        case .practice: return 2
        }
    }
    
    static func type(forValue value: Int) -> Segment {
        switch value {
        case 0: return .intro
        case 1: return .demo
        case 2: return .practice
        default: return .none
        }
    }
}

public struct TutorialSetUp {
    let currentPage: Page
    let currentSegment: Segment
    public init(currentPage: Page, currentSegment: Segment) {
        self.currentPage = currentPage
        self.currentSegment = currentSegment
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

final class HomeViewController: UIViewController {
    var content: Content?
    
    override func loadView() {
        let photographyModel = PhotographyModel()
        let homeView = HomeView()
        view = homeView
        view.backgroundColor = UIColor.backgroundColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 24)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
        ViewControllerBinding.bind(view: homeView, viewController: self, model: photographyModel)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    func pushTutorialViewController(setUp: TutorialSetUp) -> Void {
        guard let content = content else { return }
        navigationController?.pushViewController(TutorialViewController(setUp: setUp, content: content), animated: true)
    }
}

struct ViewControllerBinding {
    static func bind (view: HomeView, viewController: HomeViewController, model: PhotographyModel) {
        model.fetchCachedImages { DemoView.images = $0.0; DemoView.cache = $0.1 }
        model.fetchContent{ viewController.content = $0; view.homeContent = $0 }
        view.navigationController = viewController.navigationController
        view.startTutorial = viewController.pushTutorialViewController
    }
}

