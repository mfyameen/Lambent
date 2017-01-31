import Foundation

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
    
    public func fetchImage(completion: @escaping([Images]) -> ()) {
        let serviceLayer = ServiceLayer()
        serviceLayer.fetchImage { images in
            DispatchQueue.main.async {
                completion(images)
            }
        }
    }
}
