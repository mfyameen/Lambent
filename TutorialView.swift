import UIKit
import StoreKit

public enum Direction {
    case right
    case left
}

class TutorialView: UIScrollView, UIScrollViewDelegate {
    private let container = UIView()
    private let pageControl = UIPageControl()
    private let scrollView = UIScrollView()
    private let customToolBar = UIView()
    private let nextButton = UIButton()
    private let nextButtonArrow = UIImageView()
    private let backButton = UIButton()
    private let backButtonArrow = UIImageView()
    private let title = UILabel()
    private let content = UILabel()
    private var segmentedControl = UISegmentedControl()
    static var segmentedWidth = CGFloat()
    static var segmentedHeight = CGFloat()
    public var demo: DemoView
    private let practice: PracticeView
    private let setUp: TutorialSetUp
    private var isDemo = false
    private let swipeRight = UISwipeGestureRecognizer()
    private let swipeLeft = UISwipeGestureRecognizer()
    
    private var currentPage: Page
    private var currentSegment: Segment
    private var tutorialContent: Content
    
    var prepareContent: () -> () = {}
    var prepareToolBar: ()->() = {}
    var preparePageControl: (Int)->() = { _ in }
    var prepareSwipe: (Direction)->()  = { _ in }
    var prepareSegment: (Segment) -> () = { _ in }
    var trackSegment: (Segment) -> () = { _ in }
    var prepareDemo: (Int?) -> () = { _ in }
    
    var photographyContent: TutorialModel? {
        didSet {
            prepareContent()
            prepareDemo(0)
            prepareToolBar()
            layoutPageControl(tutorialContent.sections.count)
        }
    }
    
    init(setUp: TutorialSetUp, tutorialContent: Content) {
        self.tutorialContent = tutorialContent
        self.setUp = setUp
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        demo = DemoView(page: setUp.currentPage)
        practice = PracticeView(page: setUp.currentPage)
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        maybeRequestReview()
        layoutSwipeGestures([swipeRight, swipeLeft])
        layoutContainer()
        layoutScrollView()
        layoutSegmentedControl()
        layoutContent()
        layoutAppropriateContent()
        layoutToolBarButtons([nextButton, backButton])
        layoutToolBarArrows([nextButtonArrow, backButtonArrow])
        HelperMethods.configureShadow(element: container)
        addSubviews([container, demo, practice, scrollView, segmentedControl, title, customToolBar, nextButton, nextButtonArrow, backButton, backButtonArrow, pageControl])
        scrollView.addSubview(content)
    }
    
    private func maybeRequestReview() {
        let launches = UserDefaults.standard.integer(forKey: "launch")
        let requestedReview = UserDefaults.standard.bool(forKey: "requested review")
        let numberOfLaunchesRequired = 3
        guard currentSegment == .demo && launches % numberOfLaunchesRequired == 0 && requestedReview == false else { return }
        UserDefaults.standard.set(true, forKey: "requested review")
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    func addInformation(information: TutorialSettings) {
        content.text = information.content
        title.text = information.title
        isDemo = information.isDemoScreen
        backButton.setTitle(information.backButtonTitle, for: .normal)
        nextButton.setTitle(information.nextButtonTitle, for: .normal)
        
        if information.backArrowHidden {
            backButtonArrow.isHidden = true
        } else if information.nextArrowHidden {
            nextButtonArrow.isHidden = true
        }
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
        case UISwipeGestureRecognizerDirection.right: prepareSwipe(.right)
        case UISwipeGestureRecognizerDirection.left: prepareSwipe(.left)
        default: break
        }
    }

    private func layoutContainer() {
        backgroundColor = UIColor.backgroundColor()
        container.backgroundColor = UIColor.containerColor()
        container.layer.cornerRadius = 8
    }
    
    private func layoutScrollView() {
        scrollView.delegate = self
        scrollView.bounces = false
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        swipeLeft.isEnabled = demo.sliderFrame.contains(point) ? false : true
        swipeRight.isEnabled = demo.sliderFrame.contains(point) ? false : true
        return super.hitTest(point, with: event)
    }
    
    private func layoutSegmentedControl() {
        switch currentPage {
        case .overview: segmentedControl.isHidden = true
        case .modes: segmentedControl = UISegmentedControl(items: ["Aperture", "Shutter", "Manual"])
        default: segmentedControl = UISegmentedControl(items: ["Intro", "Demo", "Practice"])
        }
        segmentedControl.selectedSegmentIndex = currentSegment.rawValue
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged() {
        guard let segment = Segment(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentSegment = segment
        prepareSegment(currentSegment)
        trackSegment(currentSegment)
        layoutAppropriateContent()
        maybeRequestReview()
    }
    
    private func layoutPageControl(_ numberOfSections: Int) {
        pageControl.currentPageIndicatorTintColor = UIColor.gray
        pageControl.numberOfPages = numberOfSections
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPage = currentPage.rawValue
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }
    
    @objc private func pageControlValueChanged() {
        preparePageControl(pageControl.currentPage)
    }
    
    private func layoutContent() {
        title.font = UIFont.boldSystemFont(ofSize: 16)
        content.font = UIFont.systemFont(ofSize: 14)
        content.numberOfLines = 0
    }
    
    private func layoutAppropriateContent() {
        if isDemo || currentSegment == .demo && currentPage != .overview && currentPage != .modes {
            demo.isHidden = false
            content.isHidden = true
            scrollView.isHidden = true
        } else {
            demo.isHidden = true
            content.isHidden = false
            scrollView.isHidden = false
        }
        setNeedsLayout()
    }
    
    private func layoutToolBarButtons(_ buttons: [UIButton]) {
        buttons.forEach({ $0.setTitleColor(UIColor.navigationTextColor(), for: .normal) })
    }
    
    private func layoutToolBarArrows(_ images: [UIImageView]){
        images.forEach({
            let image = $0 == nextButtonArrow ? "nexticon" : "backicon"
            $0.image = UIImage(named: image)
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
            insets = UIEdgeInsets(top: safeAreaInsets.top, left: horizontalInset, bottom: safeAreaInsets.bottom + 16, right: horizontalInset)
        } else {
            insets = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        let padding: CGFloat = 20
        let pageControlSize = pageControl.sizeThatFits(contentArea.size)
        container.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height - pageControlSize.height)
        TutorialView.segmentedHeight = segmentedControl.sizeThatFits(contentArea.size).height
        TutorialView.segmentedWidth = contentArea.width - insets.left - insets.right
        segmentedControl.frame = CGRect(x: contentArea.midX - TutorialView.segmentedWidth/2, y: contentArea.minY + padding, width: TutorialView.segmentedWidth, height: TutorialView.segmentedHeight)
        let demoHeight = contentArea.height - segmentedControl.frame.height - padding
        demo.frame = CGRect(x: contentArea.minX, y: segmentedControl.frame.maxY, width: contentArea.width, height: demoHeight)
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.midX - titleSize.width/2, y: container.frame.minY + TutorialView.segmentedHeight, width: titleSize.width, height: titleSize.height)
        let contentTop = (title.text?.isEmpty ?? false) ? segmentedControl.frame.maxY + padding : title.frame.maxY + padding
        let contentLabelArea = UIEdgeInsetsInsetRect(contentArea, UIEdgeInsets(top: contentTop, left: horizontalInset, bottom: verticalInset, right: horizontalInset))
        practice.isHidden = !(currentSegment == .practice && currentPage != .overview && currentPage != .modes)
        let practiceSize = practice.isHidden ? .zero : practice.sizeThatFits(contentLabelArea.size)
        practice.frame = CGRect(x: contentLabelArea.minX, y: contentLabelArea.minY, width: practiceSize.width, height: practiceSize.height)
        let contentSize = content.sizeThatFits(scrollView.contentSize)
        content.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        scrollView.frame = CGRect(x: contentLabelArea.minX, y: practice.frame.maxY + 8, width: contentLabelArea.width, height: contentLabelArea.height - practice.frame.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -4)
        scrollView.contentSize = CGSize(width: contentLabelArea.width, height: contentSize.height)
        let pageControlTop = (container.frame.maxY + bounds.maxY)/2 - pageControlSize.height/2
        pageControl.frame = CGRect(x: contentLabelArea.midX - pageControlSize.width/2, y: pageControlTop, width: pageControlSize.width, height: pageControlSize.height)
        let toolBarHeight: CGFloat = 44
        let toolBarTop = (container.frame.maxY + bounds.maxY)/2 - toolBarHeight/2
        customToolBar.frame = CGRect(x: contentArea.minX, y: toolBarTop, width: contentArea.width, height: toolBarHeight)
        let arrowSize: CGFloat = 24
        let arrowTop = customToolBar.frame.minY + backButton.frame.height/2 - arrowSize/2
        backButtonArrow.frame = CGRect(x: customToolBar.frame.minX, y: arrowTop, width: arrowSize, height: arrowSize)
        nextButtonArrow.frame = CGRect(x: customToolBar.frame.maxX - arrowSize, y: arrowTop, width: arrowSize, height: arrowSize)
        let backButtonWidth = backButton.sizeThatFits(contentArea.size).width
        backButton.frame = CGRect(x: customToolBar.frame.minX + arrowSize, y: customToolBar.frame.minY, width: backButtonWidth, height: toolBarHeight)
        let nextButtonWidth = nextButton.sizeThatFits(contentArea.size).width
        nextButton.frame = CGRect(x: customToolBar.frame.maxX - nextButtonWidth - arrowSize, y: customToolBar.frame.minY, width: nextButtonWidth, height: toolBarHeight)
    }
}
