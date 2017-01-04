import Foundation

public enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
}

public struct DemoSettings {
    public var image: String?
    public var text: String?
    public var cameraOpeningSize: Int? = 38
    public var cameraSensorSize: Int? = 44
    public var instructions: String?
}

public class DemoModel {
    private var demo = DemoSettings()
    private var tutorial = PhotographyModel()
    private var apertureImage: String = "flower"
    private var apertureText: String = "f/2.8"
    private var shutterImage: String = "waterfall2.8"
    private var shutterText: String = "1/2"
    private var isoImage: String?
    private var isoText: String = "100"
    private var focalImage: String?
    private var focalText: String?
    private var currentPage: Int
    private var currentSection: String
    
    var shareInformation: (DemoSettings?) -> Void = { _ in }
    
    public init (setUp: TutorialSetUp?) {
        currentPage = setUp?.currentPage ?? 0
        currentSection = tutorial.sections[currentPage]
    }
    
    func configureDemo(sliderValue: Int) {
       _ = configureSectionsWhenSliderValueChanged(sliderValue)
        demo = configureCurrentSection(currentSection)
        shareInformation(demo)
    }
    
    func configureAppropriateSectionWhenInitialized() {
       demo = configureCurrentSection(currentSection)
       shareInformation(demo)
    }
    
    public func configureCurrentSection(_ section: String?) -> DemoSettings {
        guard let currentSection = CameraSections(rawValue: section ?? "") else { return demo }
        switch currentSection {
        case .Aperture:
            return DemoSettings(image: apertureImage, text: apertureText, cameraOpeningSize: demo.cameraOpeningSize, cameraSensorSize: demo.cameraSensorSize, instructions: "Play with the slider to see how aperture affects the above photo")
        case .Shutter:
            return DemoSettings(image: shutterImage, text: shutterText, cameraOpeningSize: nil, cameraSensorSize: nil, instructions: "Play with the slider to see how shutter speed affects the above photo")
        case .ISO:
            return DemoSettings(image: isoImage, text: isoText, cameraOpeningSize: nil, cameraSensorSize: nil, instructions: "Play with the slider to see how ISO affects the above photo")
        case .Focal:
            return DemoSettings(image: focalImage, text: focalText, cameraOpeningSize: nil, cameraSensorSize: nil, instructions: "Play with the slider to see how focal length affects the above photo")
        }
    }
    
    func configureSectionsWhenSliderValueChanged(_ value: Int) {
        switch value {
        case 3:
            apertureImage = "flower"; shutterImage = "waterfall2.8"; isoImage = nil; focalImage = nil
            apertureText = "f/2.8"; shutterText = "1/2"; isoText = "100"; focalText = nil
            demo.cameraOpeningSize = 38
        case 4:
            apertureImage = "flower"; shutterImage = "waterfall4"; isoImage = nil; focalImage = nil
            apertureText = "f/4"; shutterText = "1/4"; isoText = "200"; focalText = nil
            demo.cameraOpeningSize = 34
        case 6:
            apertureImage = "flower"; shutterImage = "waterfall6"; isoImage = nil; focalImage = nil
            apertureText = "f/5.6"; shutterText = "1/8"; isoText = "400"; focalText = nil
            demo.cameraOpeningSize = 24
        case 8:
            apertureImage = "flower"; shutterImage = "waterfall8"; isoImage = nil; focalImage = nil
            apertureText = "f/8"; shutterText = "1/15"; isoText = "800"; focalText = nil
            demo.cameraOpeningSize = 20
        case 11:
            apertureImage = "flower"; shutterImage = "waterfall11"; isoImage = nil; focalImage = nil
            apertureText = "f/11"; shutterText = "1/30"; isoText = "1600"; focalText = nil
            demo.cameraOpeningSize = 16
        case 16:
           apertureImage = "flower"; shutterImage = "waterfall16"; isoImage = nil; focalImage = nil
           apertureText = "f/16"; shutterText = "1/60"; isoText = "3200"; focalText = nil
           demo.cameraOpeningSize = 12
        case 22:
            apertureImage = "flower"; shutterImage = "waterfall22"; isoImage = nil; focalImage = nil
            apertureText = "f/22"; shutterText = "1/125"; isoText = "6400"; focalText = nil
            demo.cameraOpeningSize = 8
        default: break
        }
    }
}
