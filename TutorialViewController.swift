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
    
    func pushNextTutorialViewController(_ page: Int) -> Void{
        navigationController?.pushViewController(TutorialViewController(page: page), animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }
    
    func pushPreviousTutorialViewController(_ page: Int) -> Void{
        _ = navigationController?.popViewController(animated: true)
    }
}

struct TutorialBinding{
    static func bind(view: TutorialView, viewController: TutorialViewController, model: PhotographyModel){
        view.tutorialContent = model
        view.nextSection = viewController.pushNextTutorialViewController
        view.previousSection = viewController.pushNextTutorialViewController
    }
}
