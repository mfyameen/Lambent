import XCTest
import Lambent

class TutorialTests: XCTestCase {
    let content = Content(sections: ["Get Started", "Aperture", "Shutter Speed", "ISO", "Focal Length", "Modes"], descriptions: [], introductions: ["Overview intro", "Aperture intro", "Shutter intro", "ISO intro", "Focal length intro", "Modes intro"], exercises: ["No exercise", "Aperture exercise", "Shutter exercise", "ISO exercise", "Focal length exercise", "Modes exercise"], instructions: [], updatedInstructions: [], modeIntroductions: ["modeIntroduction1", "modeIntroduction2", "modeIntroduction3"])
    
    func testDemoRegisteredWhenDemo() {
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureContent()
        XCTAssertTrue(tutorialSettings.isDemoScreen)
    }
    
    func testDemoNotRegisteredWhenIntro() {
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureContent()
        XCTAssertFalse(tutorialSettings.isDemoScreen)
    }

    func testIntroContentDisplayedWhenOverviewPage() {
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureContent()
        let expected = content.introductions[Page.overview.rawValue]
        XCTAssertEqual(tutorialSettings.content, expected)
    }

    func testPracticeContentDisplayedWhenAperturePracticeSegment() {
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .practice)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureContent()
        let expected = content.exercises[Page.aperture.rawValue]
        XCTAssertEqual(tutorialSettings.content, expected)
    }

    func testAppropriateNextButtonTitleDisplayedWhenShutterPage() {
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureToolBarButtonTitles()
        let expected = content.sections[Page.iso.rawValue]
        XCTAssertEqual(tutorialSettings.nextButtonTitle, expected)
    }

    func testAppropriateBackButtonTitleDisplayedWhenAperturePageDemoSegment() {
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureToolBarButtonTitles()
        XCTAssertEqual(tutorialSettings.backButtonTitle, "Intro")
    }

    func testOnlyNextButtonDisplayedWhenOverviewPage() {
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureToolBarButtonTitles()
        let expected = content.sections[Page.aperture.rawValue]
        XCTAssertEqual(tutorialSettings.nextButtonTitle, expected)
        XCTAssertEqual(tutorialSettings.backButtonTitle, "")
    }

    func testOnlyBackButtonDisplayedWhenModesPage() {
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let tutorialSettings = testObject.configureToolBarButtonTitles()
        XCTAssertEqual(tutorialSettings.nextButtonTitle, "")
        XCTAssertEqual(tutorialSettings.backButtonTitle, "Focal")
    }

    func testPageIncrementsWhenSwipingToTheLeft() {
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let nextPage = testObject.registerSwipe(.left)
        XCTAssertEqual(nextPage, .shutter)
    }

    func testPageDecrementsWhenSwipingToTheRight() {
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let previousPage = testObject.registerSwipe(.right)
        XCTAssertEqual(previousPage, .aperture)
    }

    func testPageDoesNotSwipeToTheLeftIfNextPageDoesNotExist() {
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: .practice)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let nextPage = testObject.registerSwipe(.left)
        XCTAssertEqual(nextPage, nil)
    }

    func testPageDoesNotSwipeToTheRightIfPreviousPageDoesNotExist() {
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let previousPage = testObject.registerSwipe(.right)
        XCTAssertEqual(previousPage, nil)
    }

    func testPageIncrementsWhenRightSideOfPageControlPressed() {
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let nextPage = testObject.configurePageControlMovement(1)
        XCTAssertEqual(nextPage, .aperture)
    }

    func testPageDecrementsWhenLeftSideOfPageControlPressed() {
        let setUp = TutorialSetUp(currentPage: .focal, currentSegment: .intro)
        let testObject = TutorialModel(setUp: setUp, content: content)
        let previousPage = testObject.configurePageControlMovement(2)
        XCTAssertEqual(previousPage, .iso)
    }
}
