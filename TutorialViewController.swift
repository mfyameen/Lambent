import UIKit

class TutorialViewController: UIViewController {
    
    override func loadView() {
        let tutorialView = TutorialView()
        let photographyModel = PhotographyModel()
        view = tutorialView
        title = "Get Started"
        TutorialBinding.bind(view: tutorialView, model: photographyModel )
    }
}

struct TutorialBinding{
    static func bind(view: TutorialView, model: PhotographyModel){
        view.tutorialContent = model
    }
}
