import Foundation
import Firebase

public struct Images {
    public let title: String
    public let location: String
    
    public init(title: String, location: String) {
        self.title = title
        self.location = location
    }
}

public struct Content {
    public let sections: [String]
    public let descriptions: [String]
    public let introductions: [String]
    public let exercises: [String]
    public let instructions: [String]
    public let updatedInstructions: [String]
    public let modeIntroductions: [String]
    
    public init(sections: [String], descriptions: [String], introductions: [String], exercises: [String], instructions: [String], updatedInstructions: [String], modeIntroductions: [String]) {
        self.sections = sections
        self.descriptions = descriptions
        self.introductions = introductions
        self.exercises = exercises
        self.instructions = instructions
        self.updatedInstructions = updatedInstructions
        self.modeIntroductions = modeIntroductions
    }
}

struct ServiceLayer {
    func fetchContent(_ completion: @escaping (Content, [Images]) -> ()) {
        let database = FIRDatabase.database().reference()
        var count = 0
        var images: [Images] = []
        var sections: [String] = []
        var descriptions: [String] = []
        var introductions: [String] = []
        var exercises: [String] = []
        var instructions: [String] = []
        var updatedInstructions: [String] = []
        var modeIntroductions: [String] = []
        database.observe(.value, with: { snapshot in
            snapshot.children.forEach { item in
                count += 1
                let child = item as? FIRDataSnapshot
                let dict = child?.value as? NSDictionary
                guard let section = self.obtainValue(snapshot: snapshot, key: "section", count: count) else { return }
                sections += [section]
                guard let description = self.obtainValue(snapshot: snapshot, key: "description", count: count) else { return }
                descriptions += [description]
                guard let instruction = self.obtainValue(snapshot: snapshot, key: "instruction", count: count) else { return }
                instructions += [instruction]
                guard let updatedInstruction = self.obtainValue(snapshot: snapshot, key: "updatedInstruction", count: count) else { return }
                updatedInstructions += [updatedInstruction]
                guard let introduction = self.obtainValue(snapshot: snapshot, key: "introduction", count: count) else { return }
                introductions += [introduction]
                guard let exercise = self.obtainValue(snapshot: snapshot, key: "exercise", count: count) else { return }
                exercises += [exercise]
                guard let modeIntroduction = self.obtainValue(snapshot: snapshot, key: "modeIntroduction", count: count) else { return }
                modeIntroductions += [modeIntroduction]
                guard let location = dict?.object(forKey: "location") as? String, let title = dict?.object(forKey: "title") as? String else { return }
                images += [Images(title: title, location: location)]
            }
            let content = Content(sections: sections, descriptions: descriptions, introductions: introductions, exercises: exercises, instructions: instructions, updatedInstructions: updatedInstructions, modeIntroductions: modeIntroductions)
            completion(content, images)
        })
    }
    
    private func obtainValue(snapshot: FIRDataSnapshot, key: String, count: Int) -> String? {
        let snapshot = snapshot.childSnapshot(forPath: ("\(key)s"))
        guard let snapshotDict = snapshot.value as? [String: AnyObject] else { return nil }
        guard let value = snapshotDict[("\(key)\(count)")] as? String else { return nil }
        return value
    }
}


