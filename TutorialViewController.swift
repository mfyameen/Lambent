import UIKit

class TutorialViewController: UIViewController {
    private let setUp: TutorialSetUp
    private let content: Content
    
    init(setUp: TutorialSetUp, content: Content) {
        self.setUp = setUp
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tutorialView = TutorialView(setUp: setUp, tutorialContent: content)
        view = tutorialView
        let tutorialModel = TutorialModel(setUp: setUp, content: content)
        let demoModel = DemoModel(setUp: setUp, content: content)
        title = content.sections[setUp.currentPage.rawValue]
        let button = configureButton()
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        TutorialBinding.bind(tutorialView: tutorialView, tutorialModel: tutorialModel, demoView: tutorialView.demo, demoModel: demoModel, viewController: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
 
    func configureButton() -> UIButton {
        let button = UIButton()
        let image = UIImage(named: "backicon")
        button.setImage(image, for: .normal)
        button.setTitle("Home", for: .normal)
        button.addTarget(self, action: #selector(returnHome), for: .touchUpInside)
        button.setTitleColor(UIColor.navigationTextColor(), for: .normal)
        button.sizeToFit()
        return button
    }

    func pushNextTutorialViewController(_ page: Page, _ segment: Segment?) -> Void {
        let setUp = TutorialSetUp(currentPage: page, currentSegment: segment)
        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp, content: content), animated: true)
    }
    
    func pushPreviousTutorialViewController(_ page: Page, _ segment: Segment?) {
        let setUp = TutorialSetUp(currentPage: page, currentSegment: segment)
        let transition = configureTransition()
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp, content: content), animated: false)
    }
    
    func configureTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return transition
    }
    
    func returnHome() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}

struct TutorialBinding {
    static func bind(tutorialView: TutorialView, tutorialModel: TutorialModel, demoView: DemoView, demoModel: DemoModel, viewController: TutorialViewController){
        tutorialView.prepareContent = tutorialModel.configureContent
        tutorialView.prepareToolBar = tutorialModel.configureToolBarButtonTitles
        tutorialView.prepareSwipe = tutorialModel.configureSwipe
        tutorialView.preparePageControl = tutorialModel.configurePageControlMovement
        tutorialView.prepareSegment = tutorialModel.configureAppropriateSegment
        tutorialModel.shareTutorialSettings = tutorialView.addInformation
        tutorialView.prepareDemo = demoModel.configureDemo
        demoModel.shareInformation = demoView.addInformation
        tutorialView.photographyContent = tutorialModel
        tutorialModel.nextSection = viewController.pushNextTutorialViewController
        tutorialModel.previousSection = viewController.pushPreviousTutorialViewController
        demoView.movedSlider = demoModel.configureDemo
        demoModel.shareInformation = demoView.addInformation
    }
}
