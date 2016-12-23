import UIKit

struct TutorialSetUp {
   var currentPage: Int
   var currentSegment: Int
}

class TutorialViewController: UIViewController {
    private let setUp: TutorialSetUp
    init(setUp: TutorialSetUp) {
        self.setUp = setUp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tutorialView = TutorialView(setUp: setUp)
        let demoView = DemoView()
        let demoModel = DemoModel()
        let photographyModel = PhotographyModel()
        view = tutorialView
        title = photographyModel.sections[setUp.currentPage]
        let backButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(returnHome))
        navigationItem.setLeftBarButton(backButton, animated: true)
        TutorialBinding.bind(tutorialView: tutorialView, demoView: demoView, viewController: self, photographyModel: photographyModel, demoModel: demoModel)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.hidesBarsOnSwipe = false
//    }
    
    func returnHome() {
        _ = navigationController?.popToRootViewController(animated: true)
    }

    func pushNextTutorialViewController(_ page: Int, _ segment: Int) -> Void {
        let setUp = TutorialSetUp(currentPage: page, currentSegment: segment)
        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: true)
    }
}


struct TutorialBinding {
    static func bind(tutorialView: TutorialView, demoView: DemoView, viewController: TutorialViewController, photographyModel: PhotographyModel, demoModel: DemoModel){
        tutorialView.tutorialContent = photographyModel
        tutorialView.nextSection = viewController.pushNextTutorialViewController
        tutorialView.prepareDemo = demoModel.configureAppropriateSectionWhenInitialized
        TutorialView.movedSlider = demoModel.letUsMove
        demoModel.shareInformation = demoView.addStuff
       // demoView.addInformation = demoModel.shareInformation
    }
}
