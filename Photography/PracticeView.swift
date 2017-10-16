import UIKit
import AVFoundation

class PracticeView: UIView {
    private let cameraPreview: CameraPreview
    private let container = UIView()
    private let iosSectionContent = SectionContent()
    private let dslrSectionContent = SectionContent()
    
    init(page: Page) {
        cameraPreview = CameraPreview(page: page)
        super.init(frame: CGRect.zero)
        addSubview(cameraPreview)
        container.backgroundColor = UIColor.containerColor()
        addSubview(container)
        iosSectionContent.section.numberOfLines = 0
        iosSectionContent.section.text = "iOS"
        iosSectionContent.content.text = "alsdkfjasl;dfjsl;dkfjdsfsjalkdfjalskfjas;kldfjasdl;kfjaslfjsadkfjasdlfjaslkfjalsdkjfalsdkjfa;slkdfjas;lkdfja;sldkfja;slkdfjakdjfklajflsdjasdl;kjfl;asjf;lasdjf;alsdfjasdl;kfjal;ksdfjsa"
        addSubview(iosSectionContent)
        dslrSectionContent.section.text = "DSLR"
        addSubview(dslrSectionContent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addContent(_ content: String) {
        iosSectionContent.content.text = content
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        let cameraPreviewSize = cameraPreview.sizeThatFits(bounds.size)
        cameraPreview.frame = CGRect(x: bounds.midX - cameraPreviewSize.width/2, y: bounds.minY + Padding.extraLarge, width: cameraPreviewSize.width, height: cameraPreviewSize.height)
        container.frame = CGRect(x: bounds.minX, y: cameraPreview.frame.maxY * 1/4, width: bounds.width, height: cameraPreview.frame.height * 3/4)
        let inset: CGFloat = 18
        let contentArea = bounds.insetBy(dx: inset, dy: inset).divided(atDistance: container.frame.minY, from: .minYEdge).remainder
        let iOSContentArea = contentArea.divided(atDistance: contentArea.height/2, from: .minYEdge).slice
        let iosSectionContentSize = iosSectionContent.sizeThatFits(iOSContentArea.size)
        iosSectionContent.frame = CGRect(x: iOSContentArea.midX - iosSectionContentSize.width/2, y: container.frame.minY + Padding.small, width: iosSectionContentSize.width, height: iosSectionContentSize.height)
        let dslrContentArea = contentArea.divided(atDistance: contentArea.height/2, from: .minYEdge).remainder
        let dslrSectionContentSize = dslrSectionContent.sizeThatFits(dslrContentArea.size)
        dslrSectionContent.frame = CGRect(x: dslrContentArea.midX - dslrSectionContentSize.width/2, y: iosSectionContent.frame.maxY + Padding.small, width: dslrSectionContentSize.width, height: dslrSectionContentSize.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let cameraPreviewHeight = cameraPreview.sizeThatFits(size).height/4
        let inset: CGFloat = 36
        let fittedSize = CGSize(width: size.width - inset, height: (size.height - inset - cameraPreviewHeight)/2)
        let iosSectionHeight = iosSectionContent.sizeThatFits(fittedSize).height
        let dslrSectionHeight = dslrSectionContent.sizeThatFits(fittedSize).height
        let totalHeight = Padding.extraLarge + cameraPreviewHeight + iosSectionHeight + dslrSectionHeight
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
        icon.image = UIImage(named: "Lambent")
        addSubview(icon)
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
        let imageDimension = imagePicker.view.frame.maxY * 1/4
        let imageSize = CGSize(width: imageDimension, height: imageDimension)
        icon.frame = CGRect(x: imagePicker.view.frame.midX - imageSize.width/2, y: imagePicker.view.frame.minY, width: imageSize.width, height: imageSize.height)
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



