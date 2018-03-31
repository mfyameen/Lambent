import UIKit
import StoreKit
import RxSwift
import RxSugar

public enum Direction {
    case right
    case left
}

class TutorialView: UIScrollView {
    private let contentView: ContentView
    private let pageControl = UIPageControl()
    private let customToolBar = UIView()
    private let nextButton = UIButton()
    private let nextButtonArrow = UIImageView()
    private let backButton = UIButton()
    private let backButtonArrow = UIImageView()
    private let swipeRight = UISwipeGestureRecognizer()
    private let swipeLeft = UISwipeGestureRecognizer()
    private let currentPage: Page
    
    let currentTutorialSettings: AnyObserver<TutorialSettings>
    private let _currentTutorialSettings = PublishSubject<TutorialSettings>()
    let currentSegmentValue: Observable<Segment>
    let trackSegment: Observable<Segment>
    let currentSliderValue: Observable<Int>
    let currentDemoSettings: AnyObserver<CameraSectionDemoSettings>
    private let _currentDemoSettings = PublishSubject<CameraSectionDemoSettings>()
    let pageControlSettings: Observable<Int>
    private let _pageControlSettings = PublishSubject<Int>()
    let swipe: Observable<Direction>
    private let _swipe = PublishSubject<Direction>()
    
    init(setUp: TutorialSetUp, numberOfSections: Int, imageContent: ImageContent) {
        currentPage = setUp.currentPage
        contentView = ContentView(setUp: setUp, imageContent: imageContent)
        currentTutorialSettings = _currentTutorialSettings.asObserver()
        currentSegmentValue = contentView.currentSegmentValue
        currentSliderValue = contentView.currentSliderValue
        currentDemoSettings = _currentDemoSettings.asObserver()
        pageControlSettings = _pageControlSettings.asObservable()
        trackSegment = contentView.trackSegment
        swipe = _swipe.asObservable()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        backgroundColor = UIColor.backgroundColor()
        layoutPageControl(numberOfSections)
        requestReview(setUp.currentSegment)
        layoutSwipeGestures([swipeRight, swipeLeft])
        layoutToolBarButtons([nextButton, backButton])
        layoutToolBarArrows([nextButtonArrow, backButtonArrow])
        addSubviews([contentView, customToolBar, nextButton, nextButtonArrow, backButton, backButtonArrow, pageControl])
        
        rxs.disposeBag
            ++ contentView.tutorialSettings <~ _currentTutorialSettings.asObservable()
            ++ { [weak self] in self?.configureToolBar($0) } <~ _currentTutorialSettings.asObservable()
            ++ { [weak self] in self?.requestReview($0) } <~ currentSegmentValue
            ++ contentView.currentDemoSettings <~ _currentDemoSettings.asObservable()
    }
    
    private func requestReview(_ segment: Segment) {
        let launches = UserDefaults.standard.integer(forKey: "launch")
        let requestedReview = UserDefaults.standard.bool(forKey: "requested review")
        let numberOfLaunchesRequired = 3
        guard segment == .demo && launches % numberOfLaunchesRequired == 0 && requestedReview == false else { return }
        UserDefaults.standard.set(true, forKey: "requested review")
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    func configureToolBar(_ settings: TutorialSettings) {
        backButton.setTitle(settings.backButtonTitle, for: .normal)
        backButtonArrow.isHidden = settings.backArrowHidden
        nextButton.setTitle(settings.nextButtonTitle, for: .normal)
        nextButtonArrow.isHidden = settings.nextArrowHidden
    }
    
    private func layoutSwipeGestures(_ gestures: [UISwipeGestureRecognizer]) {
        gestures.forEach({ gesture in
            gesture.addTarget(self, action: #selector(swipeBetweenPages(swipe:)))
            gesture.direction = gesture == swipeRight ? .right : .left
            addGestureRecognizer(gesture)
        })
    }
    
    @objc private func swipeBetweenPages(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case .right: _swipe.onNext(.right)
        case .left: _swipe.onNext(.left)
        default: break
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        [swipeLeft, swipeRight].forEach({ $0.isEnabled = !contentView.demo.sliderFrame.contains(point) })
        return super.hitTest(point, with: event)
    }
    
    private func layoutPageControl(_ numberOfSections: Int) {
        pageControl.currentPageIndicatorTintColor = UIColor.gray
        pageControl.numberOfPages = numberOfSections
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPage = currentPage.rawValue
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }
    
    @objc private func pageControlValueChanged() {
        _pageControlSettings.onNext(pageControl.currentPage)
    }
    
    private func layoutToolBarButtons(_ buttons: [UIButton]) {
        buttons.forEach({ $0.setTitleColor(UIColor.navigationTextColor(), for: .normal) })
    }
    
    private func layoutToolBarArrows(_ images: [UIImageView]){
        images.forEach({
            $0.image = UIImage(named: $0 == nextButtonArrow ? "nexticon" : "backicon")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let insets: UIEdgeInsets
        let verticalInset: CGFloat = 75
        let horizontalInset: CGFloat = 18
        if #available(iOS 11.0, *) {
            insets = UIEdgeInsets(top: safeAreaInsets.top + Padding.large, left: horizontalInset, bottom: safeAreaInsets.bottom + Padding.large, right: horizontalInset)
        } else {
            insets = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        let pageControlSize = pageControl.sizeThatFits(contentArea.size)
        contentView.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height - pageControlSize.height)
        let pageControlTop = (contentView.frame.maxY + bounds.maxY)/2 - pageControlSize.height/2
        pageControl.frame = CGRect(x: contentArea.midX - pageControlSize.width/2, y: pageControlTop, width: pageControlSize.width, height: pageControlSize.height)
        let toolBarHeight: CGFloat = 44
        let toolBarTop = (contentView.frame.maxY + bounds.maxY)/2 - toolBarHeight/2
        customToolBar.frame = CGRect(x: contentArea.minX, y: toolBarTop, width: contentArea.width, height: toolBarHeight)
        let arrowSize: CGFloat = 24
        let arrowTop = customToolBar.frame.midY - arrowSize/2
        backButtonArrow.frame = CGRect(x: customToolBar.frame.minX, y: arrowTop, width: arrowSize, height: arrowSize)
        nextButtonArrow.frame = CGRect(x: customToolBar.frame.maxX - arrowSize, y: arrowTop, width: arrowSize, height: arrowSize)
        let minimumButtonWidth: CGFloat = 44
        let backButtonSize = backButton.sizeThatFits(contentArea.size)
        let backButtonWidth = max(backButtonSize.width, minimumButtonWidth)
        backButton.frame = CGRect(x: backButtonArrow.frame.maxX, y: customToolBar.frame.midY - backButtonSize.height/2, width: backButtonWidth, height: backButtonSize.height)
        let nextButtonSize = nextButton.sizeThatFits(contentArea.size)
        let nextButtonWidth = max(nextButtonSize.width, minimumButtonWidth)
        nextButton.frame = CGRect(x: nextButtonArrow.frame.minX - nextButtonWidth, y: customToolBar.frame.midY - nextButtonSize.height/2, width: nextButtonWidth, height: nextButtonSize.height)
    }
}
