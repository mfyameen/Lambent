import Foundation
import Firebase

struct Images {
    let title: String
    let location: String
}

struct ServiceLayer {
    //unsure of the functionality of the completion blocks
    static func fetchImages(_ completion: @escaping ([Images]) -> ()) {
        let database = FIRDatabase.database().reference()
        database.observe(.value, with: { (snapshot) in
            var images: [Images] = []
            snapshot.children.forEach { item in
                let child = item as! FIRDataSnapshot
                let dict = child.value as! NSDictionary
                guard let location = dict.object(forKey: "location") as? String, let title = dict.object(forKey: "title") as? String else { return }
                images += [Images(title: title, location: location)]
            }
            completion(images)
        })
    }
}


