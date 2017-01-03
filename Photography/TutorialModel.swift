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
        tutorial.numberOfSections = tutorialContent.sections.count
    }
    
    func configureContent() {
        tutorial.title = tutorialContent.sectionTitles[currentPage]
        if currentPage == 0 {
           tutorial.content = tutorialContent.introContent[currentPage]
        } else {
            configureAppropriateSegment(segment: currentSegment)
        }
    }
    
    func configureAppropriateSegment(segment: Int) {
        guard let segment = SegmentControl(rawValue: segment) else { return }
        switch segment {
        case .intro:
            tutorial.isDemoScreen = false
            tutorial.content = tutorialContent.introContent[currentPage]
        case
        .demo:
            tutorial.isDemoScreen = true
           // tutorial.content = tutorialContent.demoContent[currentPage]
            
        case .practice:
            tutorial.isDemoScreen = false
            tutorial.content = tutorialContent.practiceContent[currentPage]
        }
        shareTutorialSettings(tutorial)
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
}
