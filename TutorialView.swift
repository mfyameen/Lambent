import Foundation
import UIKit

class TutorialView: UIView{
    private let view = UIView()
    
    override init (frame: CGRect){
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        view.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        view.layer.cornerRadius = 8
        addSubviews([view])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let insets = UIEdgeInsetsMake(85, 18, 25, 18)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        view.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height)
    }
}
