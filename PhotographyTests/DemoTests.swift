import XCTest
import Photography

class DemoTests: XCTestCase {
    
    func testApertureImageDisplayed() {
        let demo = DemoView()
        demo.currentSection = "Aperture"
        let image = demo.configureAppropriateSectionWhenInitialized(demo.currentSection ?? "")
        XCTAssertEqual(image, UIImage(named: "flower"))
    }
    
    func testShutterImageDisplayed() {
        let demo = DemoView()
        demo.currentSection = "Shutter Speed"
        let image = demo.configureAppropriateSectionWhenInitialized(demo.currentSection ?? "")
        XCTAssertEqual(image, UIImage(named: "bird"))
    }
    
    func testCorrectImageDisplayedWhenSliderValueChanged() {
        let demo = DemoView()
        demo.currentSection = "Shutter Speed"
        let image = demo.configureAppropriateSectionWhenInitialized(demo.currentSection ?? "")
        XCTAssertEqual(image, UIImage(named: "bird"))
    }
}
