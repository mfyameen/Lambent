import UIKit

enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
}

public class DemoView: UIView {
    private var imageView = UIImageView()
    private let slider = UISlider()
    private let cameraValue = UILabel()
    private var newCameraValue: String?
    private let cameraSensor = UIView()
    private let cameraSensorSize : CGFloat = 44
    private let cameraSensorOpening = UIView()
    private var cameraOpeningSize: CGFloat = 38
    private let demoInstructions = UILabel()
    private var isAperture = false
    private var isShutter = false
   
    var instruction: String? {
        didSet {
            demoInstructions.text = instruction
        }
    }
    
    var currentSection: String? {
        didSet {
            _ = configureAppropriateCameraSection(currentSection ?? "")
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
    
    public func configureAppropriateCameraSection(_ section: String) -> (UIImage?, UISlider?) {
        guard let section = CameraSections(rawValue: section) else { return (nil, nil) }
        setNeedsLayout()
        switch section {
        case .Aperture:
            isAperture = true
            configureSensor()
            let image = configureImage("flower")
            let slider = configureSlider(min: 2.8, max: 22)
            return (image, slider)
        case .Shutter:
            isShutter = true
            let image = configureImage("bird")
            let slider = configureSlider(min: 2, max: 125)
            return (image, slider)
        case .ISO:
            return (nil, nil)
        case .Focal:
            return (nil, nil)
        }
    }
    
    private func configureDemoInstructions() {
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
    }
    
    private func configureImage(_ image: String?) -> UIImage? {
        imageView.image = UIImage(named: image ?? "")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView.image
    }
    
    private func configureSlider(min: Float, max: Float) -> UISlider {
        slider.isContinuous = true
        slider.minimumValue = min
        slider.maximumValue = max
    
        if isAperture {
            cameraValue.text = newCameraValue ?? String(min)
            slider.addTarget(self, action: #selector(apertureSliderChanged), for: .valueChanged)
        } else if isShutter {
            slider.addTarget(self, action: #selector(shutterSliderChanged), for: .valueChanged)
        }
        
        return slider
    }
    
    private func configureSensor() {
        cameraValue.text = newCameraValue ?? String(slider.value)
        cameraSensor.layer.cornerRadius = cameraSensorSize/2
        cameraSensor.backgroundColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.00)
        cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        cameraSensorOpening.backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
    }
    
    @objc private func apertureSliderChanged() {
        switch sliderValue() {
        case round(2.8):
            cameraValue.text = "f/2.8"
            cameraOpeningSize = 38
        case 4:
            cameraValue.text = "f/4"
            cameraOpeningSize = 34
        case round(5.6):
            cameraValue.text = "f/5.6"
            cameraOpeningSize = 24
        case 8:
            cameraValue.text = "f/8"
            cameraOpeningSize = 20
        case 11:
            cameraValue.text = "f/11"
            cameraOpeningSize = 16
        case 16:
            cameraValue.text = "f/16"
            cameraOpeningSize = 12
        case 22:
            cameraValue.text = "f/22"
            cameraOpeningSize = 8
        default: break
        }
        newCameraValue = cameraValue.text
        cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        setNeedsLayout()
    }
    
    @objc private func shutterSliderChanged() {
        switch sliderValue() {
        case 2: cameraValue.text = "1/2"
        case 4: break
        case 8: break
        case 15: break
        case 30: break
        case 60: break
        case 125: break
        default: break
        }
    }
    
    let ISO = [100, 200, 400, 800, 1600, 3200, 6400]
    let focal = [24, 70, 135, 300]
    
    private func sliderValue() -> Float {
       return round(slider.value)
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
