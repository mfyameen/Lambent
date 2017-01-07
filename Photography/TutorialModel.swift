import Foundation

struct TutorialSettings {
    var backButtonTitle = ""
    var nextButtonTitle = ""
    var title = ""
    var content = ""
    var isDemoScreen = false
    var numberOfSections = 0
}

public class TutorialModel {
    private var isDemoScreen = false
    var currentPage: Page
    var currentSegment: Segment
    var tutorial = TutorialSettings()
    var nextSection: (Page, Segment)-> Void = { _ in }
    var page: Int?

    var tutorialContent = PhotographyModel()
    
    var shareTutorialSettings: (TutorialSettings)-> Void = { _ in }
    
    init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        tutorial.numberOfSections = tutorialContent.sections.count
    }
    
    func configureContent() {
        tutorial.title = tutorialContent.sectionTitles[currentPage.rawValue]
        if currentPage.rawValue == 0 {
           tutorial.content = tutorialContent.introContent[currentPage.rawValue]
        } else {
            configureAppropriateSegment(segment: currentSegment.rawValue)
        }
    }
    
    func configureAppropriateSegment(segment: Int) {
        guard let segment = Segment(rawValue: segment) else { return }
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
    
    func configureToolBarButtonTitles()  {
        let maxLimit = tutorialContent.sections.count - 1
        let minLimit = 0

        if currentPage.rawValue > minLimit && currentPage.rawValue < maxLimit {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        } else if currentPage.rawValue <= minLimit {
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        } else if currentPage.rawValue >= maxLimit {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
        }
        shareTutorialSettings(tutorial)
    }
    
    private func obtainSectionTitleFor(nextSection: Int) -> String {
        return tutorialContent.sections[currentPage.rawValue + nextSection]
    }
    
    func configureScrollViewMovement(contentOffsetX: Float) {
        let scrollMinLimit = 0
        let scrollMaxLimit = tutorialContent.sections.count - 1
        if contentOffsetX < 0 && currentPage.rawValue > scrollMinLimit {
            guard let currentPage = Page(rawValue: currentPage.rawValue - 1) else { return }
            nextSection(currentPage, currentSegment)
        } else if contentOffsetX > 0 && currentPage.rawValue < scrollMaxLimit{
            guard let currentPage = Page(rawValue: currentPage.rawValue + 1) else { return }
            nextSection(currentPage, currentSegment)
        }
    }

    func configurePageControlMovement(currentPageControlPage: Int) {
        if currentPageControlPage > currentPage.rawValue {
            guard let currentPage = Page(rawValue: currentPage.rawValue + 1) else { return }
            nextSection(currentPage, currentSegment)
        } else {
            guard let currentPage = Page(rawValue: currentPage.rawValue - 1) else { return }
            nextSection(currentPage, currentSegment)
        }
    }
}
