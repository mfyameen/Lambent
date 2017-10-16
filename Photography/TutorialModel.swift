import Foundation
import RxSugar
import RxSwift

public enum Page: Int {
    case overview = 0
    case aperture = 1
    case shutter = 2
    case iso = 3
    case focal = 4
    case modes = 5
    
    func description() -> String {
        switch self {
        case .overview: return "Intro"
        case .aperture: return "Aperture"
        case .shutter: return "Shutter Speed"
        case .iso: return "ISO"
        case .focal: return "Focal Length"
        case .modes: return "Modes"
        }
    }
    
    func briefDescription() -> String {
        switch self {
        case .shutter: return "Shutter"
        case .focal: return "Focal"
        default: return self.description()
        }
    }
}

public enum Segment: Int {
    case intro = 0
    case demo = 1
    case practice = 2
}

public struct TutorialSetUp {
    let currentPage: Page
    let currentSegment: Segment
    public init(currentPage: Page, currentSegment: Segment) {
        self.currentPage = currentPage
        self.currentSegment = currentSegment
    }
}

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
    private let setUp: TutorialSetUp
    private let content: Content
    private var tutorial = TutorialSettings()
    
    let selectNext: Observable<TutorialSetUp>
    private let _selectNext = PublishSubject<TutorialSetUp>()
    let selectPrevious: Observable<TutorialSetUp>
    let _selectPrevious = PublishSubject<TutorialSetUp>()
    let currentTutorialSettings: Observable<TutorialSettings>
    private let _currentTutorialSettings = Variable<TutorialSettings>(TutorialSettings())
    
    public init (setUp: TutorialSetUp, content: Content) {
        self.setUp = setUp
        currentTutorialSettings = _currentTutorialSettings.asObservable()
        selectNext = _selectNext.asObservable()
        selectPrevious = _selectPrevious.asObservable()
        self.content = content
        configureContent()
        configureToolBarButtonTitles()
    }
    
    public func configureContent() {
        if setUp.currentPage == .overview {
            tutorial.content = content.introductions[setUp.currentPage.rawValue]
            tutorial.title = "Lighting"
        } else {
            configureAppropriateSegment(setUp.currentSegment)
        }
        _currentTutorialSettings.value = tutorial
    }
    
    func configureAppropriateSegment(_ segment: Segment) {
        switch (segment, setUp.currentPage) {
        case (.intro, .modes): fallthrough
        case (.demo, .modes): fallthrough
        case (.practice, .modes):
            tutorial.isDemoScreen = false
            tutorial.content = content.modeIntroductions[segment.rawValue]
        case (.intro, _):
            tutorial.isDemoScreen = false
            tutorial.content = content.introductions[setUp.currentPage.rawValue]
        case (.demo, _):
            tutorial.isDemoScreen = true
        case (.practice, _):
            tutorial.isDemoScreen = false
            tutorial.content = content.exercises[setUp.currentPage.rawValue]
        }
        _currentTutorialSettings.value = tutorial
    }
    
    public func configureToolBarButtonTitles()  {
        if setUp.currentPage == .overview {
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
            tutorial.backArrowHidden = true
        } else if setUp.currentPage == .modes {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
            tutorial.nextArrowHidden = true
        } else {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        }
        _currentTutorialSettings.value = tutorial
    }
    
    private func obtainSectionTitleFor(nextSection: Int) -> String {
        guard let section = Page(rawValue: setUp.currentPage.rawValue + nextSection) else { return "" }
        return section.briefDescription()
    }

    public func registerSwipe(_ direction: Direction) {
        let pageMinLimit = 0
        let pageMaxLimit = content.sections.count - 1
        if direction == .left && setUp.currentPage.rawValue >= pageMinLimit {
            guard let currentPage = Page(rawValue: setUp.currentPage.rawValue + 1) else { return }
            _selectNext.onNext(TutorialSetUp(currentPage: currentPage, currentSegment: setUp.currentSegment))
        } else if direction == .right && setUp.currentPage.rawValue <= pageMaxLimit {
            guard let currentPage = Page(rawValue: setUp.currentPage.rawValue - 1) else { return }
            _selectPrevious.onNext(TutorialSetUp(currentPage: currentPage, currentSegment: setUp.currentSegment))
        }
    }
    
    public func configurePageControlMovement(_ currentPageControlPage: Int) {
        if currentPageControlPage > setUp.currentPage.rawValue {
            guard let currentPage = Page(rawValue: setUp.currentPage.rawValue + 1) else { return }
            _selectNext.onNext(TutorialSetUp(currentPage: currentPage, currentSegment: setUp.currentSegment))
        } else {
            guard let currentPage = Page(rawValue: setUp.currentPage.rawValue - 1) else { return }
            _selectPrevious.onNext(TutorialSetUp(currentPage: currentPage, currentSegment: setUp.currentSegment))
        }
    }
}
