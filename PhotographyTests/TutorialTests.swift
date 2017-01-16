import XCTest
import Photography

class TutorialTests: XCTestCase {
    
    func testDemoRegisteredWhenDemo() {
        var testObject: Bool?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.shareTutorialSettings = { testObject = $0.isDemoScreen}
        tutorial.configureContent()
        
        XCTAssertEqual(testObject, true)
    }
    
    func testDemoNotRegisteredWhenIntro() {
        var testObject: Bool?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.shareTutorialSettings = { testObject = $0.isDemoScreen}
        tutorial.configureContent()
        
        XCTAssertEqual(testObject, false)
    }
    
    func testIntroContentDisplayedWhenOverviewPage() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { testObject = $0.content }
        tutorial.configureContent()
        
        XCTAssertEqual(testObject, tutorialContent.introContent[Page.overview.rawValue])
    }

    func testPracticeContentDisplayedWhenAperturePracticeSegment() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .practice)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { testObject = $0.content }
        tutorial.configureContent()

        XCTAssertEqual(testObject, tutorialContent.practiceContent[Page.aperture.rawValue])
    }
    
    func testAppropriateNextButtonTitleDisplayedWhenShutterPage() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { testObject = $0.nextButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(testObject, tutorialContent.sections[Page.shutter.rawValue + 1])
    }
    
    func testAppropriateBackButtonTitleDisplayedWhenAperturePageDemoSegment() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.shareTutorialSettings = { testObject = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(testObject, "Intro")
    }
    
    func testOnlyNextButtonDisplayedWhenOverviewPage() {
        var testObject = TutorialSettings()
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        let tutorialContent = PhotographyModel()
        
        tutorial.shareTutorialSettings = { testObject.nextButtonTitle = $0.nextButtonTitle; testObject.backButtonTitle = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(testObject.nextButtonTitle, tutorialContent.sections[Page.overview.rawValue + 1])
        XCTAssertEqual(testObject.backButtonTitle, "")
    }
    
    func testOnlyBackButtonDisplayedWhenModesPage() {
        var testObject = TutorialSettings()
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.shareTutorialSettings = { testObject.nextButtonTitle = $0.nextButtonTitle; testObject.backButtonTitle = $0.backButtonTitle }
        tutorial.configureToolBarButtonTitles()
        
        XCTAssertEqual(testObject.nextButtonTitle, "")
        XCTAssertEqual(testObject.backButtonTitle, "Focal")
    }
    
    func testPageIncrementsWhenScrollingToTheRight() {
        var testObject: Page?
  
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: 10)
        
        XCTAssertEqual(testObject, Page.shutter)
    }
    
    func testPageDecrementsWhenScrollingToTheLeft() {
        var testObject: Page?
        
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.previousSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: -10)
        
        XCTAssertEqual(testObject, Page.aperture)
    }
    
    func testPageDoesNotScrollToTheRightIfNextPageDoesNotExist() {
        var testObject: Page?
        
        let setUp = TutorialSetUp(currentPage: .modes, currentSegment: .practice)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: 10)
        
        XCTAssertEqual(testObject, nil)
    }
   
    func testPageDoesNotScrollToTheLeftIfPreviousPageDoesNotExist() {
        var testObject: Page?
        
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configureScrollViewMovement(contentOffsetX: -10)
        
        XCTAssertEqual(testObject, nil)
    }
    
    func testPageIncrementsWhenRightSideOfPageControlPressed() {
        var testObject: Page?
        
        let setUp = TutorialSetUp(currentPage: .overview, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.nextSection = { testObject = $0.0 }
        tutorial.configurePageControlMovement(currentPageControlPage: 1)
        
        XCTAssertEqual(testObject, Page.aperture)
    }
    
    func testPageDecrementsWhenLeftSideOfPageControlPressed() {
        var testObject: Page?
        
        let setUp = TutorialSetUp(currentPage: .focal, currentSegment: nil)
        let tutorial = TutorialModel(setUp: setUp)
        
        tutorial.previousSection = { testObject = $0.0 }
        tutorial.configurePageControlMovement(currentPageControlPage: 2)
        
        XCTAssertEqual(testObject, Page.iso)
    }
    
}
