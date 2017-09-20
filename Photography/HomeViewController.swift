import UIKit

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
        title = "Lambent"
        view = homeView
        view.backgroundColor = UIColor.backgroundColor()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24)]
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
        model.fetchCachedImages { DemoView.images = $0; DemoView.cache = $1 }
        model.fetchContent{ viewController.content = $0; view.homeContent = $0 }
        view.navigationController = viewController.navigationController
        view.startTutorial = viewController.pushTutorialViewController
    }
}

