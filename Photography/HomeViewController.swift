import UIKit

public enum Page: Int {
    case overview = 0
    case aperture = 1
    case shutter = 2
    case iso = 3
    case focal = 4
    case modes = 5
}

public enum Segment: Int {
    case intro = 0
    case demo = 1
    case practice = 2
}

public struct TutorialSetUp {
    var currentPage: Page
    var currentSegment: Segment?
    public init(currentPage: Page, currentSegment: Segment?) {
        self.currentPage = currentPage
        self.currentSegment = currentSegment
    }
}

class HomeViewController: UIViewController {
    let photographyModel = PhotographyModel()
    var content: Content?
    
    override func loadView() {
        let photographyView = HomeView()
        view = photographyView
        view.backgroundColor = UIColor.backgroundColor()
        title = "Capturing Light"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
        ViewControllerBinding.bind(view: photographyView, viewController: self, model: photographyModel)
    }

    func pushTutorialViewController(setUp: TutorialSetUp) -> Void {
        guard let content = content else { return }
        navigationController?.pushViewController(TutorialViewController(setUp: setUp, content: content), animated: true)
    }
}
    struct ViewControllerBinding {
        static func bind (view: HomeView, viewController: HomeViewController, model: PhotographyModel) {
            model.fetchContent{ viewController.content = $0 }
            model.fetchContent{ view.homeContent = $0 }
            model.fetchCachedImage{ DemoView.images = $0.0; DemoView.cache = $0.1 }
            view.navigationController = viewController.navigationController
            view.startTutorial = viewController.pushTutorialViewController
        }
}

