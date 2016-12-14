import UIKit

class TutorialView: UIView {
    private let container = UIView()
    private let pageControl = UIPageControl()
    private let scrollView = UIScrollView()
    private let toolBar = UIToolbar()
    private let title = UILabel()
    private let image = UIImageView()
    private let content = UILabel()
    private var segmentedControl = UISegmentedControl()
    private let setUp: TutorialSetUp
    private var backButtonTitle: String?
    private var nextButtonTitle: String?
    
    var currentPage: Int?
   
    var currentSegment: Int?
    
    var nextSection:(Int, Int)->Void = { _ in }
    var previousSection: ()->() = { _ in }
    var pressSelector: ()->() = { _ in }
    
    var tutorialContent: PhotographyModel? {
        didSet {
            let steps = tutorialContent?.steps.count ?? 0
            let title = tutorialContent?.sectionTitles[currentPage ?? 0] ?? ""
            let content = configureAppropriateSegment(segment: currentSegment ?? 0)
            
            configureContent(currentTitle: title, currentContent: content)
            configureToolBarButtonTitles(steps: steps)
            configureToolBar(backButtonTitle, nextButtonTitle)
            configurePageControl(steps)
        }
    }
    init (setUp: TutorialSetUp) {
        self.setUp = setUp
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        
        print(currentPage)
        
        backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        container.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        container.layer.cornerRadius = 8
        
        title.font = UIFont.boldSystemFont(ofSize: 14)
        content.font = UIFont.systemFont(ofSize: 14)
        content.numberOfLines = 0
        
        HelperMethods.configureShadow(element: container)
        configureSegmentedControl(currentPage ?? 0)
        addSubviews([container, segmentedControl, image, title, content, toolBar, pageControl])
    }
    
    func configureContent(currentTitle: String?, currentContent: String) {
        title.text = currentTitle
        content.text = currentContent
    }
    
    func configurePageControl(_ steps: Int) {
        pageControl.isEnabled = false
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00)
        pageControl.numberOfPages = steps
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPage = currentPage ?? 0
    }
    
    func configureSegmentedControl(_ currentPage: Int) {
        if currentPage != 0 {
            segmentedControl = UISegmentedControl(items: ["Intro", "Demo", "Practice"])
            segmentedControl.selectedSegmentIndex = currentSegment ?? 0
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        }
    }
    
    @objc private func segmentedControlValueChanged() {
        let content = configureAppropriateSegment(segment: segmentedControl.selectedSegmentIndex)
        configureContent(currentTitle: nil, currentContent: content)
    }
    
    func configureAppropriateSegment(segment:Int) -> String {
        setNeedsLayout()
        guard let segment = SegmentControl(rawValue: segment) else { return "" }
        switch segment {
        case .intro: return tutorialContent?.content[currentPage ?? 0] ?? ""
        case .demo: break
        case .practice: return tutorialContent?.practice[currentPage ?? 0] ?? ""
        }
        return ""
    }
    
    func configureToolBar(_ backButtonTitle: String?, _ nextButtonTitle: String?) {
        let backButton = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: #selector(loadPreviousSection))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: nextButtonTitle, style: .plain, target: self, action: #selector(loadNextSection))
        
        if nextButtonTitle == nil {
            nextButton.isEnabled = false
        } else if backButtonTitle == nil {
            backButton.isEnabled = false
        }
        
        toolBar.items = [backButton, flexibleSpace, nextButton]
        toolBar.barTintColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        toolBar.clipsToBounds = true
    }
    
    @objc private func loadNextSection() {
        currentPage = (currentPage ?? 0) + 1
        nextSection(currentPage ?? 0, currentSegment ?? 0)
    }
    
    @objc private func loadPreviousSection() {
        currentPage = (currentPage ?? 0) - 1
        previousSection()
    }
    
    func configureToolBarButtonTitles(steps: Int) {
        if (currentPage ?? 0) > 0 && (currentPage ?? 0) < steps - 1 {
            backButtonTitle = tutorialContent?.steps[(currentPage ?? 0) - 1 ]
            nextButtonTitle = tutorialContent?.steps[(currentPage ?? 0) + 1]
        } else if (currentPage ?? 0) <= 0 {
            backButtonTitle = nil
            nextButtonTitle = tutorialContent?.steps[(currentPage ?? 0) + 1] ?? ""
        } else if (currentPage ?? 0) >= steps - 1 {
            backButtonTitle = tutorialContent?.steps[(currentPage ?? 0) - 1] ?? ""
            nextButtonTitle = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 75, left: 18, bottom: 75, right: 18)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        container.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height)
        
        let segmentedHeight = segmentedControl.sizeThatFits(contentArea.size).height
        let segmentedWidth = contentArea.width - insets.left - insets.right
        segmentedControl.frame = CGRect(x: contentArea.midX - segmentedWidth/2, y: contentArea.minY + 20, width: segmentedWidth, height: segmentedHeight)
        
        image.frame = CGRect(x: contentArea.minX, y: segmentedControl.frame.maxY + 8, width: contentArea.width, height: contentArea.height/2)
        
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.midX - titleSize.width/2, y: container.frame.minY + 40, width: titleSize.width, height: titleSize.height)
        
        let contentHeight = content.sizeThatFits(contentArea.size).height
        let contentWidth = contentArea.width - insets.left - insets.right
        content.frame = CGRect(x: contentArea.midX - contentWidth/2, y: title.frame.maxY + 40, width: contentWidth, height: contentHeight)
        
        let pageControlSize = pageControl.sizeThatFits(contentArea.size)
        pageControl.frame = CGRect(x: contentArea.midX - pageControlSize.width/2, y: (container.frame.maxY + bounds.maxY)/2 - pageControlSize.height/2, width: pageControlSize.width, height: pageControlSize.height)
        
        let toolBarHeight = toolBar.sizeThatFits(contentArea.size).height
        toolBar.frame = CGRect(x: contentArea.minX, y: (container.frame.maxY + bounds.maxY)/2 - toolBarHeight/2, width: contentArea.width, height: toolBarHeight)
        
        scrollView.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.size.width, height: contentArea.size.height)
    }
}
    
//    class PageControlHandler: UIScrollView, UIScrollViewDelegate{
//        
//        init(){
//            super.init(frame: CGRect.zero)
//            let tutorial = TutorialView()
//            //tutorial.scrollView.delegate = self
//            //tutorial.scrollView.isPagingEnabled = true
//            tutorial.scrollView.backgroundColor = .blue
//            
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//    }
//}
