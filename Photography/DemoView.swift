import UIKit

public class DemoView: UIView {
    private let imageView = UIImageView()
    private let slider = UISlider()
    private let cameraValue = UILabel()
    private let cameraSensor = UIView()
    private let cameraSensorSize : CGFloat = 44
    private let cameraSensorOpening = UIView()
    private var cameraOpeningSize: CGFloat = 38
    private let demoInstructions = UILabel()
    private var apertureImage: String?
    private var demoInformation: DemoSettings?

   static var movedSlider: (Int) ->() = { _ in }
    
    var instruction: String? {
        didSet {
            demoInstructions.text = instruction
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        addStuff(demoStuff: demoInformation)
        cameraValue.text = "0"
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cameraValue.font = UIFont.systemFont(ofSize: 32)
        configureSlider()
        configureDemoInstructions()
        addSubviews([imageView, cameraValue, cameraSensor, cameraSensorOpening, slider, demoInstructions])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDemoInstructions() {
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
    }
    
    private func configureSlider() {
        slider.isContinuous = true
        slider.minimumValue = 2
        slider.maximumValue = 22
        slider.addTarget(self, action: #selector(configureAppropriateSectionWhenSliderValueChanged), for: .valueChanged)
    }
    
    @objc private func configureAppropriateSectionWhenSliderValueChanged() {
        DemoView.movedSlider(Int(slider.value))
    }
    
    private func configureSensor() {
        //cameraSensor.layer.cornerRadius = demoInformation.cameraSensorSize/2
        cameraSensor.backgroundColor = UIColor.sensorColor()
        //cameraSensorOpening.layer.cornerRadius = demoInformation.cameraOpeningSize/2
        cameraSensorOpening.backgroundColor = UIColor.backgroundColor()
    }
    
//    private func configureImage(image: String) {
////        let apertureImage = demoInformation?.apertureImage ?? "nothing"
////        let shutterImage = demoInformation?.shutterImage ?? ""
////        let isoImage = demoInformation?.isoImage ?? ""
////        let focalImage = demoInformation?.focalImage ?? ""
//       // print(apertureImage)
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image =  UIImage(named: image ?? "bird")
//    }
    
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
    
    func addStuff(demoStuff: DemoSettings?){
        demoInformation = demoStuff
        let content = demoStuff?.apertureText
      
        imageView.image =  UIImage(named: demoStuff?.apertureImage ?? "bird")
       

      cameraValue.text = content ?? "aslfkjd"
        setNeedsLayout()
        setNeedsDisplay()
        print(content)
        print(demoStuff?.apertureImage ?? "")
        print(demoStuff?.shutterImage)
        print(demoStuff?.apertureText)
        
    }
    
}
