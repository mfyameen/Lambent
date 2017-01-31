import Foundation

public class PhotographyModel{
    public init() {}
    
    public func fetchContent(completion: @escaping (_ content: Content, _ images: [Images]) -> ()) {
        let serviceLayer = ServiceLayer()
        serviceLayer.fetchContent { (content, images) in
            DispatchQueue.main.async {
                completion(content, images)
            }
        }
    }
}
