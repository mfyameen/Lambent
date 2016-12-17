import UIKit

class TutorialView: UIScrollView, UIScrollViewDelegate{
    private let container = UIView()
    private let pageControl = UIPageControl()
    private let scrollView = UIScrollView()
    private let customToolBar = UIView()
    private let nextButton = UIButton()
    private let backButton = UIButton()
    private let title = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "flower"))
    private let content = UILabel()
    private var segmentedControl = UISegmentedControl()
    private let slider = UISlider()
    private let cameraValue = UILabel()
    private let cameraSensor = UIView()
    private let cameraSensorSize : CGFloat = 44
    private let cameraSensorOpening = UIView()
    private var cameraOpeningSize: CGFloat = 38
    private let demoInstructions = UILabel()
    private let setUp: TutorialSetUp
    private var isDemoScreen = false
    private var lastContentOffset: CGFloat = 0
    
    var currentPage: Int
    var currentSegment: Int
    let apertureValues = [2.8, 4, 5.6, 8, 11, 16, 22]
    
    var nextSection: (Int, Int)-> Void = { _ in }
    var pressSelector: ()->() = { _ in }
    
    var tutorialContent: PhotographyModel? {
        didSet {
            let steps = tutorialContent?.steps.count ?? 0
            let title = tutorialContent?.sectionTitles[currentPage] ?? ""
            var content: String
            
            if currentPage == 0 {
                content = tutorialContent?.content[currentPage] ?? ""
            } else {
                content = configureAppropriateSegment(segment: currentSegment)
            }

            configureContent(currentTitle: title, currentContent: content)
            configureToolBarButtonTitles(steps: steps)
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
        scrollView.showsHorizontalScrollIndicator = false
        
        backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        container.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        container.layer.cornerRadius = 8
        
        title.font = UIFont.boldSystemFont(ofSize: 14)
        content.font = UIFont.systemFont(ofSize: 14)
        content.numberOfLines = 0
        
        HelperMethods.configureShadow(element: container)
        configureSegmentedControl(currentPage)
        configureDemo()
        configureCustomToolBar()
        addSubviews([container, scrollView, segmentedControl, slider, title, content, cameraSensor, cameraSensorOpening, cameraValue, demoInstructions, imageView, customToolBar, nextButton, backButton, pageControl])
    }
    
    private func configureContent(currentTitle: String?, currentContent: String?) {
        title.text = currentTitle
        content.text = currentContent
        if isDemoScreen {
            demoInstructions.text = currentContent
            imageView.isHidden = false
            slider.isHidden = false
            demoInstructions.isHidden = false
            cameraValue.isHidden = false
            cameraSensor.isHidden = false
            cameraSensorOpening.isHidden = false
        } else {
            imageView.isHidden = true
            slider.isHidden = true
            demoInstructions.isHidden = true
            cameraValue.isHidden = true
            cameraSensor.isHidden = true
            cameraSensorOpening.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollMinLimit = 0
        let scrollMaxLimit = (tutorialContent?.steps.count ?? 0) - 1
        if lastContentOffset > scrollView.contentOffset.x && currentPage > scrollMinLimit{
            currentPage = currentPage - 1
            pageControl.currentPage = pageControl.currentPage - 1
            nextSection(currentPage, currentSegment)
        }
        else if lastContentOffset < scrollView.contentOffset.x && currentPage < scrollMaxLimit{
            currentPage = currentPage + 1
            pageControl.currentPage = pageControl.currentPage + 1
            nextSection(currentPage, currentSegment)
        }
        lastContentOffset = scrollView.contentOffset.y
    }
    
    private func configureDemo() {
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
        demoInstructions.isHidden = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        
        cameraValue.font = UIFont.systemFont(ofSize: 32)
        cameraValue.text = "f2.4"
        
        cameraSensor.layer.cornerRadius = cameraSensorSize/2
        cameraSensor.backgroundColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.00)
        
        cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        cameraSensorOpening.backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        
        slider.isContinuous = true
        slider.value = 2.8
        slider.minimumValue = 2.8
        slider.maximumValue = 22
        slider.isHidden = true
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    @objc private func sliderValueChanged() {
        let currentSliderValue = round(slider.value)
        switch currentSliderValue {
        case round(2.8):
            cameraValue.text = "f2.8"
            cameraOpeningSize = 38
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case 4:
            cameraValue.text = "f4"
            cameraOpeningSize = 34
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case round(5.6):
            cameraValue.text = "f5.6"
            cameraOpeningSize = 24
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case 8:
            cameraValue.text = "f8"
            cameraOpeningSize = 20
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case 11:
            cameraValue.text = "f11"
            cameraOpeningSize = 16
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case 16:
            cameraValue.text = "f16"
            cameraOpeningSize = 12
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case 22:
            cameraValue.text = "f22"
            cameraOpeningSize = 8
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        default: break
        }
        setNeedsLayout()
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
    
    private func configureCustomToolBar() {
        nextButton.setTitleColor(UIColor(red:0.08, green:0.49, blue:0.98, alpha:1.00), for: .normal)
        backButton.setTitleColor(UIColor(red:0.08, green:0.49, blue:0.98, alpha:1.00), for: .normal)
    }
    
    private func configureToolBarButtonTitles(steps: Int) {
        var nextButtonTitle: String = ""
        var backButtonTitle: String = ""
        if (currentPage) > 0 && (currentPage) < steps - 1 {
            backButtonTitle = tutorialContent?.steps[currentPage - 1 ] ?? ""
            nextButtonTitle = tutorialContent?.steps[currentPage + 1] ?? ""
        } else if (currentPage) <= 0 {
            nextButtonTitle = tutorialContent?.steps[currentPage + 1] ?? ""
        } else if (currentPage) >= steps - 1 {
            backButtonTitle = tutorialContent?.steps[currentPage - 1] ?? ""
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
        container.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height)
        
        let segmentedHeight = segmentedControl.sizeThatFits(contentArea.size).height
        let segmentedWidth = contentArea.width - insets.left - insets.right
        segmentedControl.frame = CGRect(x: contentArea.midX - segmentedWidth/2, y: contentArea.minY + 20, width: segmentedWidth, height: segmentedHeight)
        
        imageView.frame = CGRect(x: contentArea.minX, y: segmentedControl.frame.maxY + 20, width: contentArea.width, height: contentArea.height * 0.60)
        
        let padding: CGFloat = 10
        
        cameraSensor.frame = CGRect(x: contentArea.midX - cameraSensorSize - padding, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraSensorSize/2, width: cameraSensorSize, height: cameraSensorSize)
        
        cameraSensorOpening.frame = CGRect(x: cameraSensor.frame.midX - cameraOpeningSize/2, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraOpeningSize/2, width: cameraOpeningSize, height: cameraOpeningSize)
        
        let cameraValueSize = cameraValue.sizeThatFits(contentArea.size)
        cameraValue.frame = CGRect(x: contentArea.midX, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraValueSize.height/2, width: cameraValueSize.width, height: cameraValueSize.height)
        
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
