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
    var apertureText: String?
    var shutterText: String?
    var isoText: String?
    var focalText: String?
    var newCameraText: String?
    var cameraOpeningSize = 38
    var currentSection: String?
    //var demoInstructions: String?
}

class DemoModel {
    private var demo = DemoSettings()
    //private var tutorial = PhotographyModel()

    var shareInformation: (DemoSettings?) -> Void = { _ in }

    func letUsMove(sliderValue: Int) {
       _ = configureAppropriateSectionWhenSliderValueChanged(value: sliderValue)
    }
    
    func configureAppropriateSectionWhenInitialized(_ section: String) {
        guard let section = CameraSections(rawValue: section) else { return }
        switch section {
        case .Aperture:
            //configureSensor()
            demo.apertureText = "f/2.8"
            demo.apertureImage = "flower"
            shareInformation(demo)
        case .Shutter:
            demo.apertureText = "1/2"
            demo.shutterImage = "bird"
            shareInformation(demo)
        case .ISO:
            demo.apertureText = "100"
        case .Focal: break
        }
    }
    
    func configureAppropriateSectionWhenSliderValueChanged(value: Int) {
        switch value {
        case 3:
            demo = DemoSettings(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil, apertureText: "f/2.8", shutterText: "1/2", isoText: "100", focalText: nil, newCameraText: nil, cameraOpeningSize: 38, currentSection: nil)
        case 4:
            demo = DemoSettings(apertureImage: "bird", shutterImage: "bird", isoImage: nil, focalImage: nil, apertureText: "f/4", shutterText: "1/4", isoText: "200", focalText: nil, newCameraText: nil, cameraOpeningSize: 34, currentSection: nil)
        case 6:
            demo = DemoSettings(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil, apertureText: "f/5.6", shutterText: "1/8", isoText: "400", focalText: nil, newCameraText: nil, cameraOpeningSize: 24, currentSection: nil)
        case 8:
            demo = DemoSettings(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil, apertureText: "f/8", shutterText: "1/15", isoText: "800", focalText: nil, newCameraText: nil, cameraOpeningSize: 20, currentSection: nil)
        case 11:
            demo = DemoSettings(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil, apertureText: "f/11", shutterText: "1/30", isoText: "1600", focalText: nil, newCameraText: nil, cameraOpeningSize: 16, currentSection: nil)
        case 16:
            demo = DemoSettings(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil, apertureText: "f/16", shutterText: "1/60", isoText: "3200", focalText: nil, newCameraText: nil, cameraOpeningSize: 12, currentSection: nil)
        case 22:
            demo = DemoSettings(apertureImage: "flower", shutterImage: "bird", isoImage: nil, focalImage: nil, apertureText: "f/22", shutterText: "1/125", isoText: "6400", focalText: nil, newCameraText: nil, cameraOpeningSize: 8, currentSection: nil)
        default: break
        }
        shareInformation(demo)
    }
}
