import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        let photographyView = PhotographyView()
        let photographyModel = PhotographyModel()
        let photographyCell = PhotographyCell()
        view = photographyView
        title = "Learn Photography"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
        ViewControllerBinding.bind(view: photographyView, cell: photographyCell, viewController: self, model: photographyModel)
    }
//    
//    override func viewDidLoad() {
//       navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
//    }
    
   
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.hidesBarsOnSwipe = false
//    }
    
    func pushTutorialViewController(setUp: TutorialSetUp) -> Void{
        navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: true)
    }
}
    struct ViewControllerBinding{
        static func bind (view: PhotographyView, cell: PhotographyCell, viewController: ViewController, model: PhotographyModel){
            view.tableViewContent = model
            view.startTutorial = viewController.pushTutorialViewController
        }
    }
