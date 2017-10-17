import UIKit
import AVFoundation
import RxSwift
import RxSugar

class CameraOverlayModes: UIView {
    private let apertureSlider: SectionSlider
    private let shutterSlider: SectionSlider
    private let isoSlider: SectionSlider
    private let device: AVCaptureDevice
    private let setUp: TutorialSetUp
    
    let resetModeSectionSliders: AnyObserver<Segment>
    private let _resetModeSectionSliders = PublishSubject<Segment>()
    
    init?(setUp: TutorialSetUp) {
        if #available(iOS 10.0, *) {
            guard let device = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: nil, position: .unspecified).devices.first else { return nil }
            self.device = device
        } else {
            guard let device = AVCaptureDevice.devices().first else { return nil }
            self.device = device
        }
        apertureSlider = SectionSlider(page: .aperture, device: device)
        shutterSlider = SectionSlider(page: .shutter, device: device)
        isoSlider = SectionSlider(page: .iso, device: device)
        resetModeSectionSliders = _resetModeSectionSliders.asObserver()
        self.setUp = setUp
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.backgroundColor()
        alpha = 0.7
        addSubview(apertureSlider)
        addSubview(shutterSlider)
        addSubview(isoSlider)
        maybeDisableSliderSections(setUp: setUp)
        
        rxs.disposeBag
            ++ { [weak self] in self?.resetSliders(forSegment: $0) } <~ _resetModeSectionSliders.asObservable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetSliders(forSegment segment: Segment) {
        [apertureSlider, shutterSlider, isoSlider].forEach { $0.slider.value = 0 }
        maybeDisableSliderSections(setUp: TutorialSetUp(currentPage: setUp.currentPage, currentSegment: segment))
    }
    
    private func maybeDisableSliderSections(setUp: TutorialSetUp) {
        let inactiveColor = UIColor.lightGray
        let activeColor = UIColor.navigationTextColor()
        switch (setUp.currentPage, setUp.currentSegment) {
        case (.modes, .intro):
            shutterSlider.isUserInteractionEnabled = false
            shutterSlider.sliderColor(inactiveColor)
            [apertureSlider, isoSlider].forEach { $0.isUserInteractionEnabled = true; $0.sliderColor(activeColor) }
        case (.modes, .demo):
            apertureSlider.isUserInteractionEnabled = false
            apertureSlider.sliderColor(inactiveColor)
            [isoSlider, shutterSlider].forEach { $0.isUserInteractionEnabled = true; $0.sliderColor(activeColor) }
        default:
            [apertureSlider, isoSlider, shutterSlider].forEach { $0.isUserInteractionEnabled = true; $0.sliderColor(activeColor) }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let apertureSliderSize = apertureSlider.sizeThatFits(bounds.size)
        let shutterSliderSize = shutterSlider.sizeThatFits(bounds.size)
        let isoSliderSize = isoSlider.sizeThatFits(bounds.size)
        let topY = bounds.midY - (apertureSliderSize.height + Padding.small + shutterSliderSize.height + Padding.small + isoSliderSize.height)/2
        apertureSlider.frame = CGRect(x: bounds.midX - apertureSliderSize.width/2, y: topY, width: apertureSliderSize.width, height: apertureSliderSize.height)
        shutterSlider.frame = CGRect(x: bounds.midX - shutterSliderSize.width/2, y: apertureSlider.frame.maxY + Padding.small, width: shutterSliderSize.width, height: shutterSliderSize.height)
        isoSlider.frame = CGRect(x: bounds.midX - isoSliderSize.width/2, y: shutterSlider.frame.maxY + Padding.small, width: isoSliderSize.width, height: isoSliderSize.height)
    }
}

class CameraOverlay: UIView {
    private let sectionSlider: SectionSlider
    private let device: AVCaptureDevice
    private var section: Page
    
    init?(page: Page) {
        if #available(iOS 10.0, *) {
            guard let device = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: nil, position: .unspecified).devices.first else { return nil }
            self.device = device
        } else {
            guard let device = AVCaptureDevice.devices().first else { return nil }
            self.device = device
        }
        self.section = page
        sectionSlider = SectionSlider(page: page, device: device)
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.backgroundColor()
        alpha = 0.7
        addSubview(sectionSlider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sectionSliderSize = sectionSlider.sizeThatFits(bounds.size)
        sectionSlider.frame = CGRect(x: bounds.midX - sectionSliderSize.width/2, y: bounds.midY - sectionSliderSize.height/2, width: sectionSliderSize.width, height: sectionSliderSize.height)
    }
}
