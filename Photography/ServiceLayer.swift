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
    let exercises: [String]
    let instructions: [String]
    let updatedInstructions: [String]
    let modeIntroductions: [String]
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
            var exercises: [String] = []
            var instructions: [String] = []
            var updatedInstructions: [String] = []
            var modeIntroductions: [String] = []
            
            snapshot.children.forEach { item in
                count += 1
                let child = item as? FIRDataSnapshot
                let dict = child?.value as? NSDictionary
        
                guard let section = self.useContent(snapshot: snapshot, key: "section", count: count) else { return }
                sections += [section]
                guard let description = self.useContent(snapshot: snapshot, key: "description", count: count) else { return }
                descriptions += [description]
                guard let instruction = self.useContent(snapshot: snapshot, key: "instruction", count: count) else { return }
                instructions += [instruction]
                guard let updatedInstruction = self.useContent(snapshot: snapshot, key: "updatedInstruction", count: count) else { return }
                updatedInstructions += [updatedInstruction]
                guard let introduction = self.useContent(snapshot: snapshot, key: "introduction", count: count) else { return }
                introductions += [introduction]
                guard let exercise = self.useContent(snapshot: snapshot, key: "exercise", count: count) else { return }
                exercises += [exercise]
                guard let modeIntroduction = self.useContent(snapshot: snapshot, key: "modeIntroduction", count: count) else { return }
                modeIntroductions += [modeIntroduction]
                guard let location = dict?.object(forKey: "location") as? String, let title = dict?.object(forKey: "title") as? String else { return }
                images += [Images(title: title, location: location)]
            }
            let content = Content(sections: sections, descriptions: descriptions, introductions: introductions, exercises: exercises, instructions: instructions, updatedInstructions: updatedInstructions, modeIntroductions: modeIntroductions)
            completion(content, images)
        })
    }
    
    func useContent(snapshot: FIRDataSnapshot, key: String, count: Int) -> String? {
        let snapshot = snapshot.childSnapshot(forPath: ("\(key)s"))
        guard let snapshotDict = snapshot.value as? [String: AnyObject] else { return nil }
        guard let value = snapshotDict[("\(key)\(count)")] as? String else { return nil }
        return value
    }
}


