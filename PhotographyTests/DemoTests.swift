import XCTest
import Photography

class DemoTests: XCTestCase {
    
    func testNoImageDisplayedWhenNotDemo() {
        var image: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { image = $0.image }
        demo.configureDemo(sliderValue: nil)
        XCTAssertEqual(image, nil)
    }
    
    func testNoTextDisplayedWhenNotDemo() {
        var text: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .intro)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { text = $0.text }
        demo.configureDemo(sliderValue: nil)
        XCTAssertEqual(text, nil)
    }
    
    func testImageDisplayedWhenDemo() {
        var image: String?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { image = $0.image }
        demo.configureDemo(sliderValue: 0)
        XCTAssertEqual(image, "waterfall2.8")
    }
    
    func testCorrectShutterImageDisplayedWhenSliderValueChanged() {
        var image: String?
        let setUp = TutorialSetUp(currentPage: .shutter, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { image = $0.image }
        demo.configureDemo(sliderValue: 8)
        XCTAssertEqual(image, "waterfall8")
    }
    
    func testCorrectApertureImageDisplayedWhenSliderValueChanged() {
        var image: String?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { image = $0.image }
        demo.configureDemo(sliderValue: 6)
        XCTAssertEqual(image, "flower")
    }
    
    func testCorrectISOTextDisplayedWhenSliderValueChanged() {
        var text: String?
        let setUp = TutorialSetUp(currentPage: .iso, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { text = $0.text }
        demo.configureDemo(sliderValue: 16)
        XCTAssertEqual(text, "3200")
    }
    
    func testCorrectCameraSizeWhenApertureSliderValueChanged() {
        var cameraOpeningSize: Int?
        let setUp = TutorialSetUp(currentPage: .aperture, currentSegment: .demo)
        let demo = DemoModel(setUp: setUp)
        demo.shareInformation = { cameraOpeningSize = $0.cameraOpeningSize }
        demo.configureDemo(sliderValue: 22)
        XCTAssertEqual(cameraOpeningSize, 8)
    }
    

}
