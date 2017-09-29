import UIKit

struct HelperMethods {
    static let shadowRadius: CGFloat = 3
    
    static func configureShadow(element: UIView) {
        element.layer.shadowOffset = CGSize(width: 0, height: 0)
        element.layer.shadowColor = UIColor.white.cgColor
        element.layer.shadowOpacity = 0.8
        element.layer.shadowRadius = shadowRadius
    }
}

struct Padding {
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 20
}
