import Foundation

struct TutorialSettings {
    var backButtonTitle: String = ""
    var nextButtonTitle: String = ""
}

class TutorialModel {
    var currentPage: Int
    var currentSegment: Int
    private let setUp: TutorialSetUp
    var tutorial = TutorialSettings()
    var tutorialContent: PhotographyModel? {
        didSet {
            let numberOfSections = tutorialContent?.sections.count ?? 0
            configureToolBarButtonTitles(numberOfSections)
        }
    }
    
    var shareTutorialSettings: (TutorialSettings)-> Void = { _ in }
    
    init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSegment = setUp.currentSegment
        self.setUp = setUp
    }
    
    func configureToolBarButtonTitles(_ numberOfSections: Int)  {
        let maxLimit = numberOfSections - 1
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
        return tutorialContent?.sections[currentPage + nextSection] ?? ""
    }
}
