import UIKit

extension UIView{
    func addSubviews(_ views: [UIView]) {
        views.forEach{addSubview($0) }
    }
}

struct CellBinding {
    static func bind(view: PhotographyCell, handler: @escaping (Int)->()) {
        view.pressButton = handler
    }
}

class PhotographyView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let view: UITableView
    private let cachedCellForSizing = PhotographyCell()
    private var title = String()
    private var phrase = String()
    
    
    var tableViewContent: PhotographyModel?
    var startTutorial: (TutorialSetUp)->() = { _ in}
    
    
    override init(frame: CGRect) {
        view = UITableView(frame: UIScreen.main.bounds.insetBy(dx: 18, dy: 5), style: .grouped)
        super.init(frame: frame)
        backgroundColor = UIColor.backgroundColor()
        view.register(PhotographyCell.self, forCellReuseIdentifier: PhotographyCell.reuseIdentifier)
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.clipsToBounds = false
        view.showsVerticalScrollIndicator = false
        addSubview(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewContent?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotographyCell.reuseIdentifier, for: indexPath) as? PhotographyCell else { fatalError() }
        CellBinding.bind(view: cell, handler: { [weak self ] segmentedControl in
            let setUp = TutorialSetUp(currentPage: indexPath.section, currentSegment: segmentedControl)
            self?.startTutorial(setUp)
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PhotographyCell else { fatalError() }
        setTitleAndPhrase(index: indexPath.section)
        cell.configureCell(title, phrase)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        setTitleAndPhrase(index: indexPath.section)
        cachedCellForSizing.configureCell(title, phrase)
        return cachedCellForSizing.sizeThatFits(tableView.contentSize).height
    }
    
    private func setTitleAndPhrase(index: Int) {
        title = tableViewContent?.sections[index] ?? ""
        phrase = tableViewContent?.descriptions[index] ?? ""
    }
}



