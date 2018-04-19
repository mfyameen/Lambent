import UIKit
import RxSugar
import RxSwift

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

struct CellBinding {
    static func bind(view: HomeCell, handler: @escaping (Segment) -> Void) {
        view.pressButton = handler
    }
}

public struct CellContent {
    public var title = String()
    public var phrase = String()
}

public class HomeView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let container = UIView()
    private let tableView = UITableView()
    private let cachedCellForSizing = HomeCell()
    private var cellContent = CellContent()
    
   let content: AnyObserver<Content>
    private let _content = Variable<Content>(Content(sections: [], descriptions: [], introductions: [], exercises: [], instructions: [], updatedInstructions: [], modeIntroductions: []))
    let tutorialSelection: Observable<TutorialSetUp>
    private let _tutorialSelection = PublishSubject<TutorialSetUp>()
    
    override init(frame: CGRect) {
        content = _content.asObserver()
        tutorialSelection = _tutorialSelection.asObservable()
        super.init(frame: frame)
        backgroundColor = UIColor.backgroundColor()
        container.clipsToBounds = true
        container.layer.cornerRadius = 8
        addSubview(container)
        tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.clipsToBounds = false
        tableView.layer.cornerRadius = 8
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        container.addSubview(tableView)
        
        rxs.disposeBag
            ++  tableView.rxs.reloadData <~ _content.asObservable().toVoid()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let insets: UIEdgeInsets
        let horizontalInsets: CGFloat = 18
        if #available(iOS 11.0, *) {
            insets = UIEdgeInsets(top: safeAreaInsets.top, left: horizontalInsets, bottom: safeAreaInsets.bottom + Padding.large, right: horizontalInsets)
        } else {
            insets = UIEdgeInsets(top: 64, left: horizontalInsets, bottom: Padding.large, right: horizontalInsets)
            tableView.contentInset = .zero
        }
        container.frame = UIEdgeInsetsInsetRect(bounds, insets)
        let shadowInset = HelperMethods.shadowRadius
        tableView.frame = container.bounds.insetBy(dx: shadowInset, dy: shadowInset)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return _content.value.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseIdentifier, for: indexPath) as? HomeCell else { fatalError() }
        CellBinding.bind(view: cell, handler: { [weak self] segmentedControl in
            guard let page = Page(rawValue: indexPath.section) else { return }
            let setUp = TutorialSetUp(currentPage: page, currentSegment: segmentedControl)
            self?._tutorialSelection.onNext(setUp)

        })
        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeCell else { fatalError() }
        guard let page = Page(rawValue: indexPath.section) else { return }
        cellContent = setTitleAndPhrase(index: indexPath.section)
        cell.configure(cellContent, for: page)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let page = Page(rawValue: indexPath.section) else { return 0 }
        let content = setTitleAndPhrase(index: indexPath.section)
        cachedCellForSizing.configure(content, for: page)
        return cachedCellForSizing.sizeThatFits(tableView.contentSize).height
    }
    
   public func setTitleAndPhrase(index: Int) -> CellContent {
        cellContent.title = _content.value.sections[index]
        cellContent.phrase = _content.value.descriptions[index] 
        return cellContent
    }
}
