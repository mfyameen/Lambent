import UIKit

public enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
}

public class DemoView: UIView {
    private let imageView = UIImageView()
    private let slider = UISlider()
    private let cameraValue = UILabel()
    private var newCameraValue: String?
    private let cameraSensor = UIView()
    private let cameraSensorSize : CGFloat = 44
    private let cameraSensorOpening = UIView()
    private var cameraOpeningSize: CGFloat = 38
    private let demoInstructions = UILabel()
    
    var instruction: String? {
        didSet {
            demoInstructions.text = instruction
        }
    }
    
    var currentSection: String? {
        didSet {
            guard let section = CameraSections(rawValue: currentSection ?? "") else { return }
            _ = configureAppropriateSectionWhenInitialized(section)
        }
    }

    public init() {
        super.init(frame: CGRect.zero)
        cameraValue.font = UIFont.systemFont(ofSize: 32)
        configureDemoInstructions()
        addSubviews([imageView, cameraValue, cameraSensor, cameraSensorOpening, slider, demoInstructions])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureAppropriateSectionWhenInitialized(_ section: CameraSections) -> UIImage? {
        configureSlider()
        setNeedsLayout()
        switch section {
        case .Aperture:
            configureSensor()
            cameraValue.text = newCameraValue ?? "f/2.8"
            return configureImage(apertureImage: "flower", shutterImage: nil, isoImage: nil, focalImage: nil)
        case .Shutter:
            cameraValue.text = newCameraValue ?? "1/2"
            return configureImage(apertureImage: nil, shutterImage: "bird", isoImage: nil, focalImage: nil)
        case .ISO:
            cameraValue.text = newCameraValue ?? "100"
            return nil
        case .Focal: return nil
            
        }
    }
    
    private func configureDemoInstructions() {
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
    }
    
    private func configureImage(apertureImage: String?, shutterImage: String?, isoImage: String?, focalImage: String?) -> UIImage? {
        guard let section = CameraSections(rawValue: currentSection ?? "") else { return nil }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        switch section {
        case .Aperture:
            imageView.image = UIImage(named: apertureImage ?? "")
        case .Shutter:
            imageView.image = UIImage(named: shutterImage ?? "")
        case .ISO:
            imageView.image = UIImage(named: isoImage ?? "")
        case .Focal:
            imageView.image =  UIImage(named: focalImage ?? "")
        }
        return imageView.image
    }
    
    private func configureSlider() {
        slider.isContinuous = true
        slider.minimumValue = 2
        slider.maximumValue = 22
        slider.addTarget(self, action: #selector(configureAppropriateSectionWhenSliderValueChanged), for: .valueChanged)
    }
    
    private func configureSensor() {
        cameraSensor.layer.cornerRadius = cameraSensorSize/2
        cameraSensor.backgroundColor = UIColor.sensorColor()
        cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        cameraSensorOpening.backgroundColor = UIColor.backgroundColor()
    }
    
    @objc private func configureAppropriateSectionWhenSliderValueChanged() {
        switch round(slider.value) {
        case 3:
            imageView.image = configureImage(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil )
            configureSliderSetting(aperture: "f/2.8", shutter: "1/2", iso: "100", focal: nil, size: 38)
        case 4:
            imageView.image = configureImage(apertureImage: "bird", shutterImage: "flower", isoImage: nil, focalImage: nil )
            configureSliderSetting(aperture: "f/4", shutter: "1/4", iso: "200", focal: nil, size: 34)
        case 6:
             imageView.image = configureImage(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil )
            configureSliderSetting(aperture: "f/5.6", shutter: "1/8", iso: "400", focal: nil, size: 24)
        case 8: configureSliderSetting(aperture: "f/8", shutter: "1/15", iso: "800", focal: nil, size: 20)
        case 11: configureSliderSetting(aperture: "f/11", shutter: "1/30", iso: "1600", focal: nil, size: 16)
        case 16: configureSliderSetting(aperture: "f/16", shutter: "1/60", iso: "3200", focal: nil, size: 12)
        case 22: configureSliderSetting(aperture: "f/22", shutter: "1/125", iso: "6400", focal: nil, size: 8)
        default: break
        }
        newCameraValue = cameraValue.text
        setNeedsLayout()
    }
    
    private func configureSliderSetting(aperture: String, shutter: String, iso: String?, focal: String?, size: CGFloat) {
        guard let section = CameraSections(rawValue: currentSection ?? "") else { return }
        switch section {
        case .Aperture:
            cameraValue.text = aperture
            cameraOpeningSize = size
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case .Shutter: cameraValue.text = shutter
        case .ISO: cameraValue.text = iso
        case .Focal: break
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let cameraPadding: CGFloat = 10
        let imagePadding: CGFloat = 40
        
        imageView.frame = CGRect(x: bounds.minX, y: bounds.minY + TutorialView.segmentedHeight + imagePadding, width: bounds.width, height: bounds.height * 0.6)
        
        cameraSensor.frame = CGRect(x: bounds.midX - cameraSensorSize - cameraPadding, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraSensorSize/2, width: cameraSensorSize, height: cameraSensorSize)
        
        cameraSensorOpening.frame = CGRect(x: cameraSensor.frame.midX - cameraOpeningSize/2, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraOpeningSize/2, width: cameraOpeningSize, height: cameraOpeningSize)
        
        let cameraValueSize = cameraValue.sizeThatFits(bounds.size)
        cameraValue.frame = CGRect(x: bounds.midX, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraValueSize.height/2, width: cameraValueSize.width, height: cameraValueSize.height)
        
        let sliderWidth = TutorialView.segmentedWidth
        let sliderHeight = slider.sizeThatFits(bounds.size).height
        slider.frame = CGRect(x: bounds.midX - sliderWidth/2, y: (imageView.frame.maxY + bounds.maxY)/2 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
        
        let demoInstructionHeight = demoInstructions.sizeThatFits(bounds.size).height
        demoInstructions.frame = CGRect(x: bounds.midX - sliderWidth/2, y: (slider.frame.maxY + bounds.maxY)/2 - demoInstructionHeight/2, width: sliderWidth, height: demoInstructionHeight)
    }
}
