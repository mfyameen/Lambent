import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach{ addSubview($0) }
    }
}

struct CellBinding {
    static func bind(view: HomeCell, handler: @escaping (Segment)->()) {
        view.pressButton = handler
    }
}

public struct CellContent {
    public var title = String()
    public var phrase = String()
}

public class HomeView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private let cachedCellForSizing = HomeCell()
    private var cellContent = CellContent()
    public var homeContent: Content? {
        didSet {
            tableView.reloadData()
        }
    }
    var startTutorial: (TutorialSetUp)->() = { _ in }
    var navigationController: UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.backgroundColor()
        tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 8
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        addSubview(tableView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let insets: UIEdgeInsets
        let horizontalInsets: CGFloat = 18
        let padding: CGFloat = 16
        if #available(iOS 11.0, *) {
            insets = UIEdgeInsets(top: safeAreaInsets.top, left: horizontalInsets, bottom: safeAreaInsets.bottom + padding, right: horizontalInsets)
        } else {
            insets = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
        }
        tableView.frame = UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return homeContent?.sections.count ?? 0
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
            guard let tracker = GAI.sharedInstance().defaultTracker else { return }
            let eventTracker = GAIDictionaryBuilder.createEvent(
                withCategory: "Home View Section and Segment Selection",
                action: "Select \(page) section",
                label: "Select \(segmentedControl) segment",
                value: 1).build()
            tracker.send(eventTracker as? [AnyHashable : Any])
            self?.startTutorial(setUp)
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
        cellContent.title = homeContent?.sections[index] ?? ""
        cellContent.phrase = homeContent?.descriptions[index] ?? ""
        return cellContent
    }
}



