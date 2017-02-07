import UIKit

public class DemoView: UIView {
    private let image = UIImageView()
    private let icon = UIImageView()
    private let slider = UISlider()
    private let cameraValue = UILabel()
    private let cameraSensor = UIView()
    private let cameraSensorOpening = UIView()
    private var cameraSensorSize: CGFloat = 44
    private var cameraOpeningSize: CGFloat = 38
    private let demoInstructions = UILabel()
    private var apertureImage: String?
    private var imageString = ""
    var sliderFrame = CGRect()
    
    var movedSlider: (Int?) ->() = { _ in }
    static var images = [Images]()
    static var cache = NSCache<NSString, UIImage>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cameraValue.font = UIFont.systemFont(ofSize: 32)
        layoutSlider()
        layoutDemoInstructions()
        addSubviews([image, cameraValue, icon, cameraSensor, cameraSensorOpening, slider, demoInstructions])
    }
    
    public func addInformation(demoInformation: CameraSectionDemoSettings) {
        layoutImage(imageView: image, imageName: demoInformation.image ?? "")
        layoutImage(imageView: icon, imageName: demoInformation.icon ?? "")
        cameraOpeningSize = CGFloat(demoInformation.cameraOpeningSize ?? 0)
        cameraSensorSize = CGFloat(demoInformation.cameraSensorSize ?? 0)
        layoutSensor(cameraSensorSize: cameraSensorSize, cameraOpeningSize: cameraOpeningSize)
        cameraValue.text = demoInformation.text
        demoInstructions.text = demoInformation.instructions
        layoutDemoInstructions()
        setNeedsLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutImage(imageView: UIImageView, imageName: String) {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
      //  imageView.image = UIImage(named: imageName)
        
        DemoView.images.forEach({ image in
            if image.title == imageName && image.title != imageString {
                let cachedImage = DemoView.cache.object(forKey: image.title as NSString)
                imageView.image = cachedImage
                imageString = image.title
            }
        })
    }

    private func layoutSlider() {
        slider.isContinuous = true
        slider.minimumValue = 2
        slider.maximumValue = 22
        slider.addTarget(self, action: #selector(configureAppropriateSectionWhenSliderValueChanged), for: .valueChanged)
    }
    
    @objc private func configureAppropriateSectionWhenSliderValueChanged() {
        movedSlider(Int(slider.value))
        setNeedsLayout()
    }
    
    private func layoutDemoInstructions() {
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
    }
    
    private func layoutSensor(cameraSensorSize: CGFloat, cameraOpeningSize: CGFloat) {
        cameraSensor.layer.cornerRadius = cameraSensorSize/2
        cameraSensor.backgroundColor = UIColor.sensorColor()
        cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        cameraSensorOpening.backgroundColor = UIColor.backgroundColor()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let cameraPadding: CGFloat = 10
        let imagePadding: CGFloat = 20
        
        image.frame = CGRect(x: bounds.minX, y: bounds.minY + imagePadding, width: bounds.width, height: bounds.height * 0.5)

        cameraSensor.frame = CGRect(x: bounds.midX - cameraSensorSize - cameraPadding, y: (image.frame.maxY + slider.frame.minY)/2 - cameraSensorSize/2, width: cameraSensorSize, height: cameraSensorSize)
        
        let cameraSensorTop = (image.frame.maxY + slider.frame.minY)/2 - cameraOpeningSize/2
        cameraSensorOpening.frame = CGRect(x: cameraSensor.frame.midX - cameraOpeningSize/2, y: cameraSensorTop, width: cameraOpeningSize, height: cameraOpeningSize)
        
        let iconSize: CGFloat = 44
        let iconTop = (image.frame.maxY + slider.frame.minY)/2 - iconSize/2
        icon.frame = CGRect(x: bounds.midX - iconSize - cameraPadding, y: iconTop, width: iconSize, height: iconSize)
        
        let cameraValueSize = cameraValue.sizeThatFits(bounds.size)
        let cameraValueTop = (image.frame.maxY + slider.frame.minY)/2 - cameraValueSize.height/2
        cameraValue.frame = CGRect(x: bounds.midX, y: cameraValueTop, width: ceil(cameraValueSize.width), height: ceil(cameraValueSize.height))
        
        let sliderWidth = TutorialView.segmentedWidth
        let sliderHeight = slider.sizeThatFits(bounds.size).height
        let sliderTop = (image.frame.maxY + bounds.maxY)/2 - sliderHeight/2
        slider.frame = CGRect(x: bounds.midX - sliderWidth/2, y: sliderTop, width: sliderWidth, height: sliderHeight)
        let sliderFrameTop = sliderTop + imagePadding + TutorialView.segmentedHeight
        sliderFrame = CGRect(x: slider.frame.minX, y: sliderFrameTop, width: slider.frame.width, height: slider.frame.height)
        
        let demoInstructionHeight = demoInstructions.sizeThatFits(bounds.size).height
        let demoInstructionsTop = (slider.frame.maxY + bounds.maxY)/2 - demoInstructionHeight/2
        demoInstructions.frame = CGRect(x: bounds.midX - sliderWidth/2, y: demoInstructionsTop, width: ceil(sliderWidth), height: ceil(demoInstructionHeight))
    }
}
