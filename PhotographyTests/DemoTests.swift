import XCTest
import Lambent

class DemoTests: XCTestCase {
    let content = Content(sections: ["Get Started", "Aperture", "Shutter Speed", "ISO", "Focal Length", "Modes"], descriptions: [], introductions: [], exercises: [], instructions: ["", "", "", "", "", ""], updatedInstructions: ["", "", "", "", "", ""], modeIntroductions: [])

    func testCorrectShutterImageDisplayedWhenSliderValueChanged() {
        let testObject = DemoModel(currentPage: .shutter, content: content)
        let demoSettings = testObject.configureDemo(8)
        XCTAssertEqual(demoSettings.shutterImage, "waterfall8")
    }

    func testCorrectApertureImageDisplayedWhenSliderValueChanged() {
        let testObject = DemoModel(currentPage: .aperture, content: content)
        let demoSettings = testObject.configureDemo(6)
        XCTAssertEqual(demoSettings.apertureImage, "fountain5.6")
    }

    func testCorrectISOTextDisplayedWhenSliderValueChanged() {
        let testObject = DemoModel(currentPage: .iso, content: content)
        let demoSettings = testObject.configureDemo(16)
        XCTAssertEqual(demoSettings.isoText, "3200")
    }

    func testCorrectCameraSizeWhenApertureSliderValueChanged() {
        let testObject = DemoModel(currentPage: .aperture, content: content)
        let demoSettings = testObject.configureDemo(22)
        XCTAssertEqual(demoSettings.cameraOpeningSize, 8)
    }
}
