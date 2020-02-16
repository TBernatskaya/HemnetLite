import UIKit

class PropertiesListViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    var viewModel: PropertiesListViewModel
    var openDetails: (Property) -> ()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PropertyCell.self, forCellWithReuseIdentifier: PropertyCell.reuseIdentifier)
        collectionView.register(AreaCell.self, forCellWithReuseIdentifier: AreaCell.reuseIdentifier)
        return collectionView
    }()


    init(viewModel: PropertiesListViewModel, openDetails: @escaping (Property) -> ()) {
        self.viewModel = viewModel
        self.openDetails = openDetails
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sök bostad"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        updateList()
        updateConstraints()
        styleNavigationBar()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let flowLayout = collectionView.collectionViewLayout
        flowLayout.invalidateLayout()
    }

    private func updateConstraints() {
        let topMargin = (self.navigationController?.navigationBar.frame.height ?? 60) + 16
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topMargin),
            collectionView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -32),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }

    private func styleNavigationBar() {
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.autoresizingMask = [.flexibleWidth]
        let titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let tintcolor: UIColor = .systemGreen

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = titleTextAttributes
            navBarAppearance.titleTextAttributes = titleTextAttributes
            navBarAppearance.backgroundColor = tintcolor
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
        } else {
            navigationBar.barTintColor = tintcolor
            navigationBar.titleTextAttributes = titleTextAttributes
        }
        navigationBar.tintColor = .white
    }

    private func updateList() {
        // TODO: add loading indicator
        viewModel.fetchPropertiesList(completion: { list, errorMessage in
            if let _ = list {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else { self.presentAlert(with: errorMessage) }
        })
    }

    private func presentAlert(with title: String?) {
        let title = title ?? "Unknown error"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PropertiesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let list = viewModel.list else { return 0 }
        return list.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let list = viewModel.list else { return UICollectionViewCell() }

        let item = list.items[indexPath.row]
        switch item.type {
        case .area:
            return configureAreaCell(with: item, indexPath: indexPath)
        default:
            return configurePropertyCell(with: item, indexPath: indexPath)
        }
    }

    private func configureAreaCell(with item: Property, indexPath: IndexPath) -> AreaCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AreaCell.reuseIdentifier,
            for: indexPath
        ) as! AreaCell

        viewModel.downloadImage(from: item.image, completion: { image in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        })

        cell.title.text = "Område"
        cell.area.text = item.area
        item.averagePrice.map { cell.price.text = "Snittpris: " + $0 }
        item.rating.map { cell.rating.text = "Betyg: " + $0 }
        return cell
    }

    private func configurePropertyCell(with item: Property, indexPath: IndexPath) -> PropertyCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PropertyCell.reuseIdentifier,
            for: indexPath
        ) as! PropertyCell

        viewModel.downloadImage(from: item.image, completion: { image in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        })
        
        cell.streetAddress.text = item.streetAddress
        cell.area.text = item.area
        cell.price.text = item.askingPrice
        if item.type == .highlighted { cell.setImageBorder() }
        return cell
    }
}

extension PropertiesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let list = viewModel.list else { return }
        let item = list.items[indexPath.row]
        // TODO: prevent user from double tap
        openDetails(item)
    }
}

extension PropertiesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 230)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
