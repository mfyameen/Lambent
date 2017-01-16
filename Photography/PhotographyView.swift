import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach{ addSubview($0) }
    }
}

struct CellBinding {
    static func bind(view: PhotographyCell, handler: @escaping (Segment?)->()) {
        view.pressButton = handler
    }
}

public class PhotographyView: UIView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    private let tableView: UITableView
    private let cachedCellForSizing = PhotographyCell()
    public var tableViewContent: PhotographyModel?
    static var hideNavigationBar = false
    
    var startTutorial: (TutorialSetUp)->() = { _ in }
    
    override init(frame: CGRect) {
        tableView = UITableView(frame: UIScreen.main.bounds.insetBy(dx: 18, dy: 5), style: .grouped)
        super.init(frame: frame)
        backgroundColor = UIColor.backgroundColor()
        tableView.register(PhotographyCell.self, forCellReuseIdentifier: PhotographyCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        tableView.showsVerticalScrollIndicator = false
        addSubview(self.tableView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewContent?.sections.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotographyCell.reuseIdentifier, for: indexPath) as? PhotographyCell else { fatalError() }
        CellBinding.bind(view: cell, handler: { [weak self ] segmentedControl in
            guard let page = Page(rawValue: indexPath.section) else { return }
            let setUp = TutorialSetUp(currentPage: page, currentSegment: segmentedControl)
            self?.startTutorial(setUp)
        })
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PhotographyCell else { fatalError() }
        guard let page = Page(rawValue: indexPath.section) else { return }
        let (title, phrase) = setTitleAndPhrase(index: indexPath.section)
        cell.configureCell(title, phrase, page)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let page = Page(rawValue: indexPath.section) else { return 0 }
        let (title, phrase) = setTitleAndPhrase(index: indexPath.section)
        cachedCellForSizing.configureCell(title, phrase, page)
        return cachedCellForSizing.sizeThatFits(tableView.contentSize).height
    }
    
    public func setTitleAndPhrase(index: Int) -> (String, String) {
        let title = tableViewContent?.sections[index] ?? ""
        let phrase = tableViewContent?.descriptions[index] ?? ""
        return (title, phrase)
    }
}



