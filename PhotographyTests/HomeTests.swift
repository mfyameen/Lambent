import XCTest
import Photography

class HomeTests: XCTestCase {
    let view = HomeView()
    let model = PhotographyModel()
    
    func testCorrectTitleDisplayedWhenOverviewCell() {
        view.tableViewContent = model
        let overviewIndex = Page.overview.rawValue
        let testObject = view.setTitleAndPhrase(index: overviewIndex)
        let expectedValue = model.sections[overviewIndex]
        XCTAssertEqual(testObject.title, expectedValue)
    }
    
    func testCorrectPhraseDisplayedWhenApertureCell() {
        view.tableViewContent = model
        let apertureIndex = Page.aperture.rawValue
        let testObject = view.setTitleAndPhrase(index: apertureIndex)
        let expectedValue = model.descriptions[apertureIndex]
        XCTAssertEqual(testObject.phrase, expectedValue)
    }
}
