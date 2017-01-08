import Foundation

enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
}

struct DemoSettings {
    var apertureImage: String = "flower"
    var apertureText: String = "f/2.8"
    var shutterImage: String = "waterfall2.8"
    var shutterText: String = "1/2"
    var isoImage: String?
    var isoText: String = "100"
    var focalImage: String?
    var focalText: String?
    var cameraOpeningSize: Int? = 38
    var cameraSensorSize: Int? = 44
}

public struct CameraSectionDemoSettings {
    public var image: String?
    public var text: String?
    public var cameraOpeningSize: Int?
    public var cameraSensorSize: Int?
    public var instructions: String?
}

public class DemoModel {
    private var demoSettings = DemoSettings()
    private var sectionSettings = CameraSectionDemoSettings()
    private var tutorial = PhotographyModel()

    private var currentPage: Int
    
    public var shareInformation: (CameraSectionDemoSettings) -> () = { _ in }
    
    public init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage.rawValue
    }
    
    public func configureDemo(sliderValue: Int?) {
        guard let sliderValue = sliderValue else { return }
        demoSettings = configureSectionsWhenSliderValueChanged(sliderValue)
        sectionSettings = configureCurrentSection(tutorial.sections[currentPage])
        shareInformation(sectionSettings)
    }
    
    private func configureCurrentSection(_ section: String?) -> CameraSectionDemoSettings {
        guard let currentSection = CameraSections(rawValue: section ?? "") else { return sectionSettings }
        switch currentSection {
        case .Aperture:
            return CameraSectionDemoSettings(image: demoSettings.apertureImage, text: demoSettings.apertureText, cameraOpeningSize: demoSettings.cameraOpeningSize, cameraSensorSize: demoSettings.cameraSensorSize, instructions: "Play with the slider to see how aperture affects the above photo")
        case .Shutter:
            return CameraSectionDemoSettings(image: demoSettings.shutterImage, text: demoSettings.shutterText, cameraOpeningSize: nil, cameraSensorSize: nil, instructions: "Play with the slider to see how shutter speed affects the above photo")
        case .ISO:
            return CameraSectionDemoSettings(image: demoSettings.isoImage, text: demoSettings.isoText, cameraOpeningSize: nil, cameraSensorSize: nil, instructions: "Play with the slider to see how ISO affects the above photo")
        case .Focal:
            return CameraSectionDemoSettings(image: demoSettings.focalImage, text: demoSettings.focalText, cameraOpeningSize: nil, cameraSensorSize: nil, instructions: "Play with the slider to see how focal length affects the above photo")
        }
    }
    
    private func configureSectionsWhenSliderValueChanged(_ value: Int) -> DemoSettings {
        switch value {
        case 3:
            return DemoSettings(apertureImage: "flower", apertureText: "f/2.8", shutterImage: "waterfall2.8", shutterText: "1/2", isoImage: nil, isoText: "100",focalImage: nil, focalText: nil, cameraOpeningSize: 38, cameraSensorSize: 44)
        case 4:
            return DemoSettings(apertureImage: "flower", apertureText: "f/4", shutterImage: "waterfall4", shutterText: "1/4", isoImage: nil, isoText: "200", focalImage: nil, focalText: nil, cameraOpeningSize: 34, cameraSensorSize: 44)
        case 6:
            return DemoSettings(apertureImage: "flower", apertureText: "f/5.6", shutterImage: "waterfall6", shutterText: "1/8", isoImage: nil, isoText: "400", focalImage: nil, focalText: nil, cameraOpeningSize: 24, cameraSensorSize: 44)
        case 8:
            return DemoSettings(apertureImage: "flower", apertureText: "f/8", shutterImage: "waterfall8", shutterText: "1/15", isoImage: nil, isoText: "800", focalImage: nil, focalText: nil, cameraOpeningSize: 20, cameraSensorSize: 44)
        case 11:
            return DemoSettings(apertureImage: "flower", apertureText: "f/11", shutterImage: "waterfall11", shutterText: "1/30", isoImage: nil, isoText: "1600", focalImage: nil, focalText: nil, cameraOpeningSize: 16, cameraSensorSize: 44)
        case 16:
            return DemoSettings(apertureImage: "flower", apertureText: "f/16", shutterImage: "waterfall16", shutterText: "1/60", isoImage: nil, isoText: "3200", focalImage: nil, focalText: nil, cameraOpeningSize: 12, cameraSensorSize: 44)
        case 22:
            return DemoSettings(apertureImage: "flower", apertureText: "f/22", shutterImage: "waterfall22", shutterText: "1/125", isoImage: nil, isoText: "6400", focalImage: nil, focalText: nil, cameraOpeningSize: 8, cameraSensorSize: 44)
        default:
            return demoSettings
        }
    }
}
