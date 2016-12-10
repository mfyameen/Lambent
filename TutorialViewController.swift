import UIKit

class TutorialViewController: UIViewController {
    
    init(page: Int){
        super.init(nibName: nil, bundle: nil)
        let tutorialView = TutorialView()
        UserDefaults.standard.set(page, forKey: "page#")
        tutorialView.currentPage = page
        print("vc: \(tutorialView.currentPage!)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tutorialView = TutorialView()
        let photographyModel = PhotographyModel()
        view = tutorialView
        title = "Get Started"
        TutorialBinding.bind(view: tutorialView, viewController: self, model: photographyModel )
    }
    
    func pushNextTutorialViewController(_ page: Int) -> Void{
        navigationController?.pushViewController(TutorialViewController(page: page), animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }
}

struct TutorialBinding{
    static func bind(view: TutorialView, viewController: TutorialViewController, model: PhotographyModel){
        view.tutorialContent = model
        view.nextSection = viewController.pushNextTutorialViewController
    }
}
