import UIKit

class TutorialView: UIView{
    private let container = UIView()
    private let pageControl = UIPageControl()
    private let photographyView = PhotographyView.TableViewHandler()
    private let photographyCell = PhotographyCell()
    private let scrollView = UIScrollView()
    private let toolBar = UIToolbar()

    override init (frame: CGRect){
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        container.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        container.layer.cornerRadius = 8
        toolBar.barTintColor = .purple
       // var items = [UIBarButtonItem]()
        //items.append(UIBarButtonSystemItem()
        photographyCell.configureShadow(element: container)
        configurePageControl()
        addSubviews([container, scrollView, toolBar, pageControl])
    }
    
    func configurePageControl(){
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00)
        pageControl.numberOfPages = PhotographySteps.steps.count
        pageControl.pageIndicatorTintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsetsMake(75, 18, 40, 18)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        container.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height)
        
        toolBar.frame = CGRect(x: contentArea.minX, y: bounds.maxY - 60, width: contentArea.width, height: 60)
        
        let pageControlSize = pageControl.sizeThatFits(contentArea.size)
        pageControl.frame = CGRect(x: contentArea.midX - pageControlSize.width/2, y: (container.frame.maxY + bounds.maxY)/2 - pageControlSize.height/2, width: pageControlSize.width, height: pageControlSize.height)
        
        
        scrollView.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.size.width, height: contentArea.size.height)
    }
    
    class PageControlHandler: UIScrollView, UIScrollViewDelegate{
        
        init(){
            super.init(frame: CGRect.zero)
            let tutorial = TutorialView()
            //tutorial.scrollView.delegate = self
            //tutorial.scrollView.isPagingEnabled = true
            tutorial.scrollView.backgroundColor = .blue
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
}
