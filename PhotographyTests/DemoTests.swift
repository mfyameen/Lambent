import XCTest
import Photography

class DemoTests: XCTestCase {

    func testApertureImageDisplayed() {
        let demo = DemoView()
        let (image, _) = demo.configureAppropriateCameraSection("Aperture")
        XCTAssertEqual(UIImage(named: "flower"), image)
    }
    
    func testShutterImageDisplayed() {
        let demo = DemoView()
        let (image, _) = demo.configureAppropriateCameraSection("Shutter Speed")
        XCTAssertEqual(UIImage(named: "bird"), image)
    }
    
    func testApertureSliderConfiguredCorrectly() {
        let demo = DemoView()
        let (_, slider) = demo.configureAppropriateCameraSection("Aperture")
        XCTAssertEqual(2.8, slider?.minimumValue)
        XCTAssertEqual(22, slider?.maximumValue)
    }
    
    func testShutterSpeedSliderConfiguredCorrectly() {
        let demo = DemoView()
        let (_, slider) = demo.configureAppropriateCameraSection("Shutter Speed")
        XCTAssertEqual(2, slider?.minimumValue)
        XCTAssertEqual(125, slider?.maximumValue)
    }
}
