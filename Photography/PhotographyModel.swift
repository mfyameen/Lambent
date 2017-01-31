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
    
    public func fetchImage(_ completion: @escaping ([Images], NSCache<NSString, UIImage>) -> ()) {
        let serviceLayer = ServiceLayer()
        serviceLayer.fetchImage { (images, cache) in
            DispatchQueue.main.async {
                completion(images, cache)
            }
        }
    }
}
