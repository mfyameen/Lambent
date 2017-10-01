import UIKit
import RxSugar
import RxSwift

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

final class HomeViewController: GAITrackedViewController {
    private let photographyModel = PhotographyModel()
    private let homeView = HomeView()
    
    let content: AnyObserver<Content>
    private let _content = Variable<Content>(Content(sections: [], descriptions: [], introductions: [], exercises: [], instructions: [], updatedInstructions: [], modeIntroductions: []))
    let imageContent: AnyObserver<ImageContent>
    private let _imageContent = Variable<ImageContent>(ImageContent(images: [], cache: NSCache()))
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        content = _content.asObserver()
        imageContent = _imageContent.asObserver()
        super.init(nibName: nil, bundle: nil)

        rxs.disposeBag
            ++ _content <~ photographyModel.content
            ++ homeView.content <~ _content.asObservable()
            ++ _imageContent <~ photographyModel.images
            ++ { [weak self] in self?.pushTutorialViewController($0) } <~ homeView.tutorialSelection
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        title = "Lambent"
        view = homeView
        view.backgroundColor = UIColor.backgroundColor()
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 3
        shadow.shadowColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24), NSAttributedStringKey.shadow: shadow]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenName = "Home"
    }

    func pushTutorialViewController(_ setUp: TutorialSetUp) -> Void {
        navigationController?.pushViewController(TutorialViewController(setUp: setUp, content: _content.value, imageContent: _imageContent.value), animated: true)
    }
}


