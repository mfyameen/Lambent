import Foundation

enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
    case Modes = "Modes"
}

struct DemoSettings {
    var apertureImage: String = "flower"
    var apertureText: String = "f/2.8"
    var cameraOpeningSize: Int? = 38
    var cameraSensorSize: Int? = 44
    var shutterImage: String = "waterfall2.8"
    var shutterIcon: String = "shutter1.2"
    var shutterText: String = "1/2"
    var isoImage: String? = "flower"
    var isoIcon: String = "iso100"
    var isoText: String = "100"
    var focalImage: String?
    var focalText: String?
}

public struct CameraSectionDemoSettings {
    public var image: String?
    public var text: String?
    public var cameraOpeningSize: Int?
    public var cameraSensorSize: Int?
    public var icon: String?
    public var instructions: String?
}

public class DemoModel {
    private var demoSettings = DemoSettings()
    private var sectionSettings = CameraSectionDemoSettings()
    private let tutorial = PhotographyModel()
    
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
            return CameraSectionDemoSettings(image: demoSettings.apertureImage, text: demoSettings.apertureText, cameraOpeningSize: demoSettings.cameraOpeningSize, cameraSensorSize: demoSettings.cameraSensorSize, icon: nil, instructions: "Play with the slider to see how aperture affects the above photo")
        case .Shutter:
            return CameraSectionDemoSettings(image: demoSettings.shutterImage, text: demoSettings.shutterText, cameraOpeningSize: nil, cameraSensorSize: nil, icon: demoSettings.shutterIcon, instructions: "Play with the slider to see how shutter speed affects the above photo")
        case .ISO:
            return CameraSectionDemoSettings(image: demoSettings.isoImage, text: demoSettings.isoText, cameraOpeningSize: nil, cameraSensorSize: nil, icon: demoSettings.isoIcon, instructions: "Play with the slider to see how the ISO affects the above photo")
        case .Focal:
            return CameraSectionDemoSettings(image: demoSettings.focalImage, text: demoSettings.focalText, cameraOpeningSize: nil, cameraSensorSize: nil, icon: nil, instructions: "Play with the slider to see how focal length affects the above photo")
        case .Modes:
            return CameraSectionDemoSettings(image: demoSettings.focalImage, text: demoSettings.focalText, cameraOpeningSize: nil, cameraSensorSize: nil, icon: nil, instructions: "Play with the slider to see how focal length affects the above photo")
        }
    }
    
    private func configureSectionsWhenSliderValueChanged(_ value: Int) -> DemoSettings {
        switch value {
        case 3:
            return DemoSettings(apertureImage: "flower", apertureText: "f/2.8", cameraOpeningSize: 38, cameraSensorSize: 44, shutterImage: "waterfall2.8", shutterIcon: "shutter1.2", shutterText: "1/2", isoImage: "flower", isoIcon: "iso100", isoText: "100",focalImage: nil, focalText: nil)
        case 4:
            return DemoSettings(apertureImage: "flower", apertureText: "f/4", cameraOpeningSize: 34, cameraSensorSize: 44, shutterImage: "waterfall4", shutterIcon: "shutter1.4", shutterText: "1/4", isoImage: "flower", isoIcon: "iso200", isoText: "200", focalImage: nil, focalText: nil)
        case 6:
            return DemoSettings(apertureImage: "flower", apertureText: "f/5.6", cameraOpeningSize: 24, cameraSensorSize: 44, shutterImage: "waterfall6", shutterIcon: "shutter1.8", shutterText: "1/8", isoImage: nil, isoIcon: "iso400", isoText: "400", focalImage: nil, focalText: nil)
        case 8:
            return DemoSettings(apertureImage: "flower", apertureText: "f/8", cameraOpeningSize: 20, cameraSensorSize: 44, shutterImage: "waterfall8", shutterIcon: "shutter1.15", shutterText: "1/15", isoImage: nil, isoIcon: "iso800", isoText: "800", focalImage: nil, focalText: nil)
        case 11:
            return DemoSettings(apertureImage: "flower", apertureText: "f/11", cameraOpeningSize: 16, cameraSensorSize: 44, shutterImage: "waterfall11", shutterIcon: "shutter1.30", shutterText: "1/30", isoImage: nil, isoIcon: "iso1600", isoText: "1600", focalImage: nil, focalText: nil)
        case 16:
            return DemoSettings(apertureImage: "flower", apertureText: "f/16", cameraOpeningSize: 12, cameraSensorSize: 44, shutterImage: "waterfall16", shutterIcon: "shutter1.60", shutterText: "1/60", isoImage: nil, isoIcon: "iso3200", isoText: "3200", focalImage: nil, focalText: nil)
        case 22:
            return DemoSettings(apertureImage: "flower", apertureText: "f/22", cameraOpeningSize: 8, cameraSensorSize: 44, shutterImage: "waterfall22", shutterIcon: "shutter1.125", shutterText: "1/125", isoImage: nil, isoIcon: "iso6400", isoText: "6400", focalImage: nil, focalText: nil)
        default:
            return demoSettings
        }
    }
}
