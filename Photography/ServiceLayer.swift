import Foundation
import Firebase

struct Images {
    let title: String
    let location: URL
}

struct ServiceLayer {
    static func fetchImages() {
        let database = FIRDatabase.database().reference()
        database.child("images").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let result = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            print("--------------------------------------- \(result) -------------------------------------------")
            let snapshotValue = snapshot.value as! [String: Any]
            let imageURL = snapshotValue["waterfall4"] as! String
            print(imageURL)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
