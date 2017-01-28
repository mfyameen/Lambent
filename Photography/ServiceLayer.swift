import Foundation
import Firebase

public struct Images {
    let title: String
    let location: String
}

public struct Content {
    let sections: [String]
}

struct ServiceLayer {
    //unsure of the functionality of the completion blocks
    static func fetchImages(_ completion: @escaping (Content, [Images]) -> ()) {
        let database = FIRDatabase.database().reference()
        var count = 0
        database.observe(.value, with: { (snapshot) in
            var images: [Images] = []
            var sections: [String] = []
            snapshot.children.forEach { item in
                count += 1
                let child = item as? FIRDataSnapshot
                let dict = child?.value as? NSDictionary
                let sectionsSnapshot = snapshot.childSnapshot(forPath: "sections")
                if let sectionDict = sectionsSnapshot.value as? [String: AnyObject] {
                    let key = "section\(count)"
                    if let section = sectionDict[key] as? String {
                     sections += [section]
                     
                    }
                }
                guard let location = dict?.object(forKey: "location") as? String, let title = dict?.object(forKey: "title") as? String else { return }
                images += [Images(title: title, location: location)]
            }
            let content = Content(sections: sections)
            completion(content, images)
        })
    }
    
//    static func fetchImages(_ completion: @escaping ([Images]) -> ()) {
//        let database = FIRDatabase.database().reference()
//        database.observe(.value, with: { (snapshot) in
//            var images: [Images] = []
//            snapshot.children.forEach { item in
//                let child = item as! FIRDataSnapshot
//                let dict = child.value as! NSDictionary
//                guard let location = dict.object(forKey: "location") as? String, let title = dict.object(forKey: "title") as? String else { return }
//                images += [Images(title: title, location: location)]
//            }
//            completion(images)
//        })
//    }
}


