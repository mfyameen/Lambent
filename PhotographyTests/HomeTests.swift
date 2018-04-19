import XCTest
import Lambent

class HomeTests: XCTestCase {
    let content = Content(sections: ["Get Started", "Aperture", "Shutter Speed", "ISO", "Focal Length", "Modes"], descriptions: ["", "Aperture controls the amount of light that passes through the lens.", "", "", "", ""], introductions: [], exercises: [], instructions: [], updatedInstructions: [], modeIntroductions: [])
    let view = HomeView()
    
    func testCorrectTitleDisplayedWhenOverviewCell() {
        view.homeContent = content
        let overviewIndex = Page.overview.rawValue
        let testObject = view.setTitleAndPhrase(index: overviewIndex)
        let expectedValue = content.sections[Page.overview.rawValue]
        XCTAssertEqual(testObject.title, expectedValue)
    }
    
    func testCorrectPhraseDisplayedWhenApertureCell() {
        view.homeContent = content
        let apertureIndex = Page.aperture.rawValue
        let testObject = view.setTitleAndPhrase(index: apertureIndex)
        let expectedValue = content.descriptions[Page.aperture.rawValue]
        XCTAssertEqual(testObject.phrase, expectedValue)
    }
}
