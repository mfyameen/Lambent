import UIKit

//struct tutorialBinding{
//    static func bind(view: TutorialView, handler: @escaping ()->()){
//        view.pressSelector = handler
//    }
//}

class TutorialView: UIView{
    private let container = UIView()
    private let pageControl = UIPageControl()
    private let photographyView = PhotographyView()
    private let photographyCell = PhotographyCell()
    private let scrollView = UIScrollView()
    private let toolBar = UIToolbar()
    private let title = UILabel()
    private let content = UILabel()
    private var toolBarSize = CGSize()
    private var segmentedControl = UISegmentedControl()
    
    var currentPage: Int?
    
    var tutorialContent: PhotographyModel? {
        didSet{
            var backButtonTitle: String?
            var nextButtonTitle: String?
            let steps = tutorialContent?.steps.count ?? 0
            let title = tutorialContent?.sectionTitles[currentPage ?? 0] ?? ""
            let content = tutorialContent?.content[currentPage ?? 0] ?? ""
        
            if (currentPage ?? 0) > 0 && (currentPage ?? 0) < steps - 1 {
                backButtonTitle = tutorialContent?.steps[(currentPage ?? 0) - 1 ]
                nextButtonTitle = tutorialContent?.steps[(currentPage ?? 0) + 1]
            } else if (currentPage ?? 0) <= 0{
                backButtonTitle = nil
                nextButtonTitle = tutorialContent?.steps[(currentPage ?? 0) + 1] ?? ""
            } else if (currentPage ?? 0) >= steps - 1{
                backButtonTitle = tutorialContent?.steps[(currentPage ?? 0) - 1] ?? ""
                nextButtonTitle = nil
            }
            
            configureContent(currentTitle: title, currentContent: content)
            configureToolBar(backButtonTitle, nextButtonTitle)
            configurePageControl(steps)
        }
    }
    var nextSection:(Int)->Void = { _ in}
    var previousSection: (Int)->Void = { _ in}
    var pressSelector: ()->() = { _ in}
    
    override init (frame: CGRect){
        super.init(frame: frame)
        currentPage = UserDefaults.standard.integer(forKey: "page#")
        if currentPage == nil{
            currentPage = 0
        }
        backgroundColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        container.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        container.layer.cornerRadius = 8
        
        title.font = UIFont.boldSystemFont(ofSize: 14)
        content.font = UIFont.systemFont(ofSize: 14)
        content.numberOfLines = 0

        photographyCell.configureShadow(element: container)
        configureSegmentedControl(currentPage ?? 0)
        addSubviews([container, segmentedControl, title, content, scrollView, toolBar, pageControl])
    }
    
    func configureContent(currentTitle: String, currentContent: String){
            title.text = currentTitle
            content.text = currentContent
    }
    
    func configurePageControl(_ steps: Int){
        pageControl.isEnabled = false
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00)
        pageControl.numberOfPages = steps
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPage = currentPage ?? 0

    }
    
    @objc private func segmentedControlValueChanged(){
        pressSelector()
    }
    
    
    func updateValues(segment: UISegmentedControl){
        switch segment.selectedSegmentIndex{
        case 0: self.configureContent(currentTitle: "0", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
        case 1: self.configureContent(currentTitle: "1", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
        case 2: self.configureContent(currentTitle: "2", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
        default: break
        }
    
    }

    func configureSegmentedControl(_ currentPage: Int){
        if currentPage != 0{
            segmentedControl = UISegmentedControl(items: ["Intro", "Demo", "Practice"])
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
            
            
//            tutorialBinding.bind(view: self, handler: {
//                print("hello")
//                //            switch segmentedControl.selectedSegmentIndex{
//                //            case 0: self?.configureContent(currentTitle: "0", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
//                //            case 1: self?.configureContent(currentTitle: "1", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
//                //            case 2: self?.configureContent(currentTitle: "2", currentContent: "ijfal;skfja;sldfkjas;lfkjasdl;fk")
//                //            default: break
//                //            }
//            })
//        }
    }
    }
    @objc private func loadNextSection(){
        currentPage = (currentPage ?? 0) + 1
        //pageControl.isEnabled = true
        nextSection(currentPage ?? 0)
    }
    
    @objc private func loadPreviousSection(){
        currentPage = (currentPage ?? 0) - 1
        previousSection(currentPage ?? 0)
    }
    
    func configureToolBar(_ backButtonTitle: String?, _ nextButtonTitle: String?){
        let backButton = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: #selector(loadPreviousSection))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: nextButtonTitle, style: .plain, target: self, action: #selector(loadNextSection))

        if nextButtonTitle == nil{
            nextButton.isEnabled = false
        } else if backButtonTitle == nil{
            backButton.isEnabled = false
        }
        
        if currentPage == 0{
            toolBar.items = [flexibleSpace, nextButton]
        } else {
            toolBar.items = [backButton, flexibleSpace, nextButton]
        }
        toolBar.barTintColor = #colorLiteral(red: 0.953121841, green: 0.9536409974, blue: 0.9688723683, alpha: 1)
        toolBar.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 75, left: 18, bottom: 75, right: 18)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        container.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.width, height: contentArea.height)
        
        let segmentedHeight = segmentedControl.sizeThatFits(contentArea.size).height
        let segmentedWidth = contentArea.width - insets.left - insets.right
        segmentedControl.frame = CGRect(x: contentArea.midX - segmentedWidth/2, y: contentArea.minY + 20, width: segmentedWidth, height: segmentedHeight)
        
        let titleSize = title.sizeThatFits(contentArea.size)
        title.frame = CGRect(x: contentArea.midX - titleSize.width/2, y: container.frame.minY + 40, width: titleSize.width, height: titleSize.height)

        let contentHeight = content.sizeThatFits(contentArea.size).height
        let contentWidth = contentArea.width - insets.left - insets.right
        content.frame = CGRect(x: contentArea.midX - contentWidth/2, y: title.frame.maxY + 40, width: contentWidth, height: contentHeight)
        
        let pageControlSize = pageControl.sizeThatFits(contentArea.size)
        pageControl.frame = CGRect(x: contentArea.midX - pageControlSize.width/2, y: (container.frame.maxY + bounds.maxY)/2 - pageControlSize.height/2, width: pageControlSize.width, height: pageControlSize.height)
        
        let toolBarHeight = toolBar.sizeThatFits(contentArea.size).height
        toolBar.frame = CGRect(x: contentArea.minX, y: (container.frame.maxY + bounds.maxY)/2 - toolBarHeight/2, width: contentArea.width, height: toolBarHeight)

        scrollView.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: contentArea.size.width, height: contentArea.size.height)
    }
}
    
//    class PageControlHandler: UIScrollView, UIScrollViewDelegate{
//        
//        init(){
//            super.init(frame: CGRect.zero)
//            let tutorial = TutorialView()
//            //tutorial.scrollView.delegate = self
//            //tutorial.scrollView.isPagingEnabled = true
//            tutorial.scrollView.backgroundColor = .blue
//            
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//    }
//}
