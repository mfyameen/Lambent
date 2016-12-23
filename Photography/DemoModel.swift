import Foundation

public enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
}

struct DemoSettings {
    var apertureImage: String?
    var shutterImage: String?
    var isoImage: String?
    var focalImage: String?
    var cameraText: String?
    var newCameraText: String?
    let cameraSensorSize = 44
    var cameraOpeningSize = 38
    var currentSection: String?
}

public class DemoModel {
    private var apertureImage: String?
    private var shutterImage: String?
    private var isoImage: String?
    private var focalImage: String?

    private var currentSection: String?
    private var demo = DemoSettings()
    
    var shareInformation: (DemoSettings) -> () = { _ in }
    
    func currentSection(currentSection: String) {
        let section = currentSection
        print(section)
    }
    
    func letUsMove() {
       _ = configureAppropriateSectionWhenSliderValueChanged()
    }
    
    init() {
        
    }
    
    private init(apertureImage: String?, shutterImage: String?, isoImage: String?, focalImage: String?) {
        self.apertureImage = apertureImage
        self.shutterImage = shutterImage
        self.isoImage = isoImage
        self.focalImage = focalImage
    }
    
    func configureAppropriateSectionWhenInitialized(_ section: String) {
        currentSection = section
        guard let section = CameraSections(rawValue: section) else { return }
        print(section)
        switch section {
        case .Aperture:
            //configureSensor()
            demo.cameraText = "f/2.8"
            demo.apertureImage = "flower"
            shareInformation(demo)
        case .Shutter:
            demo.cameraText = "1/2"
            demo.shutterImage = "bird"
            shareInformation(demo)
        case .ISO:
            demo.cameraText = "100"
        case .Focal: break
        }
    }
    
    public func configureAppropriateSectionWhenSliderValueChanged() -> DemoModel {
        //switch round(slider.value) {
        switch 3 {
        case 3:
            configureSliderSettings(aperture: "f/2.8", shutter: "1/2", iso: "100", focal: nil, size: 38)
            return DemoModel(apertureImage: "flower", shutterImage: "flower", isoImage: nil, focalImage: nil)
        case 4:

            configureSliderSettings(aperture: "f/4", shutter: "1/4", iso: "200", focal: nil, size: 34)
            return DemoModel(apertureImage: "bird", shutterImage: "flower", isoImage: nil, focalImage: nil)
        case 6:
            configureSliderSettings(aperture: "f/5.6", shutter: "1/8", iso: "400", focal: nil, size: 24)
            return DemoModel(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil)
        case 8: configureSliderSettings(aperture: "f/8", shutter: "1/15", iso: "800", focal: nil, size: 20)
        case 11: configureSliderSettings(aperture: "f/11", shutter: "1/30", iso: "1600", focal: nil, size: 16)
        case 16: configureSliderSettings(aperture: "f/16", shutter: "1/60", iso: "3200", focal: nil, size: 12)
        case 22: configureSliderSettings(aperture: "f/22", shutter: "1/125", iso: "6400", focal: nil, size: 8)
        default: break
        }
        //CameraText().newCameraText = CameraText().cameraText
//        setNeedsLayout()
    }
    
    private func configureSliderSettings(aperture: String, shutter: String, iso: String?, focal: String?, size: Int){
        guard let section = CameraSections(rawValue: currentSection ?? "") else { return }
        switch section {
        case .Aperture:
            demo.cameraText = aperture
            demo.cameraOpeningSize = size
            //cameraSensorOpening.layer.cornerRadius = cameraOpeningSize/2
        case .Shutter:
            demo.cameraText = shutter
        case .ISO:
            demo.cameraText = iso
        case .Focal: break
        }
    }
    
}
