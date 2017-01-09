import UIKit

class TutorialView: UIScrollView, UIScrollViewDelegate {
    private let container = UIView()
    private let pageControl = UIPageControl()
    private let scrollView = UIScrollView()
    private let customToolBar = UIView()
    private let nextButton = UIButton()
    private let backButton = UIButton()
    private let title = UILabel()
    private let content = UILabel()
    private var segmentedControl = UISegmentedControl()
    static var segmentedWidth = CGFloat()
    static var segmentedHeight = CGFloat()
    public var demo = DemoView()
    private let setUp: TutorialSetUp
    private var isDemo = false
    private var numberOfSections = 0

    var currentPage: Page
    var currentSegment: Segment?

    var nextSection: (Int, Int)-> Void = { _ in }
    var prepareContent: () -> () = { _ in }
    var prepareToolBar: ()->() = { _ in }
    var preparePageControl: (Int)->() = { _ in }
    var prepareScrollView: (Float)->()  = { _ in }
    var prepareSegment: (Int) -> () = { _ in }
    var prepareDemo: (Int?) -> () = { _ in }
    var keepMoving: ()->() = { _ in }

    var tutorialContent: TutorialModel? {
        didSet {
            prepareDemo(0)
            prepareContent()
            prepareToolBar()
            layoutPageControl(numberOfSections)
        }
    }
    
    init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        self.setUp = setUp
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        if currentSegment == .demo && currentPage != .overview {
            demo.isHidden = false
        } else {
            demo.isHidden = true
        }
        layoutContainer()
        layoutScrollView()
        layoutSegmentedControl()
        layoutContent()
        layoutToolBarButtons([nextButton, backButton])
   
        HelperMethods.configureShadow(element: container)
        
        addSubviews([container, scrollView, segmentedControl, title, content, customToolBar, nextButton, backButton, pageControl])
        
        scrollView.addSubview(demo)
    }
    
    func addInformation(information: TutorialSettings?) {
        content.text = information?.content
        title.text = information?.title
        isDemo = information?.isDemoScreen ?? false
        numberOfSections = information?.numberOfSections ?? 0
        backButton.setTitle(information?.backButtonTitle, for: .normal)
        nextButton.setTitle(information?.nextButtonTitle, for: .normal)
        setNeedsLayout()
    }

    private func configureContent() {
        if isDemo {
            demo.isHidden = false
            content.isHidden = true
        } else {
            demo.isHidden = true
            content.isHidden = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // print(scrollView.contentOffset.x)
//        if currentPage == 5 && scrollView.contentOffset.x > 0 {
//            scrollView.isScrollEnabled = false
//            //scrollView.bounces = false
//            scrollView.isDirectionalLockEnabled = true
//            
//        } else {
//            scrollView.isScrollEnabled = true
//            prepareScrollView(Float(scrollView.contentOffset.x))
//        }
        prepareScrollView(Float(scrollView.contentOffset.x))
    }
    
    private func layoutContainer() {
        backgroundColor = UIColor.backgroundColor()
        container.backgroundColor = UIColor.containerColor()
        container.layer.cornerRadius = 8
    }
    
    private func layoutScrollView() {
        scrollView.delegate = self
//        if currentPage == 5 {
//        scrollView.isScrollEnabled = false
//        }
        //scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func layoutSegmentedControl() {
        if currentPage != .overview {
            segmentedControl = UISegmentedControl(items: ["Intro", "Demo", "Practice"])
            segmentedControl.selectedSegmentIndex = currentSegment?.rawValue ?? 0
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        }
    }
    
    @objc private func segmentedControlValueChanged() {
        prepareSegment(segmentedControl.selectedSegmentIndex)
        configureContent()
        setNeedsLayout()
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
        title.font = UIFont.boldSystemFont(ofSize: 14)
        content.font = UIFont.systemFont(ofSize: 14)
        content.numberOfLines = 0
    }
    
    private func layoutToolBarButtons(_ buttons: [UIButton]) {
        buttons.forEach ({
            $0.setTitleColor(UIColor.buttonColor(), for: .normal) })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 75, left: 18, bottom: 75, right: 18)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        let padding: CGFloat = 20
        
        container.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height)
        
        TutorialView.segmentedHeight = segmentedControl.sizeThatFits(contentArea.size).height
        TutorialView.segmentedWidth = contentArea.width - insets.left - insets.right
        segmentedControl.frame = CGRect(x: contentArea.midX - TutorialView.segmentedWidth/2, y: contentArea.minY + padding, width: TutorialView.segmentedWidth, height: TutorialView.segmentedHeight)

        demo.frame = CGRect(x: 0, y: 0, width: contentArea.width, height: contentArea.height )
        
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.midX - titleSize.width/2, y: container.frame.minY + (padding * 2), width: titleSize.width, height: titleSize.height)
        
        let contentHeight = content.sizeThatFits(contentArea.size).height
        let contentWidth = contentArea.width - insets.left - insets.right
        content.frame = CGRect(x: contentArea.midX - contentWidth/2, y: title.frame.maxY + (padding * 2), width: contentWidth, height: contentHeight)
        
        let pageControlSize = pageControl.sizeThatFits(contentArea.size)
        pageControl.frame = CGRect(x: contentArea.midX - pageControlSize.width/2, y: (container.frame.maxY + bounds.maxY)/2 - pageControlSize.height/2, width: pageControlSize.width, height: pageControlSize.height)
        
        let toolBarHeight: CGFloat = 44
        customToolBar.frame = CGRect(x: contentArea.minX, y: (container.frame.maxY + bounds.maxY)/2 - toolBarHeight/2, width: contentArea.width, height: toolBarHeight)
        
        let backButtonWidth = backButton.sizeThatFits(contentArea.size).width
        backButton.frame = CGRect(x: customToolBar.frame.minX, y: customToolBar.frame.minY, width: backButtonWidth, height: toolBarHeight)
        
        let nextButtonWidth = nextButton.sizeThatFits(contentArea.size).width
        nextButton.frame = CGRect(x: customToolBar.frame.maxX - nextButtonWidth, y: customToolBar.frame.minY, width: nextButtonWidth, height: toolBarHeight)
        
        scrollView.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height)
        scrollView.contentSize = bounds.size
    }
}
