import XCTest
import Photography

class DemoTests: XCTestCase {
    
    func testApertureImageDisplayed() {
        let demo = DemoModel(setUp: nil)
        var demoSettings = DemoSettings()
        demoSettings = demo.configureCurrentSection("Aperture")
        let image = demoSettings.image
        XCTAssertEqual(image, UIImage(named: "flower"))
    }
    
//    func testShutterImageDisplayed() {
//        let demo = DemoModel()
//        demo.currentSection = "Shutter Speed"
//        let image = demo.configureAppropriateSectionWhenInitialized(demo.currentSection ?? "")
//        XCTAssertEqual(image, UIImage(named: "bird"))
//    }
//    
//    func testCorrectImageDisplayedWhenSliderValueChanged() {
//        let demo = DemoModel()
//        demo.currentSection = "Shutter Speed"
//        let image = demo.configureAppropriateSectionWhenInitialized(demo.currentSection ?? "")
//        XCTAssertEqual(image, UIImage(named: "bird"))
//    }
}
