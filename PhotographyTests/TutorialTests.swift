import XCTest
import Photography

class TutorialTests: XCTestCase {
    func testDemoRegisteredWhenDemo() {
        var demo: Bool?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.shareTutorialSettings = { demo = $0.isDemoScreen}
        tutorial.configureContent()
        
        XCTAssertEqual(demo, true)
    }
    
    func testDemoNotRegisteredWhenIntro() {
        var demo: Bool?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.shareTutorialSettings = { demo = $0.isDemoScreen}
        tutorial.configureContent()
        
        XCTAssertEqual(demo, false)
    }
    
    func testIntroContentDisplayedWhenOverviewPage() {
        var content: String?
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { content = $0.content }
        tutorial.configureContent()
        
        XCTAssertEqual(content, tutorialContent.introContent[Page.overview.rawValue])
    }
    
    
    func testPracticeContentDisplayedWhenAperturePracticeSegment() {
        var content: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .practice)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { content = $0.content }
        tutorial.configureContent()

        XCTAssertEqual(content, tutorialContent.practiceContent[Page.aperture.rawValue])
    }
    
    func testAppropriateNextButtonTitleDisplayedWhenShutterPage() {
        var nextButton: String?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { nextButton = $0.nextButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(nextButton, tutorialContent.sections[Page.shutter.rawValue + 1])
    }
    
    func testAppropriateBackButtonTitleDisplayedWhenAperturePageDemoSegment() {
        var backButton: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { backButton = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(backButton, tutorialContent.sections[Page.aperture.rawValue - 1])
    }
    
    func testOnlyNextButtonDisplayedWhenOverviewPage() {
        var nextButton: String?
        var backButton: String?
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { nextButton = $0.nextButtonTitle; backButton = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(nextButton, tutorialContent.sections[Page.overview.rawValue + 1])
        XCTAssertEqual(backButton, "")
    }
    
    func testOnlyBackButtonDisplayedWhenModesPage() {
        var nextButton: String?
        var backButton: String?
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { nextButton = $0.nextButtonTitle; backButton = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(nextButton, "")
        XCTAssertEqual(backButton, tutorialContent.sections[Page.modes.rawValue - 1])
    }
    
    func testPageIncrementsWhenScrollingToTheRight() {
        var page: Page?
  
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { page = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: 10)
        
        XCTAssertEqual(page, Page.shutter)
    }
    
    func testPageDecrementsWhenScrollingToTheLeft() {
        var page: Page?
        
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { page = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: -10)
        
        XCTAssertEqual(page, Page.aperture)
    }
    
    func testPageOnlyScrollsToTheRightIfNextPageExists() {
        var page: Page?
        
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: .practice)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { page = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: 10)
        
        XCTAssertEqual(page, nil)
    }
   
    func testPageOnlyScrollsToTheLeftIfPreviousPageExists() {
        var page: Page?
        
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { page = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: -10)
        
        XCTAssertEqual(page, nil)
    }
    
    func testPageIncrementsWhenRightSideOfPageControlPressed() {
        var page: Page?
        
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { page = $0.0 }
        tutorial.configurePageControlMovement(currentPageControlPage: 1)
        
        XCTAssertEqual(page, Page.aperture)
    }
    
    func testPageDecrementsWhenLeftSideOfPageControlPressed() {
        var page: Page?
        
        let setUp = TutorialSetUp(currentPage: .focal, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { page = $0.0 }
        tutorial.configurePageControlMovement(currentPageControlPage: 2)
        
        XCTAssertEqual(page, Page.iso)
    }
    
}
