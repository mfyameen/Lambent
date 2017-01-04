import Foundation

public enum CameraSections: String {
    case Aperture = "Aperture"
    case Shutter = "Shutter Speed"
    case ISO = "ISO"
    case Focal = "Focal Length"
}

struct DemoSettings {
    var image: String?
    var text: String?
    var cameraOpeningSize: Int? = 38
    var cameraSensorSize: Int? = 44
    var instructions: String?
}

class DemoModel {
    private var demo = DemoSettings()
    private var tutorial = PhotographyModel()
    private var apertureImage: String?
    private var apertureText: String?
    private var shutterImage: String?
    private var shutterText: String?
    private var isoImage: String?
    private var isoText: String?
    private var focalImage: String?
    private var focalText: String?
    private var currentPage: Int
    private var currentSection: String
    
    var shareInformation: (DemoSettings?) -> Void = { _ in }

    init (setUp: TutorialSetUp) {
        currentPage = setUp.currentPage
        currentSection = tutorial.sections[currentPage]
    }
    
    func letUsMove(sliderValue: Int) {
       _ = configureSectionsWhenSliderValueChanged(value: sliderValue)
        configureCurrentSection()
        shareInformation(demo)
    }
    
    func configureAppropriateSectionWhenInitialized() {
        guard let section = CameraSections(rawValue: currentSection) else { return }
        switch section {
        case .Aperture:
            //configureSensor()
            demo.text = "f/2.8"
            demo.image = "flower"
            //demo.instructions = "Play with the slider to see how aperture affects the above photo"
            shareInformation(demo)
        case .Shutter:
            demo.text = "1/2"
            demo.image = "waterfall2.8"
            shareInformation(demo)
        case .ISO:
            demo.text = "100"
        case .Focal: break
        }
    }
    
    func configureSectionsWhenSliderValueChanged(value: Int) {
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
    
    func configureCurrentSection() {
        guard let currentSection = CameraSections(rawValue: currentSection) else { return }
        switch currentSection {
        case .Aperture:
            demo.image = apertureImage
            demo.text = apertureText
            demo.instructions = "Play with the slider to see how aperture affects the above photo"
        case .Shutter: demo.image = shutterImage
            demo.image = shutterImage
            demo.text = shutterText
            demo.instructions = "Play with the slider to see how shutter speed affects the above photo"
        case .ISO: demo.image = isoImage
            demo.image = isoImage
            demo.text = isoText
            demo.instructions = "Play with the slider to see how ISO affects the above photo"
        case .Focal: demo.image = focalImage
            demo.image = focalImage
            demo.text = focalText
            demo.instructions = "Play with the slider to see how focal length affects the above photo"
        }
    }
}
