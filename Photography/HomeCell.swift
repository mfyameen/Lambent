import UIKit

class HomeCell: UITableViewCell {
    static let reuseIdentifier = "Cell"
    private let title = UILabel()
    private let phrase = UILabel()
    private let startButton = UIButton()
    private let leftButton = UIButton()
    private let middleButton = UIButton()
    private let rightButton = UIButton()
    private let horizontalSeparator = UIView()
    private let leftVerticalSeparator = UIView()
    private let rightVerticalSeparator = UIView()
    private let buttonHeight: CGFloat = 44
    private let insets: CGFloat = 15
    private let padding: CGFloat = 50
    private let buttonWidth: CGFloat
    
    var pressButton: (Segment?)->() = { _ in }
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?) {
        buttonWidth = (UIScreen.main.bounds.width - (insets * 2)) * 0.33
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        contentView.addSubviews([title, phrase, horizontalSeparator, leftVerticalSeparator, rightVerticalSeparator, startButton, leftButton, middleButton, rightButton])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        title.font = UIFont.boldSystemFont(ofSize: 16)
        phrase.font = UIFont.systemFont(ofSize: 14)
        phrase.numberOfLines = 0
        
        layer.cornerRadius = 8
        selectionStyle = .none
        HelperMethods.configureShadow(element: self)
        
        layoutSeparators([horizontalSeparator, leftVerticalSeparator, rightVerticalSeparator])
        layoutButtons([startButton, leftButton, middleButton, rightButton])
        
        leftButton.setTitle("Intro", for: .normal)
        startButton.setTitle("", for: .normal)
        middleButton.setTitle("Demo", for: .normal)
        rightButton.setTitle("Practice", for: .normal)
    }
    
    private func layoutSeparators(_ separators: [UIView]) {
        separators.forEach ({
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.backgroundColor().cgColor
        })
    }
    
    private func layoutButtons(_ buttons: [UIButton]) {
        buttons.forEach({
            $0.setTitleColor(UIColor.buttonColor(), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        })
    }
    
    func configure(_ content: CellContent, for cell: Page) {
        title.text = content.title
        phrase.text = content.phrase
        
        switch cell {
        case .overview: configureIntroductionCell()
        case .modes: configureModeCell(); fallthrough
        default:
            startButton.isEnabled = false
            middleButton.isEnabled = true
            leftButton.addTarget(self, action: #selector(pressIntroButton), for: .touchUpInside)
            middleButton.addTarget(self, action: #selector(pressDemoButton), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(pressPracticeButton), for: .touchUpInside)
        }
    }
    
    private func configureIntroductionCell() {
        middleButton.isEnabled = false
        startButton.isEnabled = true
        startButton.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
        
        layoutSeparators([horizontalSeparator])
        leftVerticalSeparator.layer.borderWidth = 0
        rightVerticalSeparator.layer.borderWidth = 0
        
        startButton.setTitle("Start", for: .normal)
        leftButton.setTitle("", for: .normal)
        middleButton.setTitle("", for: .normal)
        rightButton.setTitle("", for: .normal)
    }
    
    private func configureModeCell() {
        leftButton.setTitle("Aperture", for: .normal)
        middleButton.setTitle("Shutter", for: .normal)
        rightButton.setTitle("Manual", for: .normal)
    }
    
    @objc private func pressStartButton() {
        pressButton(nil)
    }
    
    @objc private func pressIntroButton() {
        pressButton(Segment.intro)
    }
    
    @objc private func pressDemoButton() {
        pressButton(Segment.demo)
    }
    
    @objc private func pressPracticeButton() {
        pressButton(Segment.practice)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commonInit()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let phraseHeight: CGFloat = phrase.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)).height
        let titleHeight: CGFloat = title.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)).height
        return CGSize(width: size.width, height: phraseHeight + titleHeight + buttonHeight + padding)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let contentArea = bounds.insetBy(dx: insets, dy: insets)
        let separatorYOffset = bounds.maxY - padding
        
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: ceil(titleSize.width), height: ceil(titleSize.height))
        
        let phraseSize = phrase.sizeThatFits(contentArea.size)
        let phraseTop = (title.frame.maxY + separatorYOffset)/2 - phraseSize.height/2
        phrase.frame = CGRect(x: contentArea.minX, y: phraseTop, width: ceil(phraseSize.width), height: ceil(phraseSize.height))
        
        horizontalSeparator.frame = CGRect(x: bounds.minX, y: separatorYOffset, width: bounds.width, height: 1)
        leftVerticalSeparator.frame = CGRect(x: buttonWidth, y: separatorYOffset, width: 1, height: padding)
        rightVerticalSeparator.frame = CGRect(x: buttonWidth * 2, y: separatorYOffset, width: 1, height: padding)
        
        startButton.frame = CGRect(x: bounds.midX - buttonWidth/2, y: horizontalSeparator.frame.maxY, width: buttonWidth, height: buttonHeight)
        leftButton.frame = CGRect(x: bounds.minX, y: horizontalSeparator.frame.maxY , width: buttonWidth, height: buttonHeight)
        middleButton.frame = CGRect(x: bounds.midX - buttonWidth/2, y: horizontalSeparator.frame.maxY, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: bounds.midX + buttonWidth/2, y: horizontalSeparator.frame.maxY, width: buttonWidth, height: buttonHeight)
    } 
}
