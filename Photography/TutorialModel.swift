import Foundation

struct TutorialSettings {
    var backButtonTitle: String = ""
    var nextButtonTitle: String = ""
    var content: String = ""
}

class TutorialModel {
    private var isDemoScreen = false
    var currentPage: Int
    var currentSegment: Int
    private let setUp: TutorialSetUp
    var tutorial = TutorialSettings()
    var nextSection: (Int, Int)-> Void = { _ in }

    var tutorialContent = PhotographyModel()
    
    var shareTutorialSettings: (TutorialSettings)-> Void = { _ in }
    
    init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        self.setUp = setUp
    }
    
    func configureContent() -> () {
        let numberOfSections = tutorialContent.sections.count
        let title = tutorialContent.sectionTitles[currentPage]
        var content: String
        if currentPage == 0 {
            content = tutorialContent.introContent[currentPage]
        } else {
           (content, _) = configureAppropriateSegment(segment: currentSegment, isDemo: isDemoScreen)
        }
    }
    
    func configureToolBarButtonTitles()  {
        let maxLimit = tutorialContent.sections.count - 1
        let minLimit = 0

        if currentPage > minLimit && currentPage < maxLimit {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        } else if currentPage <= minLimit {
            tutorial.nextButtonTitle = obtainSectionTitleFor(nextSection: 1)
        } else if currentPage >= maxLimit {
            tutorial.backButtonTitle = obtainSectionTitleFor(nextSection: -1)
        }
        shareTutorialSettings(tutorial)
    }
    
    private func obtainSectionTitleFor(nextSection: Int) -> String {
        return tutorialContent.sections[currentPage + nextSection]
    }
    
    func configureScrollViewMovement(contentOffsetX: Float) {
        let scrollMinLimit = 0
        let scrollMaxLimit = tutorialContent.sections.count - 1
        if contentOffsetX < 0 && currentPage > scrollMinLimit {
            currentPage = currentPage - 1
            nextSection(currentPage, currentSegment)
        } else if contentOffsetX > 0 && currentPage < scrollMaxLimit{
            currentPage = currentPage + 1
            nextSection(currentPage, currentSegment)
        }
    }

    func configurePageControlMovement(currentPageControlPage: Int) {
        if currentPageControlPage > currentPage {
            currentPage += 1
        } else {
            currentPage -= 1
        }
        nextSection(currentPage, currentSegment)
    }
    
    func configureAppropriateSegment(segment: Int, isDemo: Bool) -> (String, Bool) {
        guard let segment = SegmentControl(rawValue: segment) else { return ("", false) }
        switch segment {
        case .intro:
            isDemoScreen = false
            return (tutorialContent.introContent[currentPage], isDemoScreen)
        case
            .demo: isDemoScreen = true
            return (tutorialContent.demoContent[currentPage], isDemoScreen)
        case .practice:
            isDemoScreen = false
            return (tutorialContent.practiceContent[currentPage], isDemoScreen)
        }
    }
    
    
}
