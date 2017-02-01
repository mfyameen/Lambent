import UIKit

public class PhotographyModel {
    
    func fetchContent(_ completion: @escaping (Content) -> ()) {
        let serviceLayer = ServiceLayer()
        serviceLayer.fetchContent { content in
            DispatchQueue.main.async {
                completion(content)
            }
        }
    }
    
    func fetchCachedImages(_ completion: @escaping ([Images],NSCache<NSString, UIImage>) -> ()) {
        let cache = Cache()
        cache.fetchCachedImage { (images, cache) in
            DispatchQueue.main.async {
                completion(images, cache)
            }
        }
    }
}
