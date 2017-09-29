import UIKit
import AVFoundation

class CameraHandler: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    init(page: Page) {
        super.init(nibName: nil, bundle: nil)
        sourceType = .camera
        let cameraOverlay = CameraOverlay(page: page)
        cameraOverlayView = cameraOverlay
        cameraOverlayView?.frame = frameForOverlay()
        delegate = self
    }
    
    private func frameForOverlay() -> CGRect {
        let screenSize = UIScreen.main.bounds
        let aspectRatio: CGFloat = 4.0/3.0
        let previewHeight = UIScreen.main.bounds.width * aspectRatio
        let topBarHeight = (screenSize.height - previewHeight) * 1/4
        let overlayHeight: CGFloat = 75
        let yPosition = topBarHeight + previewHeight - overlayHeight
        let iPadOverlayWidth = UIScreen.main.bounds.width * 3/4
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ?
            CGRect(x: screenSize.width/2 - iPadOverlayWidth/2, y: yPosition, width: iPadOverlayWidth, height: overlayHeight) :
            CGRect(x: 0, y: yPosition, width: screenSize.width, height: overlayHeight)
    }
    
    func launchImagePicker() {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
}

class CameraOverlay: UIView {
    private let sectionLabel = UILabel()
    private let valueLabel = UILabel()
    private let slider = UISlider()
   
    private let device: AVCaptureDevice
    private let section: Page
 
    init?(page: Page) {
        if #available(iOS 10.0, *) {
            guard let device = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: nil, position: .unspecified).devices.first else { return nil }
            self.device = device
        } else {
            guard let device = AVCaptureDevice.devices().first else { return nil }
            self.device = device
        }
        self.section = page
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.backgroundColor()
        alpha = 0.7
        sectionLabel.text = section.description()
        sectionLabel.numberOfLines = 0
        sectionLabel.textAlignment = .center
        sectionLabel.textColor = .white
        addSubview(sectionLabel)
        valueLabel.textColor = .white
        addSubview(valueLabel)
        configureSlider()
        slider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
        addSubview(slider)
    }
    
    @objc private func sliderMoved() {
        do {
            try device.lockForConfiguration()
            updateExposureMode()
            device.unlockForConfiguration()
        } catch {
            print("unable to lock device due to error: \(error)")
        }
    }
    
    private func updateExposureMode() {
        switch section {
        case .aperture:
            valueLabel.text = String(device.lensAperture)
        case .iso:
            let newISO = slider.value
            valueLabel.text = String(Int(newISO))
            slider.maximumValue = device.activeFormat.maxISO
            device.setExposureModeCustom(duration: device.exposureDuration, iso: newISO, completionHandler: nil)
        case .shutter:
            let newShutterSpeed = CMTime(seconds: Double(slider.value), preferredTimescale: 1000000)
            guard newShutterSpeed.seconds > device.activeFormat.minExposureDuration.seconds && newShutterSpeed.seconds < device.activeFormat.maxExposureDuration.seconds else { return }
            configureShutterText()
            device.setExposureModeCustom(duration: newShutterSpeed, iso: device.iso, completionHandler: nil)
        case .focal:
            let newFocalLength = CGFloat(slider.value)
            valueLabel.text = String(Int(newFocalLength))
            device.videoZoomFactor = newFocalLength
        default: return
        }
        setNeedsLayout()
    }
    
    private func configureSlider() {
        switch section {
        case .iso:
            slider.minimumValue = device.activeFormat.minISO
            slider.maximumValue = device.activeFormat.maxISO
        case .shutter:
            slider.minimumValue = Float(device.activeFormat.minExposureDuration.seconds)
            slider.maximumValue = Float(device.activeFormat.maxExposureDuration.seconds)
        case .focal:
            slider.minimumValue = 1
            slider.maximumValue = Float(device.activeFormat.videoMaxZoomFactor)/4
        default: return
        }
    }
    
    private func configureShutterText() {
        switch slider.value {
        case 0.008 ..< 0.01: valueLabel.text = "1/125"
        case 0.01 ..< 0.03: valueLabel.text = "1/60"
        case 0.03 ..< 0.06: valueLabel.text = "1/30"
        case 0.06 ..< 0.125: valueLabel.text = "1/15"
        case 0.125 ..< 0.25: valueLabel.text = "1/8"
        case 0.25 ..< 0.4: valueLabel.text = "1/4"
        case 0.4 ... 0.5: valueLabel.text = "1/2"
        default: valueLabel.text = "0"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sliderSize = slider.sizeThatFits(bounds.size)
        let sliderWidth = UIScreen.main.bounds.width * 0.5
        slider.frame = CGRect(x: bounds.midX - sliderWidth/2, y: bounds.midY - sliderSize.height/2, width: sliderWidth, height: sliderSize.height)
        let valueLabelSize = valueLabel.sizeThatFits(bounds.size)
        valueLabel.frame = CGRect(x: slider.frame.maxX + Padding.small, y: bounds.midY - valueLabelSize.height/2, width: valueLabelSize.width, height: valueLabelSize.height)
        let contentArea = bounds.divided(atDistance: slider.frame.minX, from: .minXEdge).slice
        let sectionLabelSize = sectionLabel.sizeThatFits(contentArea.size)
        sectionLabel.frame = CGRect(x: slider.frame.minX - sectionLabelSize.width - Padding.small, y: bounds.midY - sectionLabelSize.height/2, width: sectionLabelSize.width, height: sectionLabelSize.height)
    }
}

