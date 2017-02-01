import XCTest
import Photography

class TutorialTests: XCTestCase {
    let content = Content(sections: ["Get Started", "Aperture", "Shutter Speed", "ISO", "Focal Length", "Modes"], descriptions: [], introductions: ["Overview intro","Aperture intro","Shutter intro","ISO intro","Focal length intro","Modes intro"], exercises: ["No exercise", "Aperture exercise", "Shutter exercise", "ISO exercise", "Focal length exercise", "Modes exercise"], instructions: [], updatedInstructions: [], modeIntroductions: [])
    
    func testDemoRegisteredWhenDemo() {
        var testObject: Bool?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject = $0.isDemoScreen }
        tutorial.configureContent()
        XCTAssertEqual(testObject, true)
    }
    
    func testDemoNotRegisteredWhenIntro() {
        var testObject: Bool?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject = $0.isDemoScreen }
        tutorial.configureContent()
        XCTAssertEqual(testObject, false)
    }

    func testIntroContentDisplayedWhenOverviewPage() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject = $0.content }
        tutorial.configureContent()
        let expectedValue = content.introductions[Page.overview.rawValue]
        XCTAssertEqual(testObject, expectedValue)
    }

    func testPracticeContentDisplayedWhenAperturePracticeSegment() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .practice)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject = $0.content }
        tutorial.configureContent()
        let expectedValue = content.exercises[Page.aperture.rawValue]
        XCTAssertEqual(testObject, expectedValue)
    }
    
    func testAppropriateNextButtonTitleDisplayedWhenShutterPage() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject = $0.nextButtonTitle }
        tutorial.configureToolBarButtonTitles()
        let expectedValue = content.sections[Page.iso.rawValue]
        XCTAssertEqual(testObject, expectedValue)
    }

    func testAppropriateBackButtonTitleDisplayedWhenAperturePageDemoSegment() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        XCTAssertEqual(testObject, "Intro")
    }

    func testOnlyNextButtonDisplayedWhenOverviewPage() {
        var testObject = TutorialSettings()
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject.nextButtonTitle = $0.nextButtonTitle; testObject.backButtonTitle = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        let expectedValue = content.sections[Page.aperture.rawValue]
        XCTAssertEqual(testObject.nextButtonTitle, expectedValue)
        XCTAssertEqual(testObject.backButtonTitle, "")
    }

    func testOnlyBackButtonDisplayedWhenModesPage() {
        var testObject = TutorialSettings()
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.shareTutorialSettings = { testObject.nextButtonTitle = $0.nextButtonTitle; testObject.backButtonTitle = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        XCTAssertEqual(testObject.nextButtonTitle, "")
        XCTAssertEqual(testObject.backButtonTitle, "Focal")
    }

    func testPageIncrementsWhenScrollingToTheRight() {
        var testObject: Page?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: 10)
        XCTAssertEqual(testObject, Page.shutter)
    }

    func testPageDecrementsWhenScrollingToTheLeft() {
        var testObject: Page?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.previousSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: -10)
        XCTAssertEqual(testObject, Page.aperture)
    }
    
    func testPageDoesNotScrollToTheRightIfNextPageDoesNotExist() {
        var testObject: Page?
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: .practice)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: 10)
        XCTAssertEqual(testObject, nil)
    }
   
    func testPageDoesNotScrollToTheLeftIfPreviousPageDoesNotExist() {
        var testObject: Page?
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: -10)
        XCTAssertEqual(testObject, nil)
    }
    
    func testPageIncrementsWhenRightSideOfPageControlPressed() {
        var testObject: Page?
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configurePageControlMovement(currentPageControlPage: 1)
        XCTAssertEqual(testObject, Page.aperture)
    }
    
    func testPageDecrementsWhenLeftSideOfPageControlPressed() {
        var testObject: Page?
        let setUp = TutorialSetUp(currentPage: .focal, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp, content: content)
        tutorial.previousSection = { testObject = $0.0 }
        tutorial.configurePageControlMovement(currentPageControlPage: 2)
        XCTAssertEqual(testObject, Page.iso)
    }
    
}
