import UIKit
import AVFoundation

class CameraPreview: UIView {
    private let cameraHandler: CameraHandler
    private let imagePicker = UIImagePickerController()
    private let icon = UIImageView()
    private let camera = UIButton()
    
    init(page: Page) {
        cameraHandler = CameraHandler(page: page)
        super.init(frame: CGRect.zero)
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = false
        addSubview(imagePicker.view)
        icon.image = UIImage(named: "AppIcon")
        icon.layer.cornerRadius = 4
        addSubview(icon)
        camera.addTarget(self, action: #selector(cameraSelection), for: .touchUpInside)
        addSubview(camera)
//        let screenBounds = UIScreen.main.bounds.size
//        let scale = bounds.height / bounds.width
//        imagePicker.cameraViewTransform = CGAffineTransform().scaledBy(x: scale, y: scale)
    }
    
    @objc private func cameraSelection() {
        cameraHandler.launchImagePicker()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePickerSize = CGSize(width: bounds.width, height: 150)
        let iconSize = CGSize(width: 50, height: 50)
        icon.frame = CGRect(x: bounds.midX - iconSize.width/2, y: bounds.midY - iconSize.height/2, width: iconSize.width, height: iconSize.height)
        let frame = CGRect(x: bounds.midX - imagePickerSize.width/2, y: bounds.minY, width: imagePickerSize.width, height: imagePickerSize.height)
        imagePicker.view.frame = frame
        camera.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PracticeView: UIView {
    private let iOSLabel = UILabel()
    private let cameraPreview: CameraPreview
    private let cameraIcon = UIButton()
    private let dslrLabel = UILabel()
    private let padding: CGFloat = 8
    
    init(page: Page) {
        cameraPreview = CameraPreview(page: page)
        super.init(frame: CGRect.zero)
        iOSLabel.text = "iOS"
        iOSLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(iOSLabel)
        addSubview(cameraPreview)
        cameraIcon.setTitle("Camera", for: .normal)
        cameraIcon.setTitleColor(.blue, for: .normal)
        addSubview(cameraIcon)
        dslrLabel.text = "DSLR"
        dslrLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(dslrLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let iOSLabelSize = iOSLabel.sizeThatFits(bounds.size)
        iOSLabel.frame = CGRect(x: bounds.midX - iOSLabelSize.width/2, y: bounds.minY, width: iOSLabelSize.width, height: iOSLabelSize.height)
        let cameraPreviewSize = CGSize(width: bounds.width, height: 150)
        cameraPreview.frame = CGRect(x: bounds.midX - cameraPreviewSize.width/2, y: iOSLabel.frame.maxY + padding, width: cameraPreviewSize.width, height: cameraPreviewSize.height)
        let cameraSize = cameraIcon.sizeThatFits(bounds.size)
        cameraIcon.frame = CGRect(x: bounds.midX - cameraSize.width/2, y: cameraPreview.frame.maxY + padding, width: cameraSize.width, height: cameraSize.height)
        let dslrLabelSize = dslrLabel.sizeThatFits(bounds.size)
        dslrLabel.frame = CGRect(x: bounds.midX - dslrLabelSize.width/2, y: cameraIcon.frame.maxY + padding, width: dslrLabelSize.width, height: dslrLabelSize.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let iOSLabelHeight = iOSLabel.sizeThatFits(bounds.size).height
        let cameraPreviewHeight = cameraPreview.sizeThatFits(bounds.size).height
        let cameraHeight = cameraIcon.sizeThatFits(bounds.size).height
        let dslrLabelHeight = dslrLabel.sizeThatFits(bounds.size).height
        let totalHeight = iOSLabelHeight + cameraPreviewHeight + cameraHeight + dslrLabelHeight + padding * 4
        return CGSize(width: size.width, height: totalHeight)
    }  
}


