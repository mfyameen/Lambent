import UIKit
import AVFoundation

class PracticeView: UIView {
    private let cameraPreview: CameraPreview
    private let iOSLabel = UILabel()
    private let iOSInstructions = UILabel()
    private let container = UIView()
    private let dslrLabel = UILabel()
    
    init(page: Page) {
        cameraPreview = CameraPreview(page: page)
        super.init(frame: CGRect.zero)
        addSubview(cameraPreview)
        container.clipsToBounds = true
        container.backgroundColor = UIColor.containerColor()
        addSubview(container)
        iOSLabel.text = "iOS"
        iOSLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(iOSLabel)
        iOSInstructions.text = "dlkjfa;lsdjfa;sldfjd"
        iOSInstructions.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(iOSInstructions)
        dslrLabel.text = "DSLR"
        dslrLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(dslrLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let cameraPreviewSize = cameraPreview.sizeThatFits(bounds.size)
        cameraPreview.frame = CGRect(x: bounds.midX - cameraPreviewSize.width/2, y: bounds.minY + Padding.extraLarge, width: cameraPreviewSize.width, height: cameraPreviewSize.height)
        container.frame = CGRect(x: bounds.minX, y: cameraPreview.frame.maxY * 1/3, width: bounds.width, height: cameraPreview.frame.height * 2/3)
        let iOSLabelSize = iOSLabel.sizeThatFits(bounds.size)
        iOSLabel.frame = CGRect(x: bounds.midX - iOSLabelSize.width/2, y: container.frame.minY + Padding.small, width: iOSLabelSize.width, height: iOSLabelSize.height)
        let iOSInstructionsSize = iOSInstructions.sizeThatFits(bounds.size)
        iOSInstructions.frame = CGRect(x: bounds.minX, y: iOSLabel.frame.maxY + Padding.small, width: iOSInstructionsSize.width, height: iOSInstructionsSize.height)
        let dslrLabelSize = dslrLabel.sizeThatFits(bounds.size)
        dslrLabel.frame = CGRect(x: bounds.midX - dslrLabelSize.width/2, y: iOSInstructions.frame.maxY + Padding.small, width: dslrLabelSize.width, height: dslrLabelSize.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let cameraPreviewHeight = cameraPreview.sizeThatFits(size).height/3
        let iOSLabelHeight = iOSLabel.sizeThatFits(size).height
        let iOSInstructionsHeight = iOSInstructions.sizeThatFits(size).height
        let dslrLabelHeight = dslrLabel.sizeThatFits(size).height
        let totalHeight = Padding.extraLarge + cameraPreviewHeight + iOSLabelHeight + iOSInstructionsHeight + dslrLabelHeight + 3 * Padding.small
        return CGSize(width: size.width, height: totalHeight)
    }
}

class CameraPreview: UIView {
    private let cameraHandler: CameraHandler
    private let imagePicker = UIImagePickerController()
    private let icon = UIImageView()
    private let camera = UIButton()
    private let aspectRatio: CGFloat = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ? 1 : 4/3
    
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



