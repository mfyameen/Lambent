import XCTest
import Photography

class TableViewTests: XCTestCase {
    let view = PhotographyView()
    let model = PhotographyModel()
    
    func testCorrectTitleDisplayedWhenOverviewCell() {
        view.tableViewContent = model
        let overviewIndex = Page.overview.rawValue
        let (titleTestObject, _) = view.setTitleAndPhrase(index: overviewIndex)
        let correctTitle = model.sections[overviewIndex]
        XCTAssertEqual(titleTestObject, correctTitle)
    }
    
    func testCorrectPhraseDisplayedWhenApertureCell() {
        view.tableViewContent = model
        let apertureIndex = Page.aperture.rawValue
        let (_, phraseTestObject) = view.setTitleAndPhrase(index: apertureIndex)
        let correctPhrase = model.descriptions[apertureIndex]
        XCTAssertEqual(phraseTestObject, correctPhrase)
    }
}
