import UIKit
import AVFoundation

class CameraOverlay: UIView {
    private let slider = UISlider()
    private let device: AVCaptureDevice?
    private let section: Page
 
    init(section: Page) {
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: nil, position: .unspecified)
        let device = session.devices.first
        self.section = section
        self.device = device
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.backgroundColor()
        alpha = 0.7
        device.map { configureSlider(forFormat: $0.activeFormat) }
        slider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
        addSubview(slider)
    }
    
    @objc private func sliderMoved() {
        do {
            try device?.lockForConfiguration()
            updateExposureMode()
            device?.unlockForConfiguration()
        } catch {
            print("unable to lock device due to error: \(error)")
        }
    }
    
    private func updateExposureMode() {
        switch section {
        case .iso:
            let newISO = slider.value
            device?.setExposureModeCustom(duration: device?.exposureDuration ?? CMTime(), iso: newISO, completionHandler: nil)
        case .shutter:
            let newShutterSpeed = CMTime(seconds: Double(slider.value), preferredTimescale: 1000000)
            guard newShutterSpeed.seconds > device?.activeFormat.minExposureDuration.seconds ?? 0 && newShutterSpeed.seconds < device?.activeFormat.maxExposureDuration.seconds ?? 0.5 else { return }
            device?.setExposureModeCustom(duration: newShutterSpeed, iso: device?.iso ?? device?.activeFormat.minISO ?? 0, completionHandler: nil)
        default: return
        }
    }
    
    private func configureSlider(forFormat format: AVCaptureDevice.Format ) {
        switch section {
        case .iso:
            slider.minimumValue = format.minISO
            slider.maximumValue = format.maxISO
        case .shutter:
            slider.minimumValue = Float(format.minExposureDuration.seconds)
            slider.maximumValue = Float(format.maxExposureDuration.seconds)
        default: return
        }
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
    
    init(section: Page) {
        super.init(frame: CGRect.zero)
        imagePicker.sourceType = .camera
        let cameraOverlay = CameraOverlay(section: section)
        cameraOverlay.frame = CGRect(x: 0, y: 475, width: UIScreen.main.bounds.width, height: 75)
        imagePicker.cameraOverlayView = cameraOverlay

        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
