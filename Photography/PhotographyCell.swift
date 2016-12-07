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
    
    static var startTutorial: ()->() = { _ in }
    static let reuseIdentifier = "Cell"
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title.font = UIFont.boldSystemFont(ofSize: 14)
        phrase.font = UIFont.systemFont(ofSize: 12)
        phrase.numberOfLines = 0
        layoutButtons([leftButton, middleButton, rightButton])
        contentView.addSubviews([title, phrase, horizontalSeparator, leftVerticalSeparator, rightVerticalSeparator, leftButton, middleButton, rightButton])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 15
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        let separatorYLocation = bounds.maxY - 45
        
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: titleSize.width, height: titleSize.height)
        
        let phraseSize = phrase.sizeThatFits(contentArea.size)
        phrase.frame = CGRect(x: contentArea.minX, y: (title.frame.maxY + separatorYLocation)/2 - (phraseSize.height/2) + 1, width: phraseSize.width, height: phraseSize.height)
      
        horizontalSeparator.frame = CGRect(x: bounds.minX, y: separatorYLocation, width: bounds.width, height: 1)
        leftVerticalSeparator.frame = CGRect(x: buttonWidth, y: separatorYLocation, width: 1, height: 45)
        rightVerticalSeparator.frame = CGRect(x: buttonWidth * 2, y: separatorYLocation, width: 1, height: 45)
        
        leftButton.frame = CGRect(x: bounds.minX, y: horizontalSeparator.frame.maxY , width: buttonWidth, height: buttonHeight)
        middleButton.frame = CGRect(x: bounds.midX - buttonWidth/2, y: horizontalSeparator.frame.maxY, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: bounds.midX + buttonWidth/2, y: horizontalSeparator.frame.maxY, width: buttonWidth, height: buttonHeight)
    }
    
    func configureCell(_ title: String, _ phrase: String, _ indexPath: IndexPath){
        self.title.text = title
        self.phrase.text = phrase
        self.layer.cornerRadius = 8
        self.selectionStyle = .none
        self.configureShadow(element: self)
        
        if indexPath.section == 0 {
            self.configureIntroductionCellLayout(title, phrase)
            self.middleButton.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
        }else{
            self.configureNonIntroductoryCellLayout(title, phrase)
        }
        setNeedsLayout()
    }
    
    @objc private func pressStartButton(){
        PhotographyCell.startTutorial()
    }
    
    func configureIntroductionCellLayout(_ title: String, _ phrase: String){
        self.leftButton.setTitle("", for: .normal)
        self.middleButton.setTitle("Start", for: .normal)
        self.rightButton.setTitle("", for: .normal)
        self.leftVerticalSeparator.layer.borderWidth = 0
        self.rightVerticalSeparator.layer.borderWidth = 0
        self.layoutSeparators([self.horizontalSeparator])
    }
    
    func configureNonIntroductoryCellLayout(_ title: String, _ phrase: String){
        self.leftButton.setTitle("Intro", for: .normal)
        self.middleButton.setTitle("Demo", for: .normal)
        self.rightButton.setTitle("Practice", for: .normal)
        self.layoutSeparators([self.horizontalSeparator, self.leftVerticalSeparator, self.rightVerticalSeparator])
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
