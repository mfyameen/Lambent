import UIKit
import RxSugar
import RxSwift

public class PhotographyModel: RXSObject {
    let content: Observable<Content>
    private let _content = PublishSubject<Content>()
    let images: Observable<ImageContent>
    private let _images = PublishSubject<ImageContent>()

    init() {
        content = _content.asObservable()
        images = _images.asObservable()
        let cache = Cache()

        rxs.disposeBag
        ++ _content.asObserver() <~ ServiceLayer.fetchContent()
        ++ _images.asObserver() <~ cache.imageContent
    }
}
