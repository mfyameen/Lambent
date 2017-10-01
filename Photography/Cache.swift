import UIKit
import RxSwift
import RxSugar

struct ImageContent {
    let images: [Image]
    let cache: NSCache<NSString, UIImage>
}

class Cache: RXSObject {
    let imageContent: Observable<ImageContent>
    private let _imageContent = PublishSubject<ImageContent>()
    
    init() {
        imageContent = _imageContent.asObservable()
        rxs.disposeBag
            ++ _imageContent.asObserver() <~ ServiceLayer.fetchImages().map(cache)
    }
    
    private func cache(_ images: [Image]) -> ImageContent {
        let cache = NSCache<NSString, UIImage>()
        images.forEach({ image in
            DispatchQueue.global().async {
                guard let url = URL(string: image.location), let data = NSData(contentsOf: url), let preCachedImage = UIImage(data: data as Data) else { return }
                DispatchQueue.main.async {
                    cache.setObject(preCachedImage, forKey: image.title as NSString)
                }
            }
        })
        return ImageContent(images: images, cache: cache)
    }
}
