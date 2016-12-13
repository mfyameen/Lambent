import UIKit

class PhotographyCell: UITableViewCell{
    private let title = UILabel()
    private let phrase = UILabel()
    private let middleButton = UIButton()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let horizontalSeparator = UIView()
    private let leftVerticalSeparator = UIView()
    private let rightVerticalSeparator = UIView()
    
    private let buttonHeight: CGFloat = 45
    private let buttonWidth = (UIScreen.main.bounds.width - 30) * 0.33
    
    var pressButton: (String?)->() = { _ in}

    static let reuseIdentifier = "Cell"
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        contentView.addSubviews([title, phrase, horizontalSeparator, leftVerticalSeparator, rightVerticalSeparator, leftButton, middleButton, rightButton])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 15
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        let separatorYOffset = bounds.maxY - 45
        
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: titleSize.width, height: titleSize.height)
        
        let phraseSize = phrase.sizeThatFits(contentArea.size)
        phrase.frame = CGRect(x: contentArea.minX, y: (title.frame.maxY + separatorYOffset)/2 - (phraseSize.height/2) + 1, width: phraseSize.width, height: phraseSize.height)
      
        horizontalSeparator.frame = CGRect(x: bounds.minX, y: separatorYOffset, width: bounds.width, height: 1)
        leftVerticalSeparator.frame = CGRect(x: buttonWidth, y: separatorYOffset, width: 1, height: 45)
        rightVerticalSeparator.frame = CGRect(x: buttonWidth * 2, y: separatorYOffset, width: 1, height: 45)
        
        leftButton.frame = CGRect(x: bounds.minX, y: horizontalSeparator.frame.maxY , width: buttonWidth, height: buttonHeight)
        middleButton.frame = CGRect(x: bounds.midX - buttonWidth/2, y: horizontalSeparator.frame.maxY, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: bounds.midX + buttonWidth/2, y: horizontalSeparator.frame.maxY, width: buttonWidth, height: buttonHeight)
    }
    
    func commonInit(){
        title.font = UIFont.boldSystemFont(ofSize: 14)
        phrase.font = UIFont.systemFont(ofSize: 12)
        phrase.numberOfLines = 0
        
        layoutSeparators([horizontalSeparator, leftVerticalSeparator, rightVerticalSeparator])
        layoutButtons([leftButton, middleButton, rightButton])
        
        leftButton.setTitle("Intro", for: .normal)
        middleButton.setTitle("Demo", for: .normal)
        rightButton.setTitle("Practice", for: .normal)
        middleButton.isEnabled = false
    }
    
    func layoutSeparators(_ separators: [UIView]){
        separators.forEach({
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = #colorLiteral(red: 0.8861932158, green: 0.8862140179, blue: 0.8862028718, alpha: 1).cgColor
        })
    }
    
    func layoutButtons(_ buttons: [UIButton]){
        buttons.forEach({
            $0.setTitleColor(UIColor(red:0.08, green:0.49, blue:0.98, alpha:1.00), for: .normal)
            $0.setTitleColor(#colorLiteral(red: 0.5979364514, green: 0.8853133321, blue: 0.9850903153, alpha: 1), for: .highlighted)
            $0.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        })
    }
    
    func configureCell(_ title: String, _ phrase: String, _ indexPath: IndexPath){
        self.title.text = title
        self.phrase.text = phrase
        self.layer.cornerRadius = 8
        self.selectionStyle = .none
        self.configureShadow(element: self)

        if title == "Get Started"{
            configureIntroductionCell(title, phrase)
        } else{
            middleButton.isEnabled = true
            leftButton.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
            middleButton.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commonInit()
    }
    
    @objc private func pressRightButton(){
        pressButton("Practice")
    }
    
    @objc private func pressStartButton(){
       pressButton(nil)
    }
    
    func configureIntroductionCell(_ title: String, _ phrase: String){
        middleButton.isEnabled = true
        middleButton.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
        
        layoutSeparators([horizontalSeparator])
        leftVerticalSeparator.layer.borderWidth = 0
        rightVerticalSeparator.layer.borderWidth = 0
        
        leftButton.setTitle("", for: .normal)
        middleButton.setTitle("Start", for: .normal)
        rightButton.setTitle("", for: .normal)
    }

    func configureShadow(element: UIView){
        element.layer.shadowOffset = CGSize(width: 0, height: 0)
        element.layer.shadowColor = UIColor.gray.cgColor
        element.layer.shadowOpacity = 0.5
        element.layer.shadowRadius = CGFloat(3)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let phraseHeight: CGFloat = phrase.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)).height
        let titleHeight: CGFloat = title.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)).height
        return CGSize(width: size.width, height: phraseHeight + titleHeight + buttonHeight + 8 * 6)
    }

}
