import UIKit

extension UIView{
    func addSubviews(_ views: [UIView]){
        views.forEach{addSubview($0)}
    }
}

class PhotographyView: UIView {
    private let tableView = TableViewHandler()
    static var startTutorial: ()-> Void = { _ in}
    override init(frame: CGRect){
    super.init(frame: frame)
    backgroundColor = UIColor(colorLiteralRed: 0.94, green: 0.94, blue: 0.96, alpha: 1)
    addSubview(tableView.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class TableViewHandler: UITableView, UITableViewDelegate, UITableViewDataSource{
        private let steps = PhotographySteps.steps
        private let descriptions = PhotographySteps.descriptions
        var view: UITableView
        private let cachedCellForSizing = PhotographyCell()
        static var tableViewHeight = CGFloat()
        
        init(){
            view = UITableView(frame: UIScreen.main.bounds.insetBy(dx: 18, dy: 5), style: .grouped)
            super.init(frame: CGRect.zero, style: .plain)
            view.register(PhotographyCell.self, forCellReuseIdentifier: PhotographyCell.reuseIdentifier)
            view.dataSource = self
            view.delegate = self
            view.separatorStyle = .none
            view.clipsToBounds = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func numberOfSections(in tableView: UITableView) -> Int{
            return steps.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotographyCell.reuseIdentifier, for: indexPath) as? PhotographyCell else{ fatalError()}
            CellBinding.bind(view: cell, handler: {
//                let alert = UIAlertView()
//                alert.message = "Tapped cell at row \(indexPath.section)"
//                alert.addButton(withTitle: "OK")
//                alert.show()
//                print(indexPath)
               
                PhotographyView.startTutorial()
            })
            return cell
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            guard let cell = cell as? PhotographyCell else { fatalError()}
            let title = steps[indexPath.section]
            let phrase = descriptions[indexPath.section]
            cell.configureCell(title, phrase, indexPath)
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return CGFloat(0.5)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           let title = PhotographySteps.steps[indexPath.section]
           let phrase = PhotographySteps.descriptions[indexPath.section]
           cachedCellForSizing.configureCell(title, phrase, indexPath)
           return cachedCellForSizing.sizeThatFits(tableView.contentSize).height
        }
    }
}

struct CellBinding{
    static func bind(view: PhotographyCell, handler: @escaping ()->()){
        view.pressButton = handler
    }
}

