import UIKit

public class PhotographyModel{
    public init() {}
    
    public func fetchContent(completion: @escaping (Content) -> ()) {
        let serviceLayer = ServiceLayer()
        serviceLayer.fetchContent { content in
            DispatchQueue.main.async {
                completion(content)
            }
        }
    }
    
    public func fetchCachedImage(_ completion: @escaping ([Images], NSCache<NSString, UIImage>) -> ()) {
        let cache = Cache()
        cache.fetchCachedImage { (images, cache) in
            DispatchQueue.main.async {
                completion(images, cache)
            }
        }
    }
}
