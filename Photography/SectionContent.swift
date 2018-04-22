import UIKit

class SectionContent: UIView {
    let section = UILabel()
    private let scrollView = FadingScrollView()
    let content = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        section.font = UIFont.boldSystemFont(ofSize: 16)
        section.textAlignment = .center
        addSubview(section)
        content.numberOfLines = 0
        content.font = UIFont.systemFont(ofSize: 14)
        scrollView.bounces = false
        scrollView.isEditable = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        scrollView.addSubview(content)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let sectionHeight = section.sizeThatFits(size).height
        let sectionPadding = sectionHeight == 0 ? 0 : Padding.small
        let contentHeight = content.sizeThatFits(size).height
        let totalHeight = sectionHeight + sectionPadding + contentHeight
        return CGSize(width: size.width, height: totalHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sectionSize = section.sizeThatFits(bounds.size)
        section.frame = CGRect(x: bounds.midX - sectionSize.width/2, y: bounds.minY, width: sectionSize.width, height: sectionSize.height)
        let sectionPadding = sectionSize == .zero ? 0 : Padding.small
        scrollView.frame = CGRect(x: bounds.minX, y: section.frame.maxY + sectionPadding, width: bounds.width, height: bounds.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -Padding.tiny)
        let contentSize = content.sizeThatFits(bounds.size)
        scrollView.contentSize = CGSize(width: bounds.width, height: contentSize.height)
        content.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
    }
}
