import XCTest
import Photography

class HomeTests: XCTestCase {
    var content: Content?
    let model = PhotographyModel()
    let view = HomeView()
 //   var content: Content?
    
    func testCorrectTitleDisplayedWhenOverviewCell() {
        model.fetchContent{ self.view.homeContent = $0.0 }
        view.tableViewContent = model
        let overviewIndex = Page.overview.rawValue

        let testObject = view.setTitleAndPhrase(index: overviewIndex)
        XCTAssertEqual(testObject.title, "Get Started")
    }
    
//    func testCorrectPhraseDisplayedWhenApertureCell() {
//        view.tableViewContent = model
//        let apertureIndex = Page.aperture.rawValue
//        let testObject = view.setTitleAndPhrase(index: apertureIndex)
//       // let expectedValue = model.descriptions[apertureIndex]
//        XCTAssertEqual(testObject.phrase, expectedValue)
//    }
}
