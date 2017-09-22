import UIKit
import AVFoundation

class CameraOverlay: UIView {
    private let slider = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.backgroundColor()
        alpha = 0.7
        slider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
        addSubview(slider)
    }
    
    @objc private func sliderMoved() {
        print("Yipeee, we're moving")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sliderSize = slider.sizeThatFits(bounds.size)
        let sliderWidth = UIScreen.main.bounds.width * 0.75
        slider.frame = CGRect(x: bounds.midX - sliderWidth/2, y: bounds.midY - sliderSize.height/2, width: sliderWidth, height: sliderSize.height)
    }
}

class CameraHandler: UIView {
    private let imagePicker = UIImagePickerController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imagePicker.sourceType = .camera
        imagePicker.cameraOverlayView = CameraOverlay(frame: CGRect(x: 0, y: 475, width: UIScreen.main.bounds.width, height: 75))
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
