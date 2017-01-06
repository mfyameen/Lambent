import XCTest
import Photography

class DemoTests: XCTestCase {

    func testNoImageDisplayedWhenNotDemo() {
        let setUp = TutorialSetUp(currentPage: Page.Aperture.rawValue, currentSegment: Segment.Intro.rawValue)
        let demo = DemoModel(setUp: setUp)
        demo.configureDemo(sliderValue: nil)
        let image = demo.sectionSettings.image
        XCTAssertEqual(image, nil)
    }
    
    func testNoTextDisplayedWhenNotDemo() {
        let setUp = TutorialSetUp(currentPage: Page.Aperture.rawValue, currentSegment: Segment.Intro.rawValue)
        let demo = DemoModel(setUp: setUp)
        demo.configureDemo(sliderValue: nil)
        let text = demo.sectionSettings.text
        XCTAssertEqual(text, nil)
    }
    
    func testImageDisplayedWhenDemo() {
        let setUp = TutorialSetUp(currentPage: Page.Shutter.rawValue, currentSegment: Segment.Demo.rawValue)
        let demo = DemoModel(setUp: setUp)
        demo.configureDemo(sliderValue: 0)
        let image = demo.sectionSettings.image
        XCTAssertEqual(image, "waterfall2.8")
    }
    
    func testCorrectShutterImageDisplayedWhenSliderValueChanged() {
        let setUp = TutorialSetUp(currentPage: Page.Shutter.rawValue, currentSegment: Segment.Demo.rawValue)
        let demo = DemoModel(setUp: setUp)
        var demoSettings: CameraSectionDemoSettings?
        demo.configureDemo(sliderValue: 8)
        //let image = demo.sectionSettings.image
        //        let image = demo.shareInformation { demo in
        //            demoSettings = demo
        //XCTAssertEqual(image, "waterfall8")
    }
    
    func testCorrectApertureImageDisplayedWhenSliderValueChanged() {
        let setUp = TutorialSetUp(currentPage: Page.Aperture.rawValue, currentSegment: Segment.Demo.rawValue)
        let demo = DemoModel(setUp: setUp)
        demo.configureDemo(sliderValue: 6)
        let image = demo.sectionSettings.image
        XCTAssertEqual(image, "flower")
    }
    
    func testCorrectISOTextDisplayedWhenSliderValueChanged() {
        let setUp = TutorialSetUp(currentPage: Page.ISO.rawValue, currentSegment: Segment.Demo.rawValue)
        let demo = DemoModel(setUp: setUp)
        demo.configureDemo(sliderValue: 16)
        let text = demo.sectionSettings.text
        XCTAssertEqual(text, "3200")
    }
    
    func testCorrectCameraSizeWhenApertureSliderValueChanged() {
        let setUp = TutorialSetUp(currentPage: Page.Aperture.rawValue, currentSegment: Segment.Demo.rawValue)
        let demo = DemoModel(setUp: setUp)
        demo.configureDemo(sliderValue: 22)
        let cameraOpeningSize = demo.sectionSettings.cameraOpeningSize
        XCTAssertEqual(cameraOpeningSize, 8)
    }
    

}
