import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        let photographyView = PhotographyView()
        view = photographyView
        title = "Learn Photography"
         ViewControllerBinding.bind(view: photographyView, viewController: self)
    }
    
    func pushTutorialViewController(){
        print("goodbye")
            navigationController?.pushViewController(TutorialViewController(), animated: true)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        }
    }

    struct ViewControllerBinding{
        static func bind (view: PhotographyView, viewController: ViewController){
            PhotographyView.startTutorial = viewController.pushTutorialViewController
        }
    }

//PhotographyView.startTutorial works with static var
