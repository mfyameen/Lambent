import Foundation
import UIKit

extension UIView{
    func addSubviews(_ views: [UIView]){
        views.forEach{addSubview($0)}
    }
}

class PhotographyView: UIView {
    private let tableView = TableViewHandler()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor(colorLiteralRed: 0.94, green: 0.94, blue: 0.96, alpha: 1)
        addSubview(tableView.view)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = CGFloat(15)
        let insets = UIEdgeInsets(top: inset + 20, left: inset, bottom: inset, right: inset)
        let contentArea = UIEdgeInsetsInsetRect(bounds, insets)
        let tableViewSize = tableView.sizeThatFits(contentArea.size)
        tableView.frame = CGRect(x: contentArea.minX, y: contentArea.minY, width: tableViewSize.width, height: tableViewSize.height)
    }
        

    class TableViewHandler: UITableView, UITableViewDelegate, UITableViewDataSource{
        let steps = PhotographySteps.steps
        let descriptions = PhotographySteps.descriptions
        let view: UITableView
        
        init(){
            view = UITableView(frame: UIScreen.main.bounds.insetBy(dx: 20, dy: 20), style: .grouped)
            
            super.init(frame: CGRect.zero, style: .plain)
            
            view.register(PhotographyCell.self, forCellReuseIdentifier: PhotographyCell.reuseIdentifier)
            view.dataSource = self
            view.delegate = self
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        
        func numberOfSections(in tableView: UITableView) -> Int{
            return steps.count
        }
       
            
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotographyCell.reuseIdentifier, for: indexPath) as? PhotographyCell else{ fatalError()}
            cell.title.text = steps[indexPath.section]
            cell.phrase.text = descriptions[indexPath.section]
            cell.phrase.numberOfLines = 0
            tableView.separatorStyle = .none
            return cell
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.layer.cornerRadius = 8
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = CGFloat(1)
            cell.selectionStyle = .none
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return CGFloat(0.5)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return 1
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           // return
           return CGFloat(150)
        }
    }
}
