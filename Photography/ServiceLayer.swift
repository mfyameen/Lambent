import Foundation
import Firebase

public struct Images {
    let title: String
    let location: String
}

public struct Content {
    let sections: [String]
    let descriptions: [String]
    let introductions: [String]
}

struct ServiceLayer {
    func fetchContent(_ completion: @escaping (Content, [Images]) -> ()) {
        let database = FIRDatabase.database().reference()
        var count = 0
        database.observe(.value, with: { (snapshot) in
            var images: [Images] = []
            var sections: [String] = []
            var descriptions: [String] = []
            var introductions: [String] = []
            snapshot.children.forEach { item in
                count += 1
                let child = item as? FIRDataSnapshot
                let dict = child?.value as? NSDictionary
                
                guard let section = self.useContent(snapshot: snapshot, key: "sections", count: count),
                      let description = self.useContent(snapshot: snapshot, key: "descriptions", count: count),
                      let introduction = self.useContent(snapshot: snapshot, key: "introductions", count: count) else { return }
                sections += [section]
                descriptions += [description]
                introductions += [introduction]

                guard let location = dict?.object(forKey: "location") as? String, let title = dict?.object(forKey: "title") as? String else { return }
                images += [Images(title: title, location: location)]
            }
            let content = Content(sections: sections, descriptions: descriptions, introductions: introductions)
            completion(content, images)
        })
    }
    
    func useContent(snapshot: FIRDataSnapshot, key: String, count: Int) -> String? {
        let snapshot = snapshot.childSnapshot(forPath: key)
        guard let snapshotDict = snapshot.value as? [String: AnyObject] else { return nil }
        var newKey = key
        newKey.characters.removeLast()
        let finalKey = ("\(newKey)\(count)")
        guard let dict = snapshotDict[finalKey] as? String else { return nil }
        return dict
    }
}


