import UIKit
import AVFoundation

class CameraPreview: UIView {
    private let cameraHandler: CameraHandler
    private let imagePicker = UIImagePickerController()
    private let icon = UIImageView()
    private let camera = UIButton()
    private let aspectRatio: CGFloat = 59/58
    
    init(page: Page) {
        cameraHandler = CameraHandler(page: page)
        super.init(frame: CGRect.zero)
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = false
        addSubview(imagePicker.view)
        icon.image = UIImage(named: "AppIcon")
        //addSubview(icon)
        camera.addTarget(self, action: #selector(cameraSelection), for: .touchUpInside)
        addSubview(camera)
    }
    
    @objc private func cameraSelection() {
        cameraHandler.launchImagePicker()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePickerSize = CGSize(width: bounds.width, height: bounds.width * aspectRatio)
        let frame = CGRect(x: bounds.midX - imagePickerSize.width/2, y: 0, width: imagePickerSize.width, height: imagePickerSize.height)
        imagePicker.view.frame = frame
        camera.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height = size.width * aspectRatio
        return CGSize(width: size.width, height: height)
    }
}

class PracticeView: UIView {
    private let iOSLabel = UILabel()
    private let cameraPreview: CameraPreview
    private let dslrLabel = UILabel()
    private let padding: CGFloat = 8
    
    init(page: Page) {
        cameraPreview = CameraPreview(page: page)
        super.init(frame: CGRect.zero)
        iOSLabel.text = "iOS"
        iOSLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(iOSLabel)
        addSubview(cameraPreview)
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
        let cameraPreviewSize = cameraPreview.sizeThatFits(bounds.size)
        cameraPreview.frame = CGRect(x: bounds.midX - cameraPreviewSize.width/2, y: iOSLabel.frame.maxY + padding, width: cameraPreviewSize.width, height: cameraPreviewSize.height)
        let dslrLabelSize = dslrLabel.sizeThatFits(bounds.size)
        dslrLabel.frame = CGRect(x: bounds.midX - dslrLabelSize.width/2, y: cameraPreview.frame.maxY + padding, width: dslrLabelSize.width, height: dslrLabelSize.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let iOSLabelHeight = iOSLabel.sizeThatFits(size).height
        let cameraPreviewHeight = cameraPreview.sizeThatFits(size).height
        let dslrLabelHeight = dslrLabel.sizeThatFits(size).height
        let totalHeight = iOSLabelHeight + cameraPreviewHeight + dslrLabelHeight + 2 * padding
        return CGSize(width: size.width, height: totalHeight)
    }  
}


