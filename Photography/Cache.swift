import UIKit
import RxSwift
import RxSugar

struct ImageContent {
    let images: [Image]
    let cache: NSCache<NSString, UIImage>
}

class Cache: RXSObject {
    private let cache = NSCache<NSString, UIImage>()
    private let serviceLayer = ServiceLayer()
    
    let imageContent: Observable<ImageContent>
    private let _imageContent = Variable<ImageContent>(ImageContent(images: [], cache: NSCache()))
    
    init() {
        imageContent = _imageContent.asObservable()
        rxs.disposeBag
            ++ _imageContent.asObserver() <~ serviceLayer.fetchImages().map{ self.cache($0) }.map { ImageContent(images: $0, cache: self.cache) }
    }
    
    private func cache(_ images: [Image]) -> [Image]{
        images.forEach({ image in
            DispatchQueue.global().async {
                guard let url = URL(string: image.location), let data = NSData(contentsOf: url), let preCachedImage = UIImage(data: data as Data) else { return }
                DispatchQueue.main.async {
                    self.cache.setObject(preCachedImage, forKey: image.title as NSString)
                }
            }
        })
        return images
    }
}
