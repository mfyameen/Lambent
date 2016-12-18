import UIKit

enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
}

class DemoView: UIView {
    private let imageView = UIImageView(image: UIImage(named: "flower"))
    private let slider = UISlider()
    private let cameraValue = UILabel()
    private let cameraSensor = UIView()
    private let cameraSensorSize : CGFloat = 44
    private let cameraSensorOpening = UIView()
    private var cameraOpeningSize: CGFloat = 38
    private let demoInstructions = UILabel()
    var instruction: String {
        didSet {
            demoInstructions.text = instruction
        }
    }
    var currentSection: String? {
        didSet {
            configureAppropriateCameraSection(currentSection ?? "")
        }
    }
    
    init (DemoType: String?, content: String?) {
        self.instruction = content ?? ""
        super.init(frame: CGRect.zero)
        
        cameraValue.font = UIFont.systemFont(ofSize: 32)
        
        configureDemoInstructions()
        configureImage()
        configureSlider()
        addSubviews([imageView, cameraValue, cameraSensor, cameraSensorOpening, slider, demoInstructions])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAppropriateCameraSection(_ section: String) {
        guard let section = CameraSections(rawValue: section) else { return }
        switch section {
        case .Aperture:
            cameraValue.text = "f/2.8"
            
            cameraSensor.layer.cornerRadius = cameraSensorSize/2
            cameraSensor.backgroundColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.00)
            
            cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
            cameraSensorOpening.backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        case .Shutter:
            break
        case .ISO:
            break
        case .Focal:
            break
        }
    }
    
    
    private func configureDemoInstructions() {
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
    }
    
    private func configureImage() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func configureSlider() {
        slider.isContinuous = true
        slider.value = 2.8
        slider.minimumValue = 2.8
        slider.maximumValue = 22
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    @objc private func sliderValueChanged() {
        let currentSliderValue = round(slider.value)
        switch currentSliderValue {
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
        cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height * 0.6)
        
        let padding: CGFloat = 10
        
        cameraSensor.frame = CGRect(x: bounds.midX - cameraSensorSize - padding, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraSensorSize/2, width: cameraSensorSize, height: cameraSensorSize)
        
        cameraSensorOpening.frame = CGRect(x: cameraSensor.frame.midX - cameraOpeningSize/2, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraOpeningSize/2, width: cameraOpeningSize, height: cameraOpeningSize)
        
        let cameraValueSize = cameraValue.sizeThatFits(bounds.size)
        cameraValue.frame = CGRect(x: bounds.midX, y: (imageView.frame.maxY + slider.frame.minY)/2 - cameraValueSize.height/2, width: cameraValueSize.width, height: cameraValueSize.height)
        
        let sliderWidth = TutorialView.segmentedWidth
        let sliderHeight = slider.sizeThatFits(bounds.size).height
        slider.frame = CGRect(x: bounds.midX - sliderWidth/2, y: (imageView.frame.maxY + bounds.maxY)/2 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
        
        let demoInstructionHeight = demoInstructions.sizeThatFits(bounds.size).height
        demoInstructions.frame = CGRect(x: bounds.midX - sliderWidth/2, y: (slider.frame.maxY + bounds.maxY)/2 - demoInstructionHeight/2 , width: sliderWidth, height: demoInstructionHeight)
    }
}
