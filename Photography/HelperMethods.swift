import UIKit

struct HelperMethods {
    static func configureShadow(element: UIView) {
        element.layer.shadowOffset = CGSize(width: 0, height: 0)
        element.layer.shadowColor = UIColor.gray.cgColor
        element.layer.shadowOpacity = 0.5
        element.layer.shadowRadius = CGFloat(3)
    }
}
