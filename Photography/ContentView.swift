import UIKit
import RxSugar
import RxSwift

class ContentView: UIView, UIScrollViewDelegate {
    private let container = UIView()
    let sectionContent = SectionContent()
    private var segmentedControl = UISegmentedControl()
    static var segmentedWidth = CGFloat()
    static var segmentedHeight = CGFloat()
    let demo: DemoView
    private var isDemo = false
    private let practice: PracticeView
    
    private let currentPage: Page
    private var currentSegment: Segment
    
    let tutorialSettings: AnyObserver<TutorialSettings>
    private let _tutorialSettings = PublishSubject<TutorialSettings>()
    let currentSegmentValue: Observable<Segment>
    private let _currentSegmentValue = PublishSubject<Segment>()
    let trackSegment: Observable<Segment>
    private let _trackSegment = PublishSubject<Segment>()
    let currentSliderValue: Observable<Int>
    let currentDemoSettings: AnyObserver<CameraSectionDemoSettings>
    private let _currentDemoSettings = PublishSubject<CameraSectionDemoSettings>()
    
    init(setUp: TutorialSetUp, imageContent: ImageContent) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        demo = DemoView(page: currentPage, imageContent: imageContent)
        practice = PracticeView(page: currentPage)
        tutorialSettings = _tutorialSettings.asObserver()
        currentSegmentValue = _currentSegmentValue.asObservable()
        currentSliderValue = demo.currentSliderValue
        currentDemoSettings = _currentDemoSettings.asObserver()
        trackSegment = _trackSegment.asObservable()
        super.init(frame: CGRect.zero)
        container.backgroundColor = UIColor.containerColor()
        container.layer.cornerRadius = 8
        HelperMethods.configureShadow(element: container)
        addSubview(container)
        configureSegmentedControlItems()
        segmentedControl.selectedSegmentIndex = currentSegment.rawValue
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        addSubview(segmentedControl)
        addSubview(sectionContent)
        addSubview(demo)
        practice.clipsToBounds = true
        addSubview(practice)
        
        rxs.disposeBag
            ++ { [weak self] in self?.addInformation($0) } <~ _tutorialSettings.asObservable()
            ++ { [weak self] in self?.demo.addInformation(demoInformation: $0) } <~ _currentDemoSettings.asObservable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSegmentedControlItems() {
        switch currentPage {
        case .overview: segmentedControl.isHidden = true
        case .modes: segmentedControl = UISegmentedControl(items: ["Aperture", "Shutter", "Manual"])
        default: segmentedControl = UISegmentedControl(items: ["Intro", "Demo", "Practice"])
        }
    }
    
    private func layoutAppropriateContent() {
        if isDemo || currentSegment == .demo && currentPage != .overview && currentPage != .modes {
            demo.isHidden = false
            sectionContent.isHidden = true
        } else {
            demo.isHidden = true
            sectionContent.isHidden = false
            sectionContent.setNeedsLayout()
        }
       setNeedsLayout()
    }
    
    func addInformation(_ information: TutorialSettings) {
        sectionContent.content.text = information.content
        sectionContent.section.text = information.title
        isDemo = information.isDemoScreen
    }
    
    @objc private func segmentedControlValueChanged() {
        guard let segment = Segment(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentSegment = segment
        _currentSegmentValue.onNext(currentSegment)
        _trackSegment.onNext(currentSegment)
        layoutAppropriateContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = bounds
        let inset: CGFloat = 18
        let contentLabelArea = UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset))
        let segmentedSize = currentPage == .overview ? .zero : segmentedControl.sizeThatFits(contentLabelArea.size)
        ContentView.segmentedHeight = segmentedSize.height
        ContentView.segmentedWidth = contentLabelArea.width
        segmentedControl.frame = CGRect(x: bounds.midX - contentLabelArea.width/2, y: bounds.minY + Padding.extraLarge, width: contentLabelArea.width, height: segmentedSize.height)
        let demoHeight = bounds.height - segmentedControl.frame.height - Padding.extraLarge
        demo.isHidden = !isDemo
        demo.frame = demo.isHidden ? .zero : CGRect(x: bounds.minX, y: segmentedControl.frame.maxY, width: bounds.width, height: demoHeight)
        practice.isHidden = !(currentSegment == .practice && currentPage != .overview)
        let practiceSize = practice.isHidden ? .zero : practice.sizeThatFits(bounds.size)
        practice.frame = CGRect(x: bounds.minX, y: segmentedControl.frame.maxY, width: practiceSize.width, height: practiceSize.height)
        let scrollViewPadding = currentPage == .overview ? 0 : Padding.extraLarge
        let scrollViewTopY = practice.isHidden ? segmentedControl.frame.maxY + scrollViewPadding : practice.frame.maxY
        sectionContent.frame = CGRect(x: contentLabelArea.minX, y: scrollViewTopY, width: contentLabelArea.width, height: contentLabelArea.height - Padding.extraLarge - ContentView.segmentedHeight - practice.frame.height)
    }
}
