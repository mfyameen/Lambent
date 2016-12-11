import UIKit

class TutorialViewController: UIViewController {
    init(page: Int){
        super.init(nibName: nil, bundle: nil)
        UserDefaults.standard.set(page, forKey: "page#")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tutorialView = TutorialView()
        let photographyModel = PhotographyModel()
        view = tutorialView
        title = photographyModel.steps[UserDefaults.standard.integer(forKey: "page#")]
    
        TutorialBinding.bind(view: tutorialView, viewController: self, model: photographyModel )
    }

    //need to work on adding back bar button functionality, so that users return to first screen
    func returnHome(){
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func pushNextTutorialViewController(_ page: Int) -> Void{
        navigationController?.pushViewController(TutorialViewController(page: page), animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(returnHome))
    }
    
    func pushPreviousTutorialViewController(_ page: Int) -> Void{
        _ = navigationController?.popViewController(animated: true)
    }
    
//    func updateSegmentedControl()->Void{
//        print("hello")
////        switch segment.selectedSegmentIndex{
////                        case 0: self?.configureContent(currentTitle: "0", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
////                        case 1: self?.configureContent(currentTitle: "1", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
////                        case 2: self?.configureContent(currentTitle: "2", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
////                        default: break
////    }
//}
}

struct TutorialBinding{
    static func bind(view: TutorialView, viewController: TutorialViewController, model: PhotographyModel){
        view.tutorialContent = model
        view.nextSection = viewController.pushNextTutorialViewController
        view.previousSection = viewController.pushNextTutorialViewController
//        view.pressSelector = viewController.updateSegmentedControl
    }
}
