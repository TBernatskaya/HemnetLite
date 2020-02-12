import UIKit

class PropertiestListViewController: UIViewController {

    var viewModel: PropertiesListViewModel

    init(viewModel: PropertiesListViewModel = PropertiesListViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.fetchPropertiesList(completion: { list, error in
            print(list)
            print(error)
            list?.items.forEach { print($0.type.rawValue) }
        })
    }
}
