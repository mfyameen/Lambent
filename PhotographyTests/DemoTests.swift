import XCTest
import Photography

class DemoTests: XCTestCase {
    
    func testNoImageDisplayedWhenNotDemo() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { testObject = $0.image }
        demo.configureDemo(sliderValue: nil)
        XCTAssertEqual(testObject, nil)
    }
    
    func testNoTextDisplayedWhenNotDemo() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { testObject = $0.text }
        demo.configureDemo(sliderValue: nil)
        XCTAssertEqual(testObject, nil)
    }
    
    func testImageDisplayedWhenDemo() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { testObject = $0.image }
        demo.configureDemo(sliderValue: 0)
        XCTAssertEqual(testObject, "waterfall2.8")
    }
    
    func testCorrectShutterImageDisplayedWhenSliderValueChanged() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { testObject = $0.image }
        demo.configureDemo(sliderValue: 8)
        XCTAssertEqual(testObject, "waterfall8")
    }
    
    func testCorrectApertureImageDisplayedWhenSliderValueChanged() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { testObject = $0.image }
        demo.configureDemo(sliderValue: 6)
        XCTAssertEqual(testObject, "fountain5.6")
    }
    
    func testCorrectISOTextDisplayedWhenSliderValueChanged() {
        var testObject: String?
        let setUp = TutorialSetUp(currentPage: .iso, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { testObject = $0.text }
        demo.configureDemo(sliderValue: 16)
        XCTAssertEqual(testObject, "3200")
    }
    
    func testCorrectCameraSizeWhenApertureSliderValueChanged() {
        var testObject: Int?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { testObject = $0.cameraOpeningSize }
        demo.configureDemo(sliderValue: 22)
        XCTAssertEqual(testObject, 8)
    }
    

}
