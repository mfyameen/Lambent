import UIKit
import RxSugar
import RxSwift

class TutorialViewController: GAITrackedViewController {
    private let setUp: TutorialSetUp
    private let content: Content
    private let imageContent: ImageContent
    
    init(setUp: TutorialSetUp, content: Content, imageContent: ImageContent) {
        self.setUp = setUp
        self.content = content
        self.imageContent = imageContent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tutorialModel = TutorialModel(setUp: setUp, content: content)
        let demoModel = DemoModel(currentPage: setUp.currentPage, content: content)
        let tutorialView = TutorialView(setUp: setUp, numberOfSections: content.sections.count, imageContent: imageContent)
        view = tutorialView
        title = content.sections[setUp.currentPage.rawValue]
        let button = configureButton()
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        TutorialBinding.bind(tutorialView: tutorialView, tutorialModel: tutorialModel, demoModel: demoModel, viewController: self)
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

    func pushNextTutorialViewController(_ setUp: TutorialSetUp) -> Void {
        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp, content: content, imageContent: imageContent), animated: true)
    }
    
    func pushPreviousTutorialViewController(_ setUp: TutorialSetUp) {
        let transition = configureTransition()
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.pushViewController(TutorialViewController(setUp: setUp, content: content, imageContent: imageContent), animated: false)
    }
    
    func configureTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return transition
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenName = "\(setUp.currentPage) - \(setUp.currentSegment)"
    }
    
    func trackSegment(_ segment: Segment) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "\(setUp.currentPage) - \(segment)")
        let builder = GAIDictionaryBuilder.createScreenView().build() as [NSObject: AnyObject]
        tracker?.send(builder)
    }
    
    @objc private func returnHome() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}

struct TutorialBinding {
    static func bind(tutorialView: TutorialView, tutorialModel: TutorialModel, demoModel: DemoModel, viewController: TutorialViewController){
        tutorialView.rxs.disposeBag
            ++ tutorialView.currentTutorialSettings <~ tutorialModel.currentTutorialSettings
            ++ { tutorialModel.registerSwipe($0) } <~ tutorialView.swipe
            ++ { tutorialModel.configurePageControlMovement($0) } <~ tutorialView.pageControlSettings
            ++ { tutorialModel.configureAppropriateSegment($0) } <~ tutorialView.currentSegmentValue
            ++ { demoModel.configureDemo($0) } <~ tutorialView.currentSliderValue
            ++ tutorialView.currentDemoSettings <~ demoModel.currentDemoSettings
            ++ { viewController.trackSegment($0) } <~ tutorialView.trackSegment
            ++ { viewController.pushNextTutorialViewController($0) } <~ tutorialModel.selectNext
            ++ { viewController.pushPreviousTutorialViewController($0) } <~ tutorialModel.selectPrevious
    }
}
