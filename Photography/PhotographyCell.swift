import Foundation
import UIKit

class PhotographyCell: UITableViewCell{
    let title = UILabel()
    let phrase = UILabel()
    let middleButton = UIButton()
    let leftButton = UIButton()
    let rightButton = UIButton()
    let horizontalSeparator = UIView()
    let leftVerticalSeparator = UIView()
    let rightVerticalSeparator = UIView()
    
    static let reuseIdentifier = "Cell"
    
    let tableViewHeight = PhotographyView.TableViewHandler.tableViewHeight
    let buttonHeight: CGFloat = 44
    let buttonWidth = (UIScreen.main.bounds.width - 30) * 0.33
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        title.font = UIFont.boldSystemFont(ofSize: 14)
        phrase.font = UIFont.systemFont(ofSize: 12)
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
            $0.setTitleColor(.blue, for: .normal)
            $0.setTitleColor(#colorLiteral(red: 0.5979364514, green: 0.8853133321, blue: 0.9850903153, alpha: 1), for: .highlighted)
            $0.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        })
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
        phrase.frame = CGRect(x: contentArea.minX, y: tableViewHeight * 0.4 - phraseSize.height/2, width: phraseSize.width, height: phraseSize.height)
        
        horizontalSeparator.frame = CGRect(x: bounds.minX, y: tableViewHeight * 0.6, width: bounds.width, height: 1)
        leftVerticalSeparator.frame = CGRect(x: buttonWidth, y: tableViewHeight * 0.6, width: 1, height: tableViewHeight * 0.4)
        rightVerticalSeparator.frame = CGRect(x: buttonWidth * 2, y: tableViewHeight * 0.6, width: 1, height: tableViewHeight * 0.4)
        
        leftButton.frame = CGRect(x: bounds.minX, y: tableViewHeight * 0.8 - buttonHeight/2, width: buttonWidth, height: buttonHeight)
        middleButton.frame = CGRect(x: bounds.midX - buttonWidth/2, y: tableViewHeight * 0.8 - buttonHeight/2, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: bounds.midX + buttonWidth/2, y: tableViewHeight * 0.8 - buttonHeight/2, width: buttonWidth, height: buttonHeight)
    }

}
