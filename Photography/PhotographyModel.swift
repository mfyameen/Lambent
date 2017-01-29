import Foundation

public class PhotographyModel{
    public init() {}
    var images = [Images]()
    public var sections = [String]()
    public var descriptions = [String]()
    public var introductions = [String]()
    public var exercises = [String]()
    public var instructions = [String]()
    public var modeIntroductions = [String]()
    
    public func fetchContent(completion: @escaping (Content, [Images]) -> ()) {
        let serviceLayer = ServiceLayer()
        serviceLayer.fetchContent { (content, images) in
            self.sections = content.sections
            self.introductions = content.introductions
            self.exercises = content.exercises
            self.instructions = content.instructions
            self.modeIntroductions = content.modeIntroductions
            self.images = images
            DispatchQueue.main.async {
                completion(content, images)
            }
        }
    }
}
