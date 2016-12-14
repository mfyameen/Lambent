import UIKit

struct TutorialSetUp{
   var currentPage: Int
   var currentSegment: Int
}

class TutorialViewController: UIViewController{
    private let setUp: TutorialSetUp
    init(setUp: TutorialSetUp){
        self.setUp = setUp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tutorialView = TutorialView(setUp: setUp)
        let photographyModel = PhotographyModel()
        view = tutorialView
        title = photographyModel.steps[setUp.currentPage]
        let backButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(returnHome))
        navigationItem.setLeftBarButton(backButton, animated: true)
        TutorialBinding.bind(view: tutorialView, viewController: self, model: photographyModel )
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.hidesBarsOnSwipe = false
//    }
    
    func returnHome(){
        _ = navigationController?.popToRootViewController(animated: true)
    }

    func pushNextTutorialViewController(_ page: Int, _ segment: Int) -> Void{
        let setUp = TutorialSetUp(currentPage: page, currentSegment: segment)
        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: true)
    }
    
    func pushPreviousTutorialViewController() -> Void{
        _ = navigationController?.popViewController(animated: true)
    }
}


struct TutorialBinding{
    static func bind(view: TutorialView, viewController: TutorialViewController, model: PhotographyModel){
        view.tutorialContent = model
        view.nextSection = viewController.pushNextTutorialViewController
        view.previousSection = viewController.pushPreviousTutorialViewController
    }
}
