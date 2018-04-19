import XCTest

class LambentUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testMenuTableContainsCorrectNumberOfCells() {
        let app = XCUIApplication()
        let numberOfCells = app.tables.cells.count
        XCTAssertEqual(numberOfCells, 6)
    }
    
    func testMenuContentsNavigateUserToCorrectSection() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let homeButton = app.navigationBars.buttons["Home"]
        
        tablesQuery.cells.containing(.staticText, identifier: "Aperture").buttons["Intro"].tap()
        XCTAssert(app.staticTexts["Aperture"].exists)
        let apertureIntroSelected = app.segmentedControls.buttons.element(boundBy: 0).isSelected
        XCTAssertTrue(apertureIntroSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Aperture").buttons["Demo"].tap()
        XCTAssert(app.staticTexts["Aperture"].exists)
        let apertureDemoSelected = app.segmentedControls.buttons.element(boundBy: 1).isSelected
        XCTAssertTrue(apertureDemoSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Aperture").buttons["Practice"].tap()
        XCTAssert(app.staticTexts["Aperture"].exists)
        let aperturePracticeSelected = app.segmentedControls.buttons.element(boundBy: 2).isSelected
        XCTAssertTrue(aperturePracticeSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Shutter Speed").buttons["Intro"].tap()
        XCTAssert(app.staticTexts["Shutter Speed"].exists)
        let shutterSpeedIntroSelected = app.segmentedControls.buttons.element(boundBy: 0).isSelected
        XCTAssertTrue(shutterSpeedIntroSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Shutter Speed").buttons["Demo"].tap()
        XCTAssert(app.staticTexts["Shutter Speed"].exists)
        let shutterSpeedDemoSelected = app.segmentedControls.buttons.element(boundBy: 1).isSelected
        XCTAssertTrue(shutterSpeedDemoSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Shutter Speed").buttons["Practice"].tap()
        XCTAssert(app.staticTexts["Shutter Speed"].exists)
        let shutterSpeedPracticeSelected = app.segmentedControls.buttons.element(boundBy: 2).isSelected
        XCTAssertTrue(shutterSpeedPracticeSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "ISO").buttons["Intro"].tap()
        XCTAssert(app.staticTexts["ISO"].exists)
        let isoIntroSelected = app.segmentedControls.buttons.element(boundBy: 0).isSelected
        XCTAssertTrue(isoIntroSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "ISO").buttons["Demo"].tap()
        XCTAssert(app.staticTexts["ISO"].exists)
        let isoDemoSelected = app.segmentedControls.buttons.element(boundBy: 1).isSelected
        XCTAssertTrue(isoDemoSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "ISO").buttons["Practice"].tap()
        XCTAssert(app.staticTexts["ISO"].exists)
        let isoPracticeSelected = app.segmentedControls.buttons.element(boundBy: 2).isSelected
        XCTAssertTrue(isoPracticeSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Focal Length").buttons["Intro"].tap()
        XCTAssert(app.staticTexts["Focal Length"].exists)
        let focalLengthIntroSelected = app.segmentedControls.buttons.element(boundBy: 0).isSelected
        XCTAssertTrue(focalLengthIntroSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Focal Length").buttons["Demo"].tap()
        XCTAssert(app.staticTexts["Focal Length"].exists)
        let focalLengthDemoSelected = app.segmentedControls.buttons.element(boundBy: 1).isSelected
        XCTAssertTrue(focalLengthDemoSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Focal Length").buttons["Practice"].tap()
        XCTAssert(app.staticTexts["Focal Length"].exists)
        let focalLengthPracticeSelected = app.segmentedControls.buttons.element(boundBy: 2).isSelected
        XCTAssertTrue(focalLengthPracticeSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Modes").buttons["Aperture"].tap()
        XCTAssert(app.staticTexts["Modes"].exists)
        let apertureModeSelected = app.segmentedControls.buttons.element(boundBy: 0).isSelected
        XCTAssertTrue(apertureModeSelected)
        homeButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier: "Modes").buttons["Manual"].tap()
        XCTAssert(app.staticTexts["Modes"].exists)
        let manualModeSelected = app.segmentedControls.buttons.element(boundBy: 2).isSelected
        XCTAssertTrue(manualModeSelected)
        homeButton.tap()
    }
    
    func testDemoShowCorrectContentWhenUserMovesSlider() {
        let app = XCUIApplication()
        app.tables.cells.containing(.staticText, identifier: "Aperture").buttons["Demo"].tap()
        let scrollViewsQuery = app.scrollViews
        let slider = scrollViewsQuery.otherElements.sliders.element
        
        XCTAssert(app.staticTexts["Press and move the slider to see how aperture affects the above photo"].exists)
        XCTAssert(app.staticTexts["f/2.8"].exists)
        XCTAssert(app.images["fountain2.8"].exists)
        slider.adjust(toNormalizedSliderPosition: 0.5)
        XCTAssertFalse(app.staticTexts["Press and move the slider to see how aperture affects the above photo"].exists)
        XCTAssert(app.staticTexts["Notice how the image becomes darker and the background appears less blurry"].exists)
        XCTAssert(app.staticTexts["f/11"].exists)
        XCTAssert(app.images["fountain11"].exists)
        slider.adjust(toNormalizedSliderPosition: 1.0)
        XCTAssert(app.staticTexts["f/22"].exists)
        XCTAssert(app.images["fountain22"].exists)
        
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "f/22").children(matching: .image).element(boundBy: 0).swipeLeft()
        XCTAssert(app.staticTexts["Press and move the slider to see how shutter speed affects the above photo"].exists)
        XCTAssert(app.staticTexts["1/2"].exists)
        XCTAssert(app.images["waterfall2.8"].exists)
        XCTAssert(app.images["shutter1.2"].exists)
        slider.adjust(toNormalizedSliderPosition: 0.5)
        XCTAssertFalse(app.staticTexts["Press and move the slider to see how shutter speed affects the above photo"].exists)
        XCTAssert(app.staticTexts["Notice how the image becomes darker and the water appears to have less motion blur"].exists)
        XCTAssert(app.staticTexts["1/30"].exists)
        XCTAssert(app.images["waterfall11"].exists)
        XCTAssert(app.images["shutter1.30"].exists)
        slider.adjust(toNormalizedSliderPosition: 1.0)
        XCTAssert(app.staticTexts["1/125"].exists)
        XCTAssert(app.images["waterfall22"].exists)
        XCTAssert(app.images["shutter1.125"].exists)
        
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "1/125").children(matching: .image).element(boundBy: 0).swipeLeft()
        XCTAssert(app.staticTexts["Press and move the slider to see how the ISO affects the above photo"].exists)
        XCTAssert(app.staticTexts["100"].exists)
        XCTAssert(app.images["iso100"].exists)
        XCTAssert(app.images["isoicon100"].exists)
        slider.adjust(toNormalizedSliderPosition: 0.5)
        XCTAssertFalse(app.staticTexts["Press and move the slider to see how the ISO affects the above photo"].exists)
        XCTAssert(app.staticTexts["Notice how the image becomes lighter and appears to be more grainy"].exists)
        XCTAssert(app.staticTexts["1600"].exists)
        XCTAssert(app.images["iso1600"].exists)
        XCTAssert(app.images["isoicon1600"].exists)
        slider.adjust(toNormalizedSliderPosition: 1.0)
        XCTAssert(app.staticTexts["6400"].exists)
        XCTAssert(app.images["isoicon6400"].exists)
        
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "6400").children(matching: .image).element(boundBy: 0).swipeLeft()
        XCTAssert(app.staticTexts["Press and move the slider to see how focal length affects the above photo"].exists)
        XCTAssert(app.staticTexts["18mm"].exists)
        XCTAssert(app.images["focal18"].exists)
        XCTAssert(app.images["focalicon18"].exists)
        slider.adjust(toNormalizedSliderPosition: 0.5)
        XCTAssertFalse(app.staticTexts["Press and move the slider to see how focal length affects the above photo"].exists)
        XCTAssert(app.staticTexts["Notice how the distance between the tree trunks appears to decrease as you zoom"].exists)
        XCTAssert(app.staticTexts["55mm"].exists)
        XCTAssert(app.images["focal55"].exists)
        XCTAssert(app.images["focalicon55"].exists)
        slider.adjust(toNormalizedSliderPosition: 1.0)
        XCTAssert(app.staticTexts["100mm"].exists)
        XCTAssert(app.images["focal100"].exists)
        XCTAssert(app.images["focalicon100"].exists)
    }
}
