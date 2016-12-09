import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        let photographyView = PhotographyView()
        let photographyModel = PhotographyModel()
        view = photographyView
        title = "Learn Photography"
        ViewControllerBinding.bind(view: photographyView, viewController: self, model: photographyModel)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        //still need to work on navigation controller disappearing and reappearing
//        super.viewDidAppear(animated)
//        navigationController?.hidesBarsOnSwipe = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.hidesBarsOnSwipe = false
//    }
    
    func pushTutorialViewController() -> Void{
            navigationController?.pushViewController(TutorialViewController(), animated: true)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        }
    }

    struct ViewControllerBinding{
        static func bind (view: PhotographyView, viewController: ViewController, model: PhotographyModel){
            view.tableViewContent = model
            view.startTutorial = viewController.pushTutorialViewController
        }
    }
