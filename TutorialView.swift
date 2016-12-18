import UIKit

class TutorialView: UIScrollView, UIScrollViewDelegate{
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
    private var isDemoScreen = false
    private var demo = DemoView()
    private let setUp: TutorialSetUp
    
    var currentPage: Int
    var currentSegment: Int
    
    var nextSection: (Int, Int)-> Void = { _ in }
    var pressSelector: ()->() = { _ in }
    
    var tutorialContent: PhotographyModel? {
        didSet {
            let numberOfSections = tutorialContent?.sections.count ?? 0
            let title = tutorialContent?.sectionTitles[currentPage] ?? ""
            var content: String
            
            //want to refactor this
            if currentPage == 0 {
                content = tutorialContent?.introContent[currentPage] ?? ""
            } else {
                content = configureAppropriateSegment(segment: currentSegment)
            }

            configureContent(currentTitle: title, currentContent: content)
            configurePageControl(numberOfSections)
            configureToolBarButtonTitles(numberOfSections)
        }
    }
    init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        self.setUp = setUp
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        configureContainer()
        HelperMethods.configureShadow(element: container)
        configureScrollView()
        configureSegmentedControl(currentPage)
        layoutToolBarButtons([nextButton, backButton])

        addSubviews([container, scrollView, demo, segmentedControl, title, content, customToolBar, nextButton, backButton, pageControl])
    }
    
    private func configureContainer() {
        backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        container.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        container.layer.cornerRadius = 8
    }

    private func configureContent(currentTitle: String?, currentContent: String) {
        title.font = UIFont.boldSystemFont(ofSize: 14)
        content.font = UIFont.systemFont(ofSize: 14)
        content.numberOfLines = 0
        
        if isDemoScreen {
            demo.isHidden = false
            content.isHidden = true
            demo.currentSection = tutorialContent?.sections[currentPage] ?? ""
            demo.instruction = currentContent
        } else {
            demo.isHidden = true
            content.isHidden = false
            title.text = currentTitle
            content.text = currentContent
        }
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollMinLimit = 0
        let scrollMaxLimit = (tutorialContent?.sections.count ?? 0) - 1
        if scrollView.contentOffset.x < 0 && currentPage > scrollMinLimit {
            currentPage = currentPage - 1
            nextSection(currentPage, currentSegment)
        } else if scrollView.contentOffset.x > 0 && currentPage < scrollMaxLimit{
            currentPage = currentPage + 1
            nextSection(currentPage, currentSegment)
        }
    }
    
    private func configurePageControl(_ numberOfSections: Int) {
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00)
        pageControl.numberOfPages = numberOfSections
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPage = currentPage
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }
    
    @objc private func pageControlValueChanged() {
        if pageControl.currentPage > currentPage {
            currentPage += 1
        } else {
            currentPage -= 1
        }
        nextSection(currentPage, currentSegment)
    }
    
    private func configureSegmentedControl(_ currentPage: Int) {
        if currentPage != 0 {
            segmentedControl = UISegmentedControl(items: ["Intro", "Demo", "Practice"])
            segmentedControl.selectedSegmentIndex = currentSegment
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        }
    }
    
    @objc private func segmentedControlValueChanged() {
        let content = configureAppropriateSegment(segment: segmentedControl.selectedSegmentIndex)
        configureContent(currentTitle: nil, currentContent: content)
    }
    
    private func configureAppropriateSegment(segment:Int) -> String {
        guard let segment = SegmentControl(rawValue: segment) else { return "" }
        setNeedsLayout()
        switch segment {
        case .intro: isDemoScreen = false; return tutorialContent?.introContent[currentPage] ?? ""
        case .demo: isDemoScreen = true; return tutorialContent?.demoContent[currentPage] ?? ""
        case .practice: isDemoScreen = false; return tutorialContent?.practiceContent[currentPage] ?? ""
        }
    }
    
    private func layoutToolBarButtons(_ buttons: [UIButton]) {
        buttons.forEach ({
            $0.setTitleColor(UIColor(red:0.08, green:0.49, blue:0.98, alpha:1.00), for: .normal) })
    }
    
    private func configureToolBarButtonTitles(_ numberOfSections: Int) {
        var nextButtonTitle: String = ""
        var backButtonTitle: String = ""
        let maxLimit = numberOfSections - 1
        let minLimit = 0
        
        if currentPage > minLimit && currentPage < maxLimit {
            backButtonTitle = tutorialContent?.sections[currentPage - 1 ] ?? ""
            nextButtonTitle = tutorialContent?.sections[currentPage + 1] ?? ""
        } else if currentPage <= minLimit {
            nextButtonTitle = tutorialContent?.sections[currentPage + 1] ?? ""
        } else if currentPage >= maxLimit {
            backButtonTitle = tutorialContent?.sections[currentPage - 1] ?? ""
        }
        backButton.setTitle(backButtonTitle, for: .normal)
        nextButton.setTitle(nextButtonTitle, for: .normal)
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
        
        let segmentedHeight = segmentedControl.sizeThatFits(contentArea.size).height
        TutorialView.segmentedWidth = contentArea.width - insets.left - insets.right
        segmentedControl.frame = CGRect(x: contentArea.midX - TutorialView.segmentedWidth/2, y: contentArea.minY + padding, width: TutorialView.segmentedWidth, height: segmentedHeight)
        
        demo.frame = CGRect(x: contentArea.minX, y: segmentedControl.frame.maxY + padding, width: contentArea.width, height: contentArea.height - segmentedHeight - padding)
        
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
        
        scrollView.frame = CGRect(x: contentArea.minX, y: segmentedControl.frame.maxY, width: contentArea.size.width, height: contentArea.size.height - segmentedControl.frame.maxY)
        scrollView.contentSize = bounds.size
    }
}
