import UIKit

class ViewController: UIViewController {
    override func loadView() {
        let photographyView = PhotographyView()
        let photographyModel = PhotographyModel()
        view = photographyView
        view.backgroundColor = UIColor.backgroundColor()
        title = "Capturing Light"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
        ViewControllerBinding.bind(view: photographyView, viewController: self, model: photographyModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func pushTutorialViewController(setUp: TutorialSetUp) -> Void{
        navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: true)
    }
}
    struct ViewControllerBinding{
        static func bind (view: PhotographyView, viewController: ViewController, model: PhotographyModel){
            view.navigationController = viewController.navigationController
            view.tableViewContent = model
            view.startTutorial = viewController.pushTutorialViewController
        }
}

