import UIKit

struct Cache {
    private let cache = NSCache<NSString, UIImage>()
    
    public func fetchCachedImage(_ completion: @escaping ([Images], NSCache<NSString, UIImage>) -> ()) {
        let serviceLayer = ServiceLayer()
        serviceLayer.fetchImage { images in
            self.cache(images)
            completion(images, self.cache)
        }
    }
    
    private func cache(_ images: [Images]) {
        images.forEach({ image in
            DispatchQueue.global().async { _ in
                guard let url = URL(string: image.location),
                    let data = NSData(contentsOf: url),
                    let preCachedImage = UIImage(data: data as Data) else { return }
                DispatchQueue.main.async { _ in
                    self.cache.setObject(preCachedImage, forKey: image.title as NSString)
                }
            }
        })
    }
}
