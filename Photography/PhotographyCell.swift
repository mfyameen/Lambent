import Foundation
import UIKit

class PhotographyCell: UITableViewCell{
    let title = UILabel()
    let phrase = UILabel()
    let startButton = UIButton()
    let introButton = UIButton()
    let demoButton = UIButton()
    let practiceButton = UIButton()
    let separator = UIView()
    //let standardSize = CGFloat(44)
    static let reuseIdentifier = "Cell"
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title.font = UIFont.boldSystemFont(ofSize: 14)
        phrase.font = UIFont.systemFont(ofSize: 12)
        separator.layer.borderWidth = 0.25
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.blue, for: .normal)
        startButton.setTitleColor(#colorLiteral(red: 0.5979364514, green: 0.8853133321, blue: 0.9850903153, alpha: 1), for: .highlighted)
        startButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        addSubviews([title, phrase,startButton, separator])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = CGFloat(15)
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: titleSize.width, height: titleSize.height)
        
        let phraseSize = phrase.sizeThatFits(contentArea.size)
        phrase.frame = CGRect(x: contentArea.minX, y: title.frame.maxY + 5, width: phraseSize.width, height: phraseSize.height)
        
        let separatorSize = separator.sizeThatFits(contentArea.size)
        separator.frame = CGRect(x: bounds.minX, y: phrase.frame.maxY + 10, width: bounds.width, height: 1)
        
        let buttonSize = startButton.sizeThatFits(contentArea.size)
        startButton.frame = CGRect(x: contentArea.midX - buttonSize.width/2, y: separator.frame.maxY + separatorSize.height, width: buttonSize.width, height: buttonSize.height)
        

    }
}
