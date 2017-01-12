import Foundation

public struct TutorialSettings {
    public init() {}
    public var backButtonTitle = ""
    public var nextButtonTitle = ""
    public var title = ""
    public var content = ""
    public var isDemoScreen = false
    public var numberOfSections = 0
}

public class TutorialModel {
    private var currentPage: Page
    private var currentSegment: Segment?
    private var tutorial = TutorialSettings()
    private var tutorialContent = PhotographyModel()
    
    public var nextSection: (Page, Segment?)-> Void = { _ in }
    var previousSection: (Page, Segment?)-> Void = { _ in}
    public var shareTutorialSettings: (TutorialSettings)-> Void = { _ in }
    
    public init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        tutorial.numberOfSections = tutorialContent.sections.count
    }
    
    public func configureContent() {
        if currentPage == .overview {
            tutorial.content = tutorialContent.introContent[currentPage.rawValue]
            tutorial.title = tutorialContent.sectionTitles[currentPage.rawValue]
        } else {
            configureAppropriateSegment(segment: currentSegment)
        }
        shareTutorialSettings(tutorial)
    }
    
    func configureAppropriateSegment(segment: Segment?) {
        guard let segment = segment else { return }
        switch segment {
        case .intro:
            tutorial.isDemoScreen = false
            tutorial.content = tutorialContent.introContent[currentPage.rawValue]
        case .demo:
            tutorial.isDemoScreen = true
        case .practice:
            tutorial.isDemoScreen = false
            tutorial.content = tutorialContent.practiceContent[currentPage.rawValue]
        }
        shareTutorialSettings(tutorial)
    }
    
    public func configureToolBarButtonTitles()  {
        if currentPage == .overview {
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        } else if currentPage == .modes {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
        } else {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        }
        shareTutorialSettings(tutorial)
    }
    
    private func obtainSectionTitleFor(nextSection: Int) -> String {
        let sectionTitle = tutorialContent.sections[currentPage.rawValue + nextSection]
        if sectionTitle == CameraSections.Focal.rawValue {
            return "Focal"
        } else if sectionTitle == CameraSections.Shutter.rawValue {
            return "Shutter"
        } else {
            return sectionTitle
        }
    }
    
    public func configureScrollViewMovement(contentOffsetX: Float) {
        let scrollMinLimit = 0
        let scrollMaxLimit = tutorialContent.sections.count - 1
        if contentOffsetX < 0 && currentPage.rawValue > scrollMinLimit {
            guard let currentPage = Page(rawValue: currentPage.rawValue - 1) else { return }
            previousSection(currentPage, currentSegment ?? Segment.intro)
        } else if contentOffsetX > 0 && currentPage.rawValue < scrollMaxLimit {
            guard let currentPage = Page(rawValue: currentPage.rawValue + 1) else { return }
            nextSection(currentPage, currentSegment ?? Segment.intro)
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
