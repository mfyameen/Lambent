import UIKit
import RxSugar
import RxSwift

public class DemoView: UIView {
    private let currentPage: Page
    private var trackedSliderInteraction = false
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
    
    let currentSliderValue: Observable<Int>
    private let _currentSliderValue = PublishSubject<Int>()
    
    static var images = [Images]()
    static var cache = NSCache<NSString, UIImage>()
    
    init(page: Page) {
        currentPage = page
        currentSliderValue = _currentSliderValue.asObservable()
        super.init(frame: CGRect.zero)
        cameraValue.font = UIFont.systemFont(ofSize: 32)
        layoutSlider()
        layoutDemoInstructions()
        addSubviews([image, cameraValue, icon, cameraSensor, cameraSensorOpening, slider, demoInstructions])
    }
    
    func addInformation(demoInformation: CameraSectionDemoSettings) {
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
        DemoView.images.filter { $0.title == imageName && $0.title != imageString}.forEach { image in
            let cachedImage = DemoView.cache.object(forKey: image.title as NSString)
            imageView.image = cachedImage
            imageString = image.title
            imageView.accessibilityLabel = imageName
        }
    }

    private func layoutSlider() {
        slider.isContinuous = true
        slider.minimumValue = 2
        slider.maximumValue = 22
        slider.addTarget(self, action: #selector(configureAppropriateSectionWhenSliderValueChanged), for: .valueChanged)
    }
    
    @objc private func configureAppropriateSectionWhenSliderValueChanged() {
        _currentSliderValue.onNext(Int(slider.value))
        setNeedsLayout()
        trackSlider()
    }
    
    private func trackSlider() {
        guard let tracker = GAI.sharedInstance().defaultTracker, trackedSliderInteraction == false else { return }
        let eventTracker = GAIDictionaryBuilder.createEvent(
            withCategory: "Interaction with Demo Slider",
            action: "Interacted with \(currentPage) Slider",
            label: "",
            value: 1).build()
        tracker.send(eventTracker as? [AnyHashable : Any])
        trackedSliderInteraction = true
    }
    
    private func layoutDemoInstructions() {
        demoInstructions.font = UIFont.systemFont(ofSize: 12)
        demoInstructions.numberOfLines = 0
        demoInstructions.textAlignment = .center
    }
    
    private func layoutSensor(cameraSensorSize: CGFloat, cameraOpeningSize: CGFloat) {
        cameraSensor.layer.cornerRadius = cameraSensorSize/2
        cameraSensor.backgroundColor = UIColor.sensorInnerColor()
        cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        cameraSensorOpening.backgroundColor = UIColor.sensorOuterColor()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 20
        let cameraPadding: CGFloat = 10
        image.frame = CGRect(x: bounds.minX, y: bounds.minY + imagePadding, width: bounds.width, height: bounds.height * 0.5)
        let sliderWidth = ContentView.segmentedWidth
        let sliderHeight = slider.sizeThatFits(bounds.size).height
        let sliderTop = (image.frame.maxY + bounds.maxY)/2 - sliderHeight/2
        slider.frame = CGRect(x: bounds.midX - sliderWidth/2, y: sliderTop, width: sliderWidth, height: sliderHeight)
        let sliderFrameTop = sliderTop + imagePadding + ContentView.segmentedHeight
        let sliderPadding: CGFloat = 10
        sliderFrame = CGRect(x: slider.frame.minX, y: sliderFrameTop - sliderPadding, width: slider.frame.width, height: 2 * slider.frame.height)
        cameraSensor.frame = CGRect(x: bounds.midX - cameraSensorSize - cameraPadding, y: (image.frame.maxY + slider.frame.minY)/2 - cameraSensorSize/2, width: cameraSensorSize, height: cameraSensorSize)
        let cameraSensorTop = (image.frame.maxY + slider.frame.minY)/2 - cameraOpeningSize/2
        cameraSensorOpening.frame = CGRect(x: cameraSensor.frame.midX - cameraOpeningSize/2, y: cameraSensorTop, width: cameraOpeningSize, height: cameraOpeningSize)
        let iconSize: CGFloat = 44
        let iconTop = (image.frame.maxY + slider.frame.minY)/2 - iconSize/2
        icon.frame = CGRect(x: bounds.midX - iconSize - cameraPadding, y: iconTop, width: iconSize, height: iconSize)
        let cameraValueSize = cameraValue.sizeThatFits(bounds.size)
        let cameraValueTop = (image.frame.maxY + slider.frame.minY)/2 - cameraValueSize.height/2
        cameraValue.frame = CGRect(x: bounds.midX, y: cameraValueTop, width: ceil(cameraValueSize.width), height: ceil(cameraValueSize.height))
        let demoInstructionHeight = demoInstructions.sizeThatFits(bounds.size).height
        demoInstructions.frame = CGRect(x: bounds.midX - sliderWidth/2, y: slider.frame.maxY + 8, width: ceil(sliderWidth), height: ceil(demoInstructionHeight))
    }
}
