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
    
    class TableViewHandler: UITableView, UITableViewDelegate, UITableViewDataSource{
        let steps = PhotographySteps.steps
        let descriptions = PhotographySteps.descriptions
        var view : UITableView
        static var tableViewHeight = CGFloat()
        var referenceCell = PhotographyCell()
        var startAction: ()->() = { _ in }
        
        init(){
            view = UITableView(frame: UIScreen.main.bounds.insetBy(dx: 18, dy: 20), style: .grouped)
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
            
            if indexPath.section == 0 {
                configureIntroductionCellLayout(cell)
                cell.middleButton.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
            }else{
               configureNonIntroductoryCellLayout(cell)
            }
            return cell
        }
        
        @objc private func pressStartButton(){
            startAction()
        }
        
        func configureIntroductionCellLayout(_ cell: PhotographyCell){
            cell.leftButton.setTitle("", for: .normal)
            cell.middleButton.setTitle("Start", for: .normal)
            cell.rightButton.setTitle("", for: .normal)
            cell.leftVerticalSeparator.layer.borderWidth = 0
            cell.rightVerticalSeparator.layer.borderWidth = 0
            cell.layoutSeparators([cell.horizontalSeparator])
        }
        
        func configureNonIntroductoryCellLayout(_ cell: PhotographyCell){
            cell.leftButton.setTitle("Intro", for: .normal)
            cell.middleButton.setTitle("Demo", for: .normal)
            cell.rightButton.setTitle("Practice", for: .normal)
            cell.layoutSeparators([cell.horizontalSeparator, cell.leftVerticalSeparator, cell.rightVerticalSeparator])
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.layer.cornerRadius = 8
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOpacity = 0.7
            cell.layer.shadowRadius = CGFloat(1.5)
            cell.selectionStyle = .none
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return CGFloat(0.5)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return 1
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            TableViewHandler.tableViewHeight = 140
            referenceCell.layoutSubviews()
            return TableViewHandler.tableViewHeight
        }
    }
}
