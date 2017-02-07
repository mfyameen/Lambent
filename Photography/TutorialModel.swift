import Foundation

public struct TutorialSettings {
    public init() {}
    public var backButtonTitle = ""
    public var nextButtonTitle = ""
    public var nextArrowHidden = false
    public var backArrowHidden = false
    public var title = ""
    public var content = ""
    public var isDemoScreen = false
}

public class TutorialModel {
    private var currentPage: Page
    private var currentSegment: Segment?
    private var content: Content
    private var tutorial = TutorialSettings()
    
    public var nextSection: (Page, Segment?)-> Void = { _ in }
    public var previousSection: (Page, Segment?)-> Void = { _ in}
    public var shareTutorialSettings: (TutorialSettings)-> Void = { _ in }
    
    public init (setUp: TutorialSetUp, content: Content) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        self.content = content
    }
    
    public func configureContent() {
        if currentPage == .overview {
            tutorial.content = content.introductions[currentPage.rawValue]
            tutorial.title = "Lighting"
        } else {
            configureAppropriateSegment(segment: currentSegment)
        }
        shareTutorialSettings(tutorial)
    }
    
    func configureAppropriateSegment(segment: Segment?) {
        guard let segment = segment else { return }
        switch (segment, currentPage) {
        case (.intro, .modes): fallthrough
        case (.demo, .modes): fallthrough
        case (.practice, .modes):
            tutorial.isDemoScreen = false
            tutorial.content = content.modeIntroductions[segment.rawValue]
        case (.intro, _):
            tutorial.isDemoScreen = false
            tutorial.content = content.introductions[currentPage.rawValue]
        case (.demo, _):
            tutorial.isDemoScreen = true
        case (.practice, _):
            tutorial.isDemoScreen = false
            tutorial.content = content.exercises[currentPage.rawValue]
        }
        shareTutorialSettings(tutorial)
    }
    
    public func configureToolBarButtonTitles()  {
        if currentPage == .overview {
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
            tutorial.backArrowHidden = true
        } else if currentPage == .modes {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
            tutorial.nextArrowHidden = true
        } else {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        }
        shareTutorialSettings(tutorial)
    }
    
    private func obtainSectionTitleFor(nextSection: Int) -> String {
        let sectionTitle = content.sections[currentPage.rawValue + nextSection]
        guard let title = CameraSections(rawValue: sectionTitle) else { return "Intro" }
        switch title {
        case .focal: return "Focal"
        case .shutter: return "Shutter"
        default: return title.rawValue
        }
    }

    public func configureSwipe(direction: Direction) {
        let pageMinLimit = 0
        let pageMaxLimit = content.sections.count - 1
        if direction == .left && currentPage.rawValue >= pageMinLimit {
            guard let currentPage = Page(rawValue: currentPage.rawValue + 1) else { return }
            nextSection(currentPage, currentSegment ?? Segment.intro)
        } else if direction == .right && currentPage.rawValue <= pageMaxLimit {
            guard let currentPage = Page(rawValue: currentPage.rawValue - 1) else { return }
            previousSection(currentPage, currentSegment ?? Segment.intro)
        }
    }
    
    public func configurePageControlMovement(currentPageControlPage: Int) {
        if currentPageControlPage > currentPage.rawValue {
            guard let currentPage = Page(rawValue: currentPage.rawValue + 1) else { return }
            nextSection(currentPage, currentSegment ?? Segment.intro)
        } else {
            guard let currentPage = Page(rawValue: currentPage.rawValue - 1) else { return }
            previousSection(currentPage, currentSegment ?? Segment.intro)
        }
    }
}
