import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        let photographyView = PhotographyView()
        let photographyModel = PhotographyModel()
        view = photographyView
        view.backgroundColor = UIColor.backgroundColor()
        title = "Learn Photography"
        //navigationController?.hidesBarsOnSwipe = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
        ViewControllerBinding.bind(view: photographyView, viewController: self, model: photographyModel)
    }
    
    func pushTutorialViewController(setUp: TutorialSetUp) -> Void{
        navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: true)
    }

}
struct ViewControllerBinding{
    static func bind (view: PhotographyView, viewController: ViewController, model: PhotographyModel){
        view.tableViewContent = model
        view.startTutorial = viewController.pushTutorialViewController
    }
}
