import UIKit

extension UIView{
    func addSubviews(_ views: [UIView]){
        views.forEach{addSubview($0)}
    }
}

struct CellBinding{
    static func bind(view: PhotographyCell, handler: @escaping ()->()){
        view.pressButton = handler
    }
}

class PhotographyView: UIView, UITableViewDelegate, UITableViewDataSource{
    var tableViewContent: PhotographyModel?
    var startTutorial: ()->() = { _ in}
    
    private var view: UITableView
    private let cachedCellForSizing = PhotographyCell()
    
    override init(frame: CGRect){
        view = UITableView(frame: UIScreen.main.bounds.insetBy(dx: 18, dy: 5), style: .grouped)
        super.init(frame: frame)
        backgroundColor = UIColor(colorLiteralRed: 0.94, green: 0.94, blue: 0.96, alpha: 1)
        view.register(PhotographyCell.self, forCellReuseIdentifier: PhotographyCell.reuseIdentifier)
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.clipsToBounds = false
        addSubview(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return tableViewContent?.steps.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotographyCell.reuseIdentifier, for: indexPath) as? PhotographyCell else{ fatalError()}
        CellBinding.bind(view: cell, handler: {
            self.startTutorial()
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PhotographyCell else { fatalError()}
        let title = tableViewContent?.steps[indexPath.section] ?? ""
        let phrase = tableViewContent?.descriptions[indexPath.section] ?? ""
        cell.configureCell(title, phrase, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = tableViewContent?.steps[indexPath.section] ?? ""
        let phrase = tableViewContent?.descriptions[indexPath.section] ?? ""
        cachedCellForSizing.configureCell(title, phrase, indexPath)
        return cachedCellForSizing.sizeThatFits(tableView.contentSize).height
    }
}



