import UIKit

class TutorialView: UIScrollView, UIScrollViewDelegate{
    private let container = UIView()
    private let pageControl = UIPageControl()
    private let scrollView = UIScrollView()
    private let toolBar = UIToolbar()
    private let title = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "flower"))
    private let content = UILabel()
    private var segmentedControl = UISegmentedControl()
    private let slider = UISlider()
    private let demoInstructions = UILabel()
    private let setUp: TutorialSetUp
    private var backButtonTitle: String? = nil
    private var nextButtonTitle: String? = nil
    private var isDemoScreen = false
    private var lastContentOffset: CGFloat = 0
    
    var currentPage: Int
    var currentSegment: Int
    
    var nextSection:(Int, Int)-> Void = { _ in }
    var pressSelector: ()->() = { _ in }
    
    var tutorialContent: PhotographyModel? {
        didSet {
            let steps = tutorialContent?.steps.count ?? 0
            let title = tutorialContent?.sectionTitles[currentPage] ?? ""
            let content = configureAppropriateSegment(segment: currentSegment)

            configureContent(currentTitle: title, currentContent: content)
            configureToolBarButtonTitles(steps: steps)
            configureToolBar(backButtonTitle, nextButtonTitle)
            configurePageControl(steps)
        }
    }
    init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        self.setUp = setUp
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        
        backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        container.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        container.layer.cornerRadius = 8
        
        title.font = UIFont.boldSystemFont(ofSize: 14)
        content.font = UIFont.systemFont(ofSize: 14)
        content.numberOfLines = 0
        
        HelperMethods.configureShadow(element: container)
        configureSegmentedControl(currentPage)
        configureDemo()
        addSubviews([container, scrollView, segmentedControl, slider, title, content, demoInstructions, imageView, toolBar, pageControl])
    }
    
    private func configureContent(currentTitle: String?, currentContent: String) {
        title.text = currentTitle
        content.text = currentContent
        if isDemoScreen {
            demoInstructions.text = currentContent
            imageView.isHidden = false
            slider.isHidden = false
            demoInstructions.isHidden = false
        } else {
            imageView.isHidden = true
            slider.isHidden = true
            demoInstructions.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
     
            print("moving up")
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            
            print("moving down")
        }
        self.lastContentOffset = scrollView.contentOffset.x
    }
    
    private func configureDemo(){
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
        demoInstructions.isHidden = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        
        slider.isHidden = true
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    @objc private func sliderValueChanged() {
    }
    
    private func configurePageControl(_ steps: Int) {
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00)
        pageControl.numberOfPages = steps
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPage = currentPage
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }
    
    @objc private func pageControlValueChanged() {
        if pageControl.currentPage > currentPage {
            currentPage = currentPage + 1
            pageControl.currentPage = pageControl.currentPage + 1
        } else {
            currentPage = currentPage - 1
            pageControl.currentPage = pageControl.currentPage - 1
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
        setNeedsLayout()
        guard let segment = SegmentControl(rawValue: segment) else { return "" }
        switch segment {
        case .intro:
            isDemoScreen = false
            return tutorialContent?.content[currentPage] ?? ""
        case .demo:
            isDemoScreen = true
            return tutorialContent?.demoInstructions[currentPage] ?? ""
        case .practice:
            isDemoScreen = false
            return tutorialContent?.practice[currentPage] ?? ""
        }
    }
    
    private func configureToolBar(_ backButtonTitle: String?, _ nextButtonTitle: String?) {
        let backButton = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: nextButtonTitle, style: .plain, target: self, action: nil)
        
        if nextButtonTitle == nil {
            nextButton.isEnabled = false
        } else if backButtonTitle == nil {
            backButton.isEnabled = false
        }
        toolBar.items = [backButton, flexibleSpace, nextButton]
        toolBar.barTintColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        toolBar.clipsToBounds = true
    }
    
    private func configureToolBarButtonTitles(steps: Int) {
        if (currentPage) > 0 && (currentPage) < steps - 1 {
            backButtonTitle = tutorialContent?.steps[currentPage - 1 ]
            nextButtonTitle = tutorialContent?.steps[currentPage + 1]
        } else if (currentPage) <= 0 {
            nextButtonTitle = tutorialContent?.steps[currentPage + 1] ?? ""
        } else if (currentPage) >= steps - 1 {
            backButtonTitle = tutorialContent?.steps[currentPage - 1] ?? ""
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
        
        imageView.frame = CGRect(x: contentArea.minX, y: segmentedControl.frame.maxY + 20, width: contentArea.width, height: contentArea.height * 0.60)
        
        let sliderHeight = slider.sizeThatFits(contentArea.size).height
        slider.frame = CGRect(x: contentArea.midX - segmentedWidth/2, y: (imageView.frame.maxY + contentArea.maxY)/2 - sliderHeight/2, width: segmentedWidth, height: sliderHeight)
        
        let demoInstructionHeight = demoInstructions.sizeThatFits(contentArea.size).height
        demoInstructions.frame = CGRect(x: contentArea.midX - segmentedWidth/2, y: (slider.frame.maxY + contentArea.maxY)/2 - demoInstructionHeight/2 , width: segmentedWidth, height: demoInstructionHeight)
        
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.midX - titleSize.width/2, y: container.frame.minY + 40, width: titleSize.width, height: titleSize.height)
        
        let contentHeight = content.sizeThatFits(contentArea.size).height
        let contentWidth = contentArea.width - insets.left - insets.right
        content.frame = CGRect(x: contentArea.midX - contentWidth/2, y: title.frame.maxY + 40, width: contentWidth, height: contentHeight)
        
        let pageControlSize = pageControl.sizeThatFits(contentArea.size)
        pageControl.frame = CGRect(x: contentArea.midX - pageControlSize.width/2, y: (container.frame.maxY + bounds.maxY)/2 - pageControlSize.height/2, width: pageControlSize.width, height: pageControlSize.height)
        
        let toolBarHeight = toolBar.sizeThatFits(contentArea.size).height
        toolBar.frame = CGRect(x: contentArea.minX, y: (container.frame.maxY + bounds.maxY)/2 - toolBarHeight/2, width: contentArea.width, height: toolBarHeight)
        
        scrollView.frame = CGRect(x: contentArea.minX, y: segmentedControl.frame.maxY, width: contentArea.size.width, height: contentArea.size.height - segmentedControl.frame.maxY)
        scrollView.contentSize = contentArea.size
    }
}
