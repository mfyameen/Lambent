import UIKit
import RxSugar
import RxSwift

public class PhotographyModel: RXSObject {
    let content: Observable<Content>
    let _content = Variable<Content>(Content(sections: [], descriptions: [], introductions: [], exercises: [], instructions: [], updatedInstructions: [], modeIntroductions: []))
    let images: Observable<ImageContent>
    private let _images = Variable<ImageContent>(ImageContent(images: [], cache: NSCache()))
    private let serviceLayer = ServiceLayer()
    private let cache = Cache()

    init() {
        content = _content.asObservable()
        images = _images.asObservable()

        rxs.disposeBag
        ++ _content.asObserver() <~ serviceLayer.fetchContent()
        ++ _images.asObserver() <~ cache.imageContent
    }
}
