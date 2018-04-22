import UIKit

class FadingScrollView: UITextView {
 
    override func layoutSubviews() {
        super.layoutSubviews()
        guard contentSize.height > bounds.height else { layer.mask = nil; return }

        let gradientMask = CAGradientLayer()
        let transparent = UIColor.clear.cgColor
        let opaque = UIColor.black.cgColor
        
        gradientMask.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientMask.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientMask.locations = [NSNumber(value: 0.0), NSNumber(value: 0.05), NSNumber(value: 0.95), NSNumber(value: 1.0)]
        
        if contentOffset.y <= 0 { //graident at bottom
            gradientMask.colors = [opaque, opaque, opaque, transparent]
        } else if contentOffset.y >= contentSize.height - frame.height { //gradient at top
            gradientMask.colors = [transparent, opaque, opaque, opaque]
        } else { //gradient at top and bottom
            gradientMask.colors = [transparent, opaque, opaque, transparent]
        }
        gradientMask.frame = bounds
        layer.mask = gradientMask
    }
}
