import UIKit

public enum Page: Int {
    case overview = 0
    case aperture = 1
    case shutter = 2
    case iso = 3
    case focal = 4
    case modes = 5
}

public enum Segment: Int {
    case intro = 0
    case demo = 1
    case practice = 2
}

public struct TutorialSetUp {
   var currentPage: Page
   var currentSegment: Segment?
    public init(currentPage: Page, currentSegment: Segment?) {
        self.currentPage = currentPage
        self.currentSegment = currentSegment
    }
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
        let tutorialModel = TutorialModel(setUp: setUp)
        let demoModel = DemoModel(setUp: setUp)
        let photographyModel = PhotographyModel()
        view = tutorialView
        title = photographyModel.sections[setUp.currentPage.rawValue]
        navigationController?.hidesBarsOnSwipe = false
        let homeButton = UIButton()
        let image = UIImage(named: "backicon")
        homeButton.setImage(image, for: .normal)
        homeButton.setTitle("Home", for: .normal)
        homeButton.addTarget(self, action: #selector(returnHome), for: .touchUpInside)
        homeButton.setTitleColor(UIColor.buttonColor(), for: .normal)
        homeButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeButton)
        TutorialBinding.bind(tutorialView: tutorialView, tutorialModel: tutorialModel, demoView: tutorialView.demo, viewController: self, photographyModel: photographyModel, demoModel: demoModel)
    }
    
    func returnHome() {
        _ = navigationController?.popToRootViewController(animated: true)
    }

    func pushNextTutorialViewController(_ page: Page, _ segment: Segment?) -> Void {
        let setUp = TutorialSetUp(currentPage: page, currentSegment: segment)
        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: true)
    }
    
    func pushPreviousTutorialViewController(_ page: Page, _ segment: Segment?) {
        let setUp = TutorialSetUp(currentPage: page, currentSegment: segment)
        
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        navigationController?.view.layer.add(transition, forKey: nil)

        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp), animated: false)
    }
}

struct TutorialBinding {
    static func bind(tutorialView: TutorialView, tutorialModel: TutorialModel, demoView: DemoView, viewController: TutorialViewController, photographyModel: PhotographyModel, demoModel: DemoModel){
        tutorialView.prepareContent = tutorialModel.configureContent
        tutorialView.prepareToolBar = tutorialModel.configureToolBarButtonTitles
        tutorialView.prepareScrollView = tutorialModel.configureScrollViewMovement
        tutorialView.preparePageControl = tutorialModel.configurePageControlMovement
        tutorialView.prepareSegment = tutorialModel.configureAppropriateSegment
        tutorialModel.shareTutorialSettings = tutorialView.addInformation
        tutorialView.prepareDemo = demoModel.configureDemo
        demoModel.shareInformation = demoView.addInformation
        tutorialView.tutorialContent = tutorialModel
        tutorialModel.nextSection = viewController.pushNextTutorialViewController
        tutorialModel.previousSection = viewController.pushPreviousTutorialViewController
        DemoView.movedSlider = demoModel.configureDemo
        demoModel.shareInformation = demoView.addInformation
    }
}
