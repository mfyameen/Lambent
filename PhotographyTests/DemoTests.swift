import XCTest
import Photography

class DemoTests: XCTestCase {

    func testApertureImageDisplayed() {
        let demo = DemoView()
        let image = demo.configureAppropriateSectionWhenInitialized("Aperture")
        XCTAssertEqual(UIImage(named: "flower"), image)
    }
    
    func testShutterImageDisplayed() {
        let demo = DemoView()
        let image = demo.configureAppropriateSectionWhenInitialized("Shutter Speed")
        XCTAssertEqual(UIImage(named: "bird"), image)
    }
}
