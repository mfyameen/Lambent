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
    override func loadView() {
        let photographyView = HomeView()
        let photographyModel = PhotographyModel()
        view = photographyView
        view.backgroundColor = UIColor.backgroundColor()
        title = "Capturing Light"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
        ViewControllerBinding.bind(view: photographyView, viewController: self, model: photographyModel)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.isNavigationBarHidden = true
//    }

    func pushTutorialViewController(setUp: TutorialSetUp) -> Void{
        navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: true)
    }
}
    struct ViewControllerBinding{
        static func bind (view: HomeView, viewController: HomeViewController, model: PhotographyModel){
            model.fetchImages({ DemoView.images = $0 })
            view.navigationController = viewController.navigationController
            view.tableViewContent = model
            view.startTutorial = viewController.pushTutorialViewController
        }
}

